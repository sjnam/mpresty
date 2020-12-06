-- Author:  Soojin Nam, jsunam@gmail.com
-- License: Public Domain


local shell = require "resty.shell"
local requests = require "resty.requests"


local ipairs = ipairs
local io_open = io.open
local concat = table.concat
local setmetatable = setmetatable
local digest = ngx.md5
local log = ngx.log
local ERR = ngx.ERR
local ngx_var = ngx.var
local re_find = ngx.re.find
local ngx_shared = ngx.shared
local wait = ngx.thread.wait
local spawn = ngx.thread.spawn
local capture = ngx.location.capture
local run = shell.run
local http_request = requests.get


local img_fmt = "/svgs"
local image_dir = ngx_var.document_root..img_fmt
local mpresty_script = "mpresty.sh"
local mpresty_cache = ngx_shared.mpresty_cache


local _M = {
   outputfmt = "svg",
   preamble = "",
   postamble = "",
   fn_update_node = function (node, uri, content)
      node.localName = "img"
      node:setAttribute("src", uri)
      if not node:hasAttribute("width") then
         node:setAttribute("width", "300")
      end
      if node:hasAttribute("code") then
         node:setAttribute("alt", content)
         node:removeAttribute("code")
      end
   end
}


local function get_contents (node, use_cache)
   local uri = node:getAttribute("src")
   if not uri then
      return node.textContent, nil
   end
   node:removeAttribute("src")

   local content = use_cache and mpresty_cache:get(uri) or nil
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


local function error_fn_update_node (node, uri, content)
   node.localName = "pre"
   node.textContent = content
   node:setAttribute("style", "color:red")
   node:removeAttribute("width")
end


local function make_input_file (self, fname, content)
   local f, err = io_open(concat{image_dir, "/", fname, ".", self.ext}, "w")
   if not f then
      log(ERR, "error: ", err)
      return err
   end
   f:write(concat({self.preamble, content, self.postamble}, "\n"))
   f:close()
end


local function get_image_uri (self, node, fname)
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

   return concat{img_fmt, "/", fname, ".", self.outputfmt}
end


local function do_update_document (self, node, fn_update_node)
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
   local uri = use_cache and mpresty_cache:get(key) or nil
   if not uri then
      err = make_input_file(self, fname, content)
      if err then
         log(ERR, "error: ", err)
         return nil, err
      end
      uri, err = get_image_uri(self, node, fname)
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

   for _, c in ipairs(node.childNodes) do
      c:remove();
   end
   update_node(node, uri, content)
   update_node = nil
end


function _M:update_document (doc, fn_update_node)
   self.doc = doc
   local threads = {}
   for _, node in ipairs(doc:getElementsByTagName(self.tag_name)) do
      threads[#threads + 1] = spawn(do_update_document,
                                    self, node, fn_update_node)
   end

   for _, th in ipairs(threads) do
      local ok, res, err = wait(th)
      if not ok then
         log(ERR, "error: ", err)
         return nil, err
      end
   end
   self.cur_update_node = nil
   return self.doc
end


function _M:new (gx)
   return setmetatable(gx or {}, { __index = _M })
end


function _M:set_fn_update_node (fn_update_node)
   self.cur_update_node = fn_update_node
end


return _M
