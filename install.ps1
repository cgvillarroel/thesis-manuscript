write-host "Checking if Scoop is installed... `t"

# INSTALL SCOOP
scoop --version
if (-not $?) {
	write-host "Scoop is not installed. Installing..."
	Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
	Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
	write-host "Done"
}
write-host "Scoop is installed."

# INSTALL DEPENDENCIES AVAILABLE ON SCOOP
write-host "Installing dependencies from Scoop..."
scoop install aria2
scoop config aria2-warning-enabled false
scoop install pandoc pdftk msys2
scoop install ruby
scoop install miktex
write-host "Installed dependencies from Scoop."

# INSTALL RUBY DEPENDENCIES
write-host "Installing Ruby dependencies..."
ridk install 3
write-host "Installed Ruby dependencies."

# INSTALL ASCIIDOCTOR & EXTENSION
write-host "Installing Asciidoctor and extension..."
gem install asciidoctor
gem install asciidoctor-bibtex
write-host "Installed Asciidoctor and extension."

write-host "Finished installing dependencies."
write-host "Please update MiKTeX through the MiKTeX Console."
