return require("mpresty.base"):new {
    tag_name = "mplibcode",
    cmd = "mpost",
    ext = "mp",
    preamble = [[
                 prologues:=3;
                 outputtemplate:="%j.svg";
                 outputformat:="svg";
               ]],
    postamble = "end",
}
