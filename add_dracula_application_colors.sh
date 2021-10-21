#!/bin/sh

# check platform
if [ "$(uname)" = "Linux" ]; then
	fname="$HOME/.config/libreoffice/*/user/registrymodifications.xcu"
elif [ "$(uname)" = "Darwin" ]; then
	# macOS doesn't have realpath, let's do it in a more janky way
	fname="$HOME/Library/Application Support/LibreOffice/*/user/registrymodifications.xcu"
else
	echo "Unsupported kernel, aborting..."
	exit 1
fi

# expand glob
fname="$(compgen -G "$fname")"

# make a copy
if ! [ -f registrymodifications.xcu.bak ]; then
	cp "$fname" registrymodifications.xcu.bak
fi

# check a bunch of things and abort if it's different to expected
if ! [ -f "$fname" ]; then
	echo "Settings file doesn't exist in expected location, aborting..."
	exit 1
elif ! head -n1 "$fname" | egrep -q '^<\?xml version\=' ||
		! head -n2 "$fname" | tail -n1 | egrep -q '^<oor:items'
then
	echo "Settings file doesn't match expected format, aborting..."
	exit 1
fi

# check if theme appears to be installed
existing_theme="$(grep -n \
	'<item oor:path="/org.openoffice.Office.UI/ColorScheme/ColorSchemes"><node oor:name="dracula"' \
	"$fname")"
exit_code=$?
theme_line="$(echo "$existing_theme" | sed 's|:.*||')"

if [ $exit_code -eq 0 ]; then
	echo "Dracula theme appears to already be installed, replacing..."
	# replace existing theme line
	sed -i 's|<item oor:path="/org.openoffice.Office.UI/ColorScheme/ColorSchemes"><node oor:name="dracula"'"|$(cat dracula.xcu | tr -d '\n')|" \
		"$fname"
else
	# insert theme after first two lines
	new_settings="$(head -n2 "$fname" && cat dracula.xcu \
					&& tail -n +3 "$fname")"
	# write new settings to settings file
	echo "$new_settings" > "$fname"
fi

