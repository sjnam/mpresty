-- Copyright (C) 2018-2019, Soojin Nam


return require("resty.gxn.base"):new {
   cmd = "mpost",
   ext = "mp",
   tag_name = "mplibcode",
   preamble = [[prologues:=3; outputtemplate:="%j.svg"; outputformat:="svg";]],
   postamble = "end;",
}

