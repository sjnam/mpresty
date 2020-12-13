return require("mpresty.base"):new {
   tag_name = "tikzpicture",
   cmd = "pdflatex",
   ext = "tex",
   preamble = [[
                 \documentclass[tikz]{standalone}
                 \usepackage{pgfplots}
                 \usepackage{xifthen}
                 \usetikzlibrary{arrows, backgrounds, calc, intersections}
                 \usetikzlibrary{matrix, mindmap, positioning, shapes}
                 \begin{document}
               ]],
   postamble = "\\end{document}",
   run = [[cd %s && %s _FNAME_.tex && pdf2svg _FNAME_.pdf _FNAME_.svg && rm _FNAME_.tex _FNAME_.aux _FNAME_.pdf _FNAME_.log]],
}
