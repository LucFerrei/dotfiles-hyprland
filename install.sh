#!/bin/bash

HYPRLAND_REPO="https://github.com/LucFerrei/dotfiles-hyprland.git"
STANDARD_REPO="https://github.com/LucFerrei/dotfiles.git"

dot_config_dir=("hypr" "nvim" "waybar" "xournalpp" "kitty")
dot_files_home=(".tmux.conf" ".zshrc")

echo "----DOTFILES INSTALLING----"

read -p "Do you want to install hyprland or gnome/kde dotfiles? (hyprland) or (Standard)? " dotfiles_name

clone_n_create_dir() {
  echo "creating dotfiles directory"
  mkdir dotfiles
  git clone "$1" dotfiles
  return 0
}

if [[ "$dotfiles_name" == "hyprland" ]]; then
  echo "downloading hyprland dotfiles"
  clone_n_create_dir "$HYPRLAND_REPO"

else
  echo "downloading standard dotfiles"
  clone_n_create_dir "$STANDARD_REPO"

fi

prepare_tmux() {
  #this functions install tpm for tmux
  if [[ -e "$HOME/.tmux" ]]; then
    echo "Removing tmux dir..."
    rm -rf "$HOME/.tmux"
  fi

  mkdir -p "$HOME/.tmux/plugins/tpm"
  git clone "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"
}

ask_for_exclude() {
  #$1 file/dir
  if [[ -e "$1" ]]; then
    read -p "Do you want to delete $1? (Y/n) " response

    response_lower=$(echo "$response" | tr '[:upper:]' '[:lower:]')

    if [[ "$response_lower" == "y" || "$response_lower" == "yes" ]]; then
      rm -rf "$1"
    fi

  else
    echo "$1 was not removed"
  fi
}

create_sym_links() {
  for dir in "${dot_config_dir[@]}"; do
    local path="$HOME/dotfiles/$dir"
    ask_for_exclude path
    ln -sf "$HOME/dotfiles/$dir" "$HOME/.config/$dir"
  done

  #need this to use .tmux correctly
  prepare_tmux

  for file in "${dot_files_home[@]}"; do
    local path="$HOME/dotfiles/$file"
    ask_for_exclude path
    ln -sf "$HOME/dotfiles/$file" "$HOME/$file"
  done

}

create_sym_links

#link starship
ln -sf "$HOME/dotfiles/starship.toml" "$HOME/.config/starship.toml"
