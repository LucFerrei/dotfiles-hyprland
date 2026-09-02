#!/usr/bin/env bash

PATHS=($HOME $HOME/work $HOME/personal $HOME/learning)


get_dirs() {
    for path in "${PATHS[@]}"
    do
	fd --base-directory ${path} --type dir --max-depth 1 --absolute-path -H
    done
    
}

## returns the selected path
fzf_dirs() {
    get_dirs | fzf
}

# go_to_selected_path () {
#     local path=$1
#     cd $path && zsh
# }


selected=$(fzf_dirs)
echo $selected

