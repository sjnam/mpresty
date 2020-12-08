return require("mpresty.base"):new {
   tag_name = "tikzpicture",
   cmd = "pdflatex",
   ext = "tex",
   preamble = [[
                 \documentclass[tikz]{standalone}
                 \usepackage{pgfplots}
                 %\usepackage{fourier}
                 \usepackage{xifthen}
                 \usetikzlibrary{arrows, backgrounds, calc, intersections}
                 \usetikzlibrary{matrix, mindmap, positioning, shapes}
                 \begin{document}
               ]],
   postamble = "\\end{document}",
}
