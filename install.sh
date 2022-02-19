#!/usr/bin/env sh

echo "Copying palette to config directory ..."
cp dracula.soc "$XDG_CONFIG_HOME"/libreoffice/*/user/config/

echo "Running add-dracula-application-colors.sh ..."
./add-dracula-application-colors.sh
