#!/bin/bash

STYLUS="HUION Huion Tablet_H320M Pen stylus"  # Change these two variables accordingly to output from xsetwacom list
PAD="HUION Huion Tablet_H320M Pad pad"


if ! xsetwacom list | grep -q "$PAD"; then
    exit 1
fi

sleep 1

# For use on second monitor (this command requires a time delay when called from trigger)
xsetwacom set "$STYLUS" MapToOutput DP-1-1


# Pen Buttons
xsetwacom set "$STYLUS" button 1 1                    # (stick to default stylus action)
xsetwacom set "$STYLUS" button 2 key Alt 1            # Plugin: togglePen()
xsetwacom set "$STYLUS" button 3 key Ctrl Z           # Undo

# Top Buttons
xsetwacom set "$PAD" button 1 key Alt 4               # Plugin: toggleSelector()
xsetwacom set "$PAD" button 2 key Alt 5               # Plugin: toggleShapes()
xsetwacom set "$PAD" button 3 key Alt 6               # Plugin: toggleLineStyle()

# Round Buttons (Top, Bottom, Middle, Left, Right)
xsetwacom set "$PAD" button 8 key Ctrl Shift \=       # (Ctrl +) Xournalpp: Zoom in
xsetwacom set "$PAD" button 9 key Ctrl -              # Xournalpp: Zoom out
xsetwacom set "$PAD" button 10 key F9 F10 F12         # Xournalpp: Toggle toolbar, menubar, sidebar
xsetwacom set "$PAD" button 11 key Alt 2              # Plugin: toolSizeIncrease()
xsetwacom set "$PAD" button 12 key Alt 3              # Plugin: toolSizeDecrease()


# Bottom Buttons
xsetwacom set "$PAD" button 13 key Ctrl Shift H       # Xournalpp: Highlighter
xsetwacom set "$PAD" button 14 key Alt C              # Xournalpp: ColorCycle plugin
# xsetwacom set "$PAD" button 15 key Ctrl Z


exit 0
