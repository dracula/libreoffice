### [LibreOffice](https://www.libreoffice.org)

#### Install using Git

If you are a git user, you can install the theme and keep up to date by cloning the repo:

    $ git clone https://github.com/dracula/libreoffice.git

#### Install manually

Download using the [GitHub .zip download](https://github.com/dracula/libreoffice/archive/master.zip) option and unzip them.

#### Activating palette

1. Copy `dracula.soc` to `~/.config/libreoffice/*/user/config/` (Linux),
   `C:\Program Files\LibreOffice\share\palette` (Windows), or
   `~/Library/Application Support/LibreOffice/*/user/config/` (macOS).
2. Choose the dracula palette when picking a color in LibreOffice.

#### Activating Application Colors (Linux and macOS only)

*Note that this is a bit experimental and might break your settings file. It
first saves a backup to* `registrymodifications.xcu.bak`, *which you can use if
anything goes wrong*.

1. Run `./add_dracula_application_colors.sh` to add the Dracula option to the
   settings file
2. Choose Dracula in *Tools -> Options -> Application Colors* (Linux) or
   *Preferences -> LibreOffice -> Application Colors* (macOS)

