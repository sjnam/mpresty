return require("resty.gxn.base"):new {
   cmd = "mpost",
   ext = "mp",
   tag_name = "mplibcode",
   preamble = [[
                prologues:=3; outputtemplate:="%j.svg"; outputformat:="svg";
                %input boxes;
                %input graph;
                %input featpost3Dplus2D;
              ]],
   postamble = "end;",
}

