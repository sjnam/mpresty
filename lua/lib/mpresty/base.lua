-- Author:  Soojin Nam, jsunam@gmail.com
-- License: Public Domain


local shell = require "resty.shell"
local requests = require "resty.requests"

local open = io.open
local ipairs = ipairs
local concat = table.concat
local sformat = string.format
local setmetatable = setmetatable
local log = ngx.log
local ERR = ngx.ERR
local run = shell.run
local ngx_var = ngx.var
local re_find = ngx.re.find
local re_gsub = ngx.re.gsub
local wait = ngx.thread.wait
local digest = ngx.crc32_long
local ngx_shared = ngx.shared
local spawn = ngx.thread.spawn
local http_request = requests.get
local capture = ngx.location.capture
local mpresty_cache = ngx_shared.mpresty_cache


local _M = {
   use_cache = true,
   workdir = "/images",
   fn_update_node = function (doc, node, uri, content)
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

   local content = use_cache and mpresty_cache:get(uri)
   if not content then
      if not re_find(uri, "^https?://") then
         if re_find(uri, "/") then
            content = capture(uri).body
         else
            content = capture(ngx_var.uri:match("(.*[/\\])")..uri).body
         end
      else
         local res, err = http_request(uri)
         if not res then
            log(ERR, "error: ", err)
            return nil, err
         end
         content = res:body()
      end
      mpresty_cache:set(uri, content)
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
   local f, err = open(concat{ngx_var.document_root..self.workdir,
                              "/", fname, ".", self.ext}, "w")
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
   local run_script = sformat(self.run, ngx_var.document_root..self.workdir,
                              self.cmd)
   local script, n, err = re_gsub(run_script, "_FNAME_", fname, "i")
   if not script then
      log(ERR, "error: ", err)
      return nil, err
   end

   local ok, stdout = run(script)
   if not ok then
      log(ERR, "error: fail to run command")
      return nil, stdout
   end
   return concat{self.workdir, "/", fname, ".svg"}
end


local function update_doc (self, node, fn_update_node)
   local update_node = fn_update_node or
      (self.cur_update_node or self.fn_update_node)

   local use_cache = self.use_cache and node:getAttribute("cache") ~= "no"
   node:removeAttribute("cache")

   local content, err = get_contents(node, use_cache)
   if not content then
      log(ERR, "error: ", err)
      return nil, err
   end

   self.cmd = node:getAttribute("cmd") or self.cmd
   node:removeAttribute("cmd")

   local fname = self.cmd..digest(content)
   local key = self.tag_name..fname
   local uri = use_cache and mpresty_cache:get(key)
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

   for _, n in ipairs(node.childNodes) do
      n:remove()
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
   for _, th in ipairs(threads) do
      local ok, res = wait(th)
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


_M.update_doc = update_doc


return _M
