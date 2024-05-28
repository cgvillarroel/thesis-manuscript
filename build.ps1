remove-item -r build
remove-item -r output
asciidoctor -r asciidoctor-bibtex -b docbook5 manuscript.adoc -o build/manuscript.xml
if (-not $?) { exit 1 }
pandoc -d opts.yaml
if (-not $?) { exit 1 }
# pandoc escapes latex in docbooks
(get-content build/manuscript.tex).replace("\{", "{").replace("\}", "}").replace("\textbackslash ", "\").replace("ieee", "ieeetr") | set-content build/manuscript.tex
if (-not $?) { exit 1 }
xelatex build/manuscript.tex -aux-directory=build -output-directory=output
if (-not $?) { exit 1 }
bibtex build/manuscript
if (-not $?) { exit 1 }
# build twice for citation references
xelatex build/manuscript.tex -aux-directory=build -output-directory=output
xelatex build/manuscript.tex -aux-directory=build -output-directory=output
