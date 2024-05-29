# CLEAN BUILD DIRECTORIES
write-host -nonewline "Cleaning old build artifacts... `t"
new-item -type directory build -erroraction ignore > $null
new-item -type directory output -erroraction ignore > $null
remove-item build/* -erroraction ignore > $null
remove-item output/* -erroraction ignore > $null
write-host "Done"

# CONVERT TO LATEX
write-host -nonewline "Converting to DocBook... `t`t"
asciidoctor -r asciidoctor-bibtex -b docbook5 src/manuscript.adoc -o build/manuscript.xml
if (-not $?) { exit 1 }
write-host "Done"

write-host -nonewline "Converting to LaTeX... `t`t`t"
pandoc -d opts.yaml
if (-not $?) { exit 1 }
write-host "Done"

# pandoc escapes latex in docbooks & ieee is called ieeetr in bibtex
write-host -nonewline "Tweaking LaTeX file... `t`t`t"
(get-content build/manuscript.tex).replace("\{", "{").replace("\}", "}").replace("\textbackslash ", "\").replace("ieee", "ieeetr") | set-content build/manuscript.tex
write-host "Done"

# BUILD LATEX
write-host -nonewline "Building LaTeX (1st pass)... `t`t"
xelatex build/manuscript.tex -aux-directory=build -output-directory=build > $null
if (-not $?) { exit 1 }
write-host "Done"

write-host -nonewline "Processing citations... `t`t"
bibtex build/manuscript > $null
if (-not $?) { exit 1 }
write-host "Done"

write-host -nonewline "Building LaTeX (2nd pass)... `t`t"
xelatex build/manuscript.tex -aux-directory=build -output-directory=build > $null
write-host "Done"

write-host -nonewline "Building LaTeX (final pass)... `t`t"
xelatex build/manuscript.tex -aux-directory=build -output-directory=build > $null
if (-not $?) { exit 1 }
write-host "Done"

# TITLE PAGE (I don't wanna recreate this in latex)
write-host -nonewline "Adding cover page... `t`t`t"
pdftk cover.pdf build/manuscript.pdf cat output output/manuscript.pdf
write-host "Done`n"

write-host "Done building. See ./output/manuscript.pdf"
