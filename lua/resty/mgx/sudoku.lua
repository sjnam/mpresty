return require("resty.mgx.base"):new {
   cmd = "sudoku-solver",
   ext = "dlx",
   tag_name = "sudoku",
   outputfmt = "html",
   fn_update_node = function (self, node, uri, content)
      node.localName = "iframe"
      node:setAttribute("src", uri)
      end
}

