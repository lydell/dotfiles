#!/usr/bin/env bash

dir="$(dirname "$BASH_SOURCE")"

delay=0
while read command; do
  name=$(basename "$(echo "$command" | cut -d ' ' -f 1)")
   >"$HOME/.config/autostart/$name.desktop" echo \
"[Desktop Entry]
Type=Application
Exec=$command
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=$delay
Name=$name
Comment="
  ((delay++))
done <"$dir/commands"
