-- Copyright (C) 2018, Soojin Nam


return require("resty.gxn.base"):new {
   cmd = "pdflatex",
   ext = "tex",
   tag_name = "tikzpicture",
   preamble = [[
                \documentclass[tikz]{standalone}
                %\usepackage{istgame}
                \usetikzlibrary{calc}
                \begin{document}
              ]],
   postamble = "\\end{document}",
}

