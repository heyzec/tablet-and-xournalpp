# tablet-and-xournalpp
Scripts I made to make my life easier while using my drawing tablet with the handwriting note-taking app [Xournal++](https://github.com/xournalpp/xournalpp).

There are two parts to this repository.

Tested on:
- OS: Ubuntu 20.04
- Xournal++: 1.1.0+dev
- Tablet: HUION Inspiroy Ink H320M


## 1. Automatic tablet mappings
On Linux, a Wacom tablet or a compatible drawing tablet that uses [`xsetwacom`](https://linux.die.net/man/1/xsetwacom) to change its programmable buttons will not retain its settings when it is disconnected. The scripts here will set the customisations whenever the system detects the drawing tablet.

### Installation
1. Download the three files: [`tablet.rules`](./tablet.rules), [`wrapper.sh`](./wrapper.sh) and [`tablet_config.sh`](./tablet_config.sh) files to a folder on your device. This folder shouldn't be moved after installation.
2. Edit the pathname in `tablet.rules` and username in `wrapper.sh`.
3. Copy (or symlink) `tablet.rules` to within the folder `/etc/udev/rules.d/`.
4. Edit the `STYLUS` and `PAD` variables in `tablet_config.sh` to the identifying names of your drawing tablet. You can check this using the command `xsetwacom list`.
5. Edit the `tablet_config.sh` file to add your own customisations.


## 2. Xournal++ Toggler plugin
This is a Xournal++ custom [plugin](https://xournalpp.github.io/guide/plugins/plugins/) written in Lua. It provides a collection of keyboard shortcuts (Alt 1 to Alt 6) to toggle between commonly used tools.

### Installation
1. Download the [Toggler](./Toggler) folder.
2. Copy (or symlink) the entire folder to Xournal++ [installation folder](https://xournalpp.github.io/guide/plugins/plugins/#installation-folder) path. (`/usr/share/xournalpp/plugins/` for Linux)


## Default settings
If both parts are installed, then here are the default settings:

|Device|Action|Effect|
|---|---|---|
|Stylus|Second button|[Single press] Toggle between pen and eraser tools|
|Stylus|Second button|[Double press] Change to hand tool|
|Stylus|Third button|Undo|
|Tablet|Button 1|Cycle through selector tools (Select Object, Select Region)|
|Tablet|Button 2|Cycle through drawing shape tools (Rectangle, Ellipse, Arrow)|
|Tablet|Button 3|Cycle through line styles (Solid, Dashed, Dash-Dotted, Dotted)|
|Tablet|Up|Zoom in|
|Tablet|Down|Zoom out|
|Tablet|Middle|Toggle menus|
|Tablet|Left|Decrease pen size|
|Tablet|Right|Increase pen size|
|Tablet|Button 4|Change to highlighter tool|
|Tablet|Button 5|Toggle pen colors (via the [ColorCycle](https://xournalpp.github.io/guide/plugins/notable) plugin bundled with Xournal++)|
|Tablet|Button 6|_No effect currently_|
