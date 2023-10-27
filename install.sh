#!/bin/bash

DOTFILES=`pwd`

if ! type "dconf" > /dev/null; then
  sudo apt update -y
  sudo apt install -y  dconf-cli dconf-editor

  export DISPLAY=:0.0
  sudo apt install -y dbus-x11
  dbus-launch
  export $(dbus-launch)
fi

if [ ! -d `~/.config` ]; then
  mkdir ~/.config
fi

echo 'Installing the needed softwares'
curl -sS https://starship.rs/install.sh | sudo sh
touch ~/.config/starship.toml

dconf load /org/gnome/terminal/ < $DOTFILES/bash/gnome-terminal.properties

echo 'Creating the simlinks'
cat $DOTFILES/git/.gitconfig > ~/.gitconfig
ln -sf $DOTFILES/git/.gitconfig ~/.gitconfig

cat $DOTFILES/bash/.bashrc > ~/.bashrc
ln -sf $DOTFILES/bash/.bashrc ~/.bashrc

cat $DOTFILES/bash/starship.toml > ~/.config/starship.toml
ln -sf $DOTFILES/bash/starship.toml ~/.config/starship.toml

if ! type "code" > /dev/null; then
  sudo apt install -y software-properties-common apt-transport-https wget gpg

  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg

  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt update -y

  sudo apt install -y code
fi

cat $DOTFILES/vscode/settings.json > ~/.config/Code/User/settings.json
ln -sf $DOTFILES/vscode/settings.json ~/.config/Code/User/settings.json

cat $DOTFILES/vscode/keybindings.json > ~/.config/Code/User/keybindings.json
ln -sf $DOTFILES/vscode/keybindings.json ~/.config/Code/User/keybindings.json

echo 'Installing VSCode plugins'
while IFS="" read -r extension || [ -n "$extension" ]
do
  code --install-extension $extension
done < $DOTFILES/vscode/extensions.md
