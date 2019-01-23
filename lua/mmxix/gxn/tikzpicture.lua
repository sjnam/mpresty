return require("gxn.base"):new {
   cmd = "pdflatex",
   ext = "tex",
   tag_name = "tikzpicture",
   preamble = [[
                \documentclass[tikz]{standalone}
                \usepackage{pgfplots}
                \usetikzlibrary{calc,intersections}
                \begin{document}
              ]],
   postamble = "\\end{document}",
}
