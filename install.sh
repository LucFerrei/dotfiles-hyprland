#!/bin/bash

dot_config_dir=("hypr" "nvim" "waybar" "xournalpp" "kitty" "btop")
dot_files_home=(".tmux.conf" ".zshrc")

echo "----DOTFILES INSTALLING----"

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

    else
      echo "$1 was not removed"
    fi
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
