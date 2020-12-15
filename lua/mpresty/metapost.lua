return require("base"):new {
   tag_name = "metapost",
   cmd = "mpost",
   ext = "mp",
   preamble = [[
                 prologues:=3;
                 outputtemplate:="%j.svg";
                 outputformat:="svg";
               ]],
   postamble = "end",
   run = [[cd %s && %s _FNAME_.mp && rm _FNAME_.log _FNAME_.mp*]],
}

