# serene.zsh-theme
# Requer Nerd Font. Visual limpo e "silencioso": cores suaves, ícones só aparecem
# quando há algo relevante a dizer. Duas linhas, prompt final com seta fina.

function serene_git() {
  command git rev-parse --is-inside-work-tree &>/dev/null || return

  local branch status_text staged dirty untracked ahead behind stashed out
  branch=$(command git symbolic-ref --short HEAD 2>/dev/null || command git rev-parse --short HEAD 2>/dev/null)
  status_text=$(command git status --porcelain -b 2>/dev/null)

  staged=$(echo "$status_text" | grep -cE '^[MADRC]')
  dirty=$(echo "$status_text" | grep -cE '^.[MD]')
  untracked=$(echo "$status_text" | grep -c '^??')
  ahead=$(echo "$status_text" | grep -o 'ahead [0-9]*' | grep -o '[0-9]*')
  behind=$(echo "$status_text" | grep -o 'behind [0-9]*' | grep -o '[0-9]*')
  stashed=$(command git stash list 2>/dev/null | wc -l | tr -d ' ')

  out="%{$fg[240]%}\ue0a0%{$fg[magenta]%} ${branch}%{$reset_color%}"

  [[ -n "$ahead" ]]     && out+="%{$fg[cyan]%} \uf062${ahead}%{$reset_color%}"
  [[ -n "$behind" ]]    && out+="%{$fg[cyan]%} \uf063${behind}%{$reset_color%}"
  [[ "$staged" -gt 0 ]] && out+="%{$fg[green]%} \uf055${staged}%{$reset_color%}"
  [[ "$dirty" -gt 0 ]]  && out+="%{$fg[yellow]%} \uf040${dirty}%{$reset_color%}"
  [[ "$untracked" -gt 0 ]] && out+="%{$fg[red]%} \uf128${untracked}%{$reset_color%}"
  [[ "$stashed" -gt 0 ]] && out+="%{$fg[blue]%} \uf01c${stashed}%{$reset_color%}"

  echo " $out"
}

PROMPT='
%{$fg_bold[white]%}%~%{$reset_color%}$(serene_git)
%(?.%{$fg[white]%}.%{$fg[red]%})❯%{$reset_color%} '

RPROMPT='%{$fg[240]%}%D{%H:%M}%{$reset_color%}'
