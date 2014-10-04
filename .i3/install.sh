CWD=$(dirname $PWD/$0)

# http://blog.hugochinchilla.net/2013/03/using-gnome-3-with-i3-window-manager/

ln -s $CWD/gnome-i3.desktop /usr/share/xsessions/gnome-i3.desktop
ln -s $CWD/i3.session /usr/share/gnome-session/sessions/i3.session

gsettings set org.gnome.desktop.background show-desktop-icons false
