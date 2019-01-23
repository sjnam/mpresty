return require("gxn.base"):new {
   cmd = "mpost",
   ext = "mp",
   tag_name = "mplibcode",
   preamble = [[prologues:=3; outputtemplate:="%j.svg"; outputformat:="svg";]],
   postamble = "end;",
}
