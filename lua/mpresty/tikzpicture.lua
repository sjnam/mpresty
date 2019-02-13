return require("mpresty.base"):new {
   tag_name = "tikzpicture",
   cmd = "pdflatex",
   ext = "tex",
   preamble = [[
                \documentclass[tikz]{standalone}
                \usepackage{pgfplots}
                \usetikzlibrary{calc,intersections}
                \begin{document}
              ]],
   postamble = "\\end{document}",
}
