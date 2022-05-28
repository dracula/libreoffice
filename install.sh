#!/bin/sh

echo "Copying palette to config directory ..."
cp dracula.soc "${XDG_CONFIG_HOME:-$HOME/.config}"/libreoffice/*/user/config/

if [ "$(uname)" = "FreeBSD" ]; then
	echo "Running add-dracula-application-colors.sh ..."
	./add-FreeBSD-dracula-application-colors.sh
else
	echo "Running add-dracula-application-colors.sh ..."
	./add-dracula-application-colors.sh
fi
