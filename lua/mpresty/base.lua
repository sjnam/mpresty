-- Author:  Soojin Nam, jsunam@gmail.com
-- License: Public Domain


local shell = require "resty.shell"
local requests = require "resty.requests"


local ipairs = ipairs
local io_open = io.open
local concat = table.concat
local setmetatable = setmetatable
local log = ngx.log
local ERR = ngx.ERR
local run = shell.run
local digest = ngx.crc32_long
local ngx_var = ngx.var
local re_find = ngx.re.find
local wait = ngx.thread.wait
local ngx_shared = ngx.shared
local spawn = ngx.thread.spawn
local http_request = requests.get
local capture = ngx.location.capture


local imgdir = "/svgs"
local image_dir = ngx_var.document_root..imgdir
local mpresty_script = "mpresty.sh"
local mpresty_cache = ngx_shared.mpresty_cache


local _M = {
   ['outputfmt'] = "svg",
   ['fn_update_node'] = function (doc, node, uri, content)
      node.localName = "img"
      node:setAttribute("src", uri)
      if not node:hasAttribute("width") then
         node:setAttribute("width", "300")
      end
   end
}


local mt = { __index = _M }


local function get_contents (node, use_cache)
   local uri = node:getAttribute("src")
   if not uri then
      return node.textContent, nil
   end
   node:removeAttribute("src")

   local content
   if use_cache then
      content = mpresty_cache:get(uri)
   end
   if not content then
      if not re_find(uri, "^https?://") then
         content = capture(uri).body
      else
         local res, err = http_request(uri)
         if not res then
            log(ERR, "error: ", err)
            return nil, err
         end
         content = res:body()
      end
      if use_cache then
         mpresty_cache:set(uri, content)
      end
   end
   return content
end


local function error_fn_update_node (doc, node, uri, content)
   node.localName = "pre"
   node.textContent = content
   node:setAttribute("style", "color:red")
   node:removeAttribute("width")
end


local function source_file (self, fname, content)
   local f, err = io_open(concat{image_dir, "/", fname, ".", self.ext}, "w")
   if not f then
      log(ERR, "error: ", err)
      return err
   end
   f:write(self.preamble or "")
   f:write(content)
   f:write(self.postamble or "")
   f:close()
end


local function image_uri (self, node, fname)
   local cmd = node:getAttribute("cmd") or ""
   if cmd == "" then
      cmd = self.cmd
   end
   local ok, stdout = run {
      mpresty_script, image_dir, self.tag_name, fname,
      self.ext, self.outputfmt, cmd
   }
   if not ok then
      log(ERR, "error: fail to run command")
      return nil, stdout
   end
   return concat{imgdir, "/", fname, ".", self.outputfmt}
end


local function update_doc (self, node, fn_update_node)
   local update_node = fn_update_node or
      (self.cur_update_node or self.fn_update_node)

   local use_cache = mpresty_cache and node:getAttribute("cache") ~= "no"
   node:removeAttribute("cache")

   local content, err = get_contents(node, use_cache)
   if not content then
      log(ERR, "error: ", err)
      return nil, err
   end

   local fname = digest(content)
   local key = self.tag_name..fname
   local uri
   if use_cache then
      uri = mpresty_cache:get(key)
   end
   if not uri then
      err = source_file(self, fname, content)
      if err then
         log(ERR, "error: ", err)
         return nil, err
      end
      uri, err = image_uri(self, node, fname)
      if err then
         update_node = error_fn_update_node
         content = err
      else
         if use_cache then
            mpresty_cache:set(key, uri)
         end
      end
   end
   node:removeAttribute("cmd")

   for _, n in ipairs(node.childNodes) do
      n:remove();
   end
   update_node(self.doc, node, uri, content)
   update_node = nil
end


function _M:update_document (doc, fn_update_node)
   self.doc = doc
   local threads = {}
   for _, node in ipairs(doc:getElementsByTagName(self.tag_name)) do
      threads[#threads+1] = spawn(update_doc, self, node, fn_update_node)
   end
   for i=1,#threads do
      local ok, res = wait(threads[i])
      if not ok then
         log(ERR, "error: ", res)
         return nil, res
      end
   end
   self.cur_update_node = nil
   return self.doc
end


function _M:new (o)
   return setmetatable(o or {}, mt)
end


function _M:set_fn_update_node (fn_update_node)
   self.cur_update_node = fn_update_node
end


return _M
