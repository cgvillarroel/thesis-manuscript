write-host -nonewline "Converting to HTML... `t"
new-item -type directory output -erroraction ignore > $null
remove-item output/manuscript.pdf -erroraction ignore > $null
asciidoctor -r asciidoctor-bibtex -b html5 src/manuscript.adoc -o output/manuscript.html
write-host "Done"
