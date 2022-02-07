#!/bin/bash
# wrapper.sh
# Wrapper file for tablet_config.sh, called by udev when it detects tablet plugged in
# See https://unix.stackexchange.com/a/575453

USERNAME=heyzec  # Change username here

# Drop privilges from root to user - https://stackoverflow.com/a/29969243
if [ $UID -eq 0 ]; then
    user=$1
    dir=$2
    shift 2     # if you need some other parameters
    cd "$dir"
    exec su "$USERNAME" "$0" -- "$@"
    # nothing will be executed beyond that line,
    # because exec replaces running process with the new one
fi

# Use notify-send but from any env - https://stackoverflow.com/a/49533938
function notify-send() {
    # Detect the name of the display in use
    local display=":$(ls /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"

    # Detect the user using such display
    local user=$(who | grep '('$display')' | awk '{print $1}' | head -n 1)

    # Detect the id of the user
    local uid=$(id -u $user)

    sudo -u $user DISPLAY=$display DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus notify-send "$@"
}

export -f notify-send  # Export function as env var (bash)
export DISPLAY=:0
export XAUTHORITY=/home/$USERNAME/.Xauthority

cd "${0%/*}"

# Make a subshell
(
    # Loop until devices are present
    for ((retries=0; retries<5; retries++)); do

        if ./tablet_config.sh; then
            notify-send "Tablet Config" "Successfully ran drawing tablet configuration script"
            exit 0
        fi
        sleep 1
    done

    notify-send "Tablet Config" "Devices not present after timeout"

    exit 0 # Not sure if exit 1 would cause any issues
) &

exit 0
