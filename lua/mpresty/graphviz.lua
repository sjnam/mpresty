return require("base"):new {
   tag_name = "graphviz",
   cmd = "dot",
   ext = "gv",
   run = [[cd %s && %s -Tsvg _FNAME_.gv -o _FNAME_.svg && rm _FNAME_.gv]],
}
