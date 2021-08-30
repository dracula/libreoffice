#!/bin/sh

# check platform
if [ "$(uname)" = "Linux" ]; then
	fname=$HOME/.config/libreoffice/*/user/registrymodifications.xcu
elif [ "$(uname)" = "Darwin" ]; then
	fname=$HOME/Library/Application Support/LibreOffice/*/user/config/
else
	echo "Unsupported kernel, aborting..."
	exit 1
fi

# expand glob
fname=$(realpath $fname)

cp $fname registrymodifications.xcu.bak

# check a bunch of things and abort if it's different to expected
if ! [ -f $fname ]; then
	echo "Settings file doesn't exist in expected location, aborting..."
	exit 1
elif ! tail -n1 $fname | egrep -q '^</oor:items>$'; then
	echo "Settings file doesn't match expected format, aborting..."
	exit 1
fi

# check if theme appears to be installed
existing_theme="$(grep -n \
	'<item oor:path="/org.openoffice.Office.UI/ColorScheme/ColorSchemes"><node oor:name="dracula"' \
	$fname)"
exit_code=$?
theme_line="$(echo "$existing_theme" | sed 's|:.*||')"

if [ $exit_code -eq 0 ]; then
	echo "Dracula theme appears to already be installed, replacing..."
	# replace existing theme line
	settings_start="$(head -n $theme_line $fname | head -n -1)"
	settings_end="$(tail -n +$theme_line $fname | tail -n +2)"
	new_settings="$(echo "$settings_start" \
	             && cat dracula.xcu \
				 && echo "$settings_end")"
else
	# insert theme between last two lines
	new_settings="$(head -n -1 $fname && cat dracula.xcu && tail -n1 $fname)"
fi

# write new settings to settings file
echo "$new_settings" > $fname
