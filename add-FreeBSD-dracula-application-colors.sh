#!/bin/sh

# Check OS platform
if [ "$(uname)" = "FreeBSD" ]; then
	fname=$(echo "$(cd ${XDG_CONFIG_HOME:-$HOME/.config}/libreoffice/*/user/ && pwd)"/registrymodifications.xcu)
else
	echo "Unsupported kernel. Aborting ..."
	exit 1
fi

# Create backup of LibreOffice registry before modifications
cp -i "$fname" registrymodifications.xcu.bak

# Check settings file
if ! [ -f "$fname" ]; then
	echo "Settings file doesn't exist in expected location. Aborting ..."
	exit 1
elif ! tail -n 1 "$fname" | grep -E -q '^</oor:items>$'; then
	echo "Settings file doesn't match expected format. Aborting ..."
	exit 1
fi

# Check if color scheme it present already
existing_theme="$(grep -n \
	'<item oor:path="/org.openoffice.Office.UI/ColorScheme/ColorSchemes"><node oor:name="Dracula"' \
	$fname)"
exit_code=$?
theme_line="$(echo "$existing_theme" | sed 's|:.*||')"

if [ $exit_code -eq 0 ]; then
	echo "Dracula theme appears to already be installed. Replacing it ..."
	# Replace existing line with
	settings_start="$(head -n $theme_line $fname | sed \$d)"
	settings_end="$(tail -n +$theme_line $fname | tail -n +2)"
        new_settings="$(echo "$settings_start" \
                       && cat dracula.xcu \
                       && echo "$settings_end")"
else
	# Insert theme between last two lines if not present
	new_settings="$(sed \$d $fname && cat dracula.xcu && tail -n 1 $fname)"
fi

# Write new settings to settings file
echo "$new_settings" > "$fname"
