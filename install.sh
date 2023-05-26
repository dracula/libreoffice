#!/bin/sh

echo "Copying palette to config directory ..."
if [ "$(uname)" = "Linux" ]; then
	cp dracula.soc "${XDG_CONFIG_HOME:-$HOME/.config}"/libreoffice/*/user/config/
elif [ "$(uname -o)" = "Msys" ]; then
	cp dracula.soc "$HOME/AppData/Roaming/LibreOffice"/*/user/config/
elif [ "$(uname)" = "Darwin" ]; then
	cp dracula.soc "$HOME/Library/Application Support/LibreOffice"/*/user/config/
else
	echo "Unsupported operating system. Aborting ..."
fi

if [ "$(uname)" = "FreeBSD" ]; then
	echo "Running add-FreeBSD-dracula-application-colors.sh ..."
	./add-FreeBSD-dracula-application-colors.sh
else
	echo "Running add-dracula-application-colors.sh ..."
	./add-dracula-application-colors.sh
fi
