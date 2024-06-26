write-host -nonewline "Converting to HTML... `t"
new-item -type directory output -erroraction ignore > $null
remove-item output/manuscript.html -erroraction ignore > $null
asciidoctor -r asciidoctor-bibtex -b html5 src/manuscript.adoc -o output/manuscript.html
write-host "Done`n"
write-host "Done building. See ./output/manuscript.html"
