return require("resty.mgx.base"):new {
   cmd = "pdflatex",
   ext = "tex",
   tag_name = "tikzpicture",
   preamble = [[\documentclass[tikz]{standalone}\usepackage{istgame}\usetikzlibrary{calc}\begin{document}]],
   postamble = [[\end{document}]],
}
