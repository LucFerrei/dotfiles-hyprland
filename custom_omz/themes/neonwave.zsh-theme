# neonwave.zsh-theme
# Requer Nerd Font. Visual "cyberpunk": magenta/ciano vibrantes, branch em caixa
# com ícone de cadeado se detached HEAD, e indicadores de status como badges.

function neonwave_git() {
  command git rev-parse --is-inside-work-tree &>/dev/null || return

  local branch icon_branch status_text staged dirty untracked ahead behind conflicts out detached
  if branch=$(command git symbolic-ref --short HEAD 2>/dev/null); then
    icon_branch="\ue0a0"
  else
    branch=$(command git rev-parse --short HEAD 2>/dev/null)
    icon_branch="\uf023"
    detached=1
  fi

  status_text=$(command git status --porcelain -b 2>/dev/null)
  conflicts=$(echo "$status_text" | grep -c '^UU')
  staged=$(echo "$status_text" | grep -cE '^[MADRC]')
  dirty=$(echo "$status_text" | grep -cE '^.[MD]')
  untracked=$(echo "$status_text" | grep -c '^??')
  ahead=$(echo "$status_text" | grep -o 'ahead [0-9]*' | grep -o '[0-9]*')
  behind=$(echo "$status_text" | grep -o 'behind [0-9]*' | grep -o '[0-9]*')

  out="%{$fg[cyan]%}\ue0b6%{$bg[black]%}%{$fg_bold[magenta]%} ${icon_branch} ${branch} "

  [[ "$conflicts" -gt 0 ]]  && out+="%{$fg[red]%}\uf071 "
  [[ -n "$ahead" ]]         && out+="%{$fg[green]%}\uf062${ahead} "
  [[ -n "$behind" ]]        && out+="%{$fg[red]%}\uf063${behind} "
  [[ "$staged" -gt 0 ]]     && out+="%{$fg[green]%}\uf055${staged} "
  [[ "$dirty" -gt 0 ]]      && out+="%{$fg[yellow]%}\uf040${dirty} "
  [[ "$untracked" -gt 0 ]]  && out+="%{$fg[white]%}\uf128${untracked} "
  [[ "$conflicts" -eq 0 && "$staged" -eq 0 && "$dirty" -eq 0 && "$untracked" -eq 0 ]] && out+="%{$fg[green]%}\uf00c "

  out+="%{$reset_color%}%{$fg[black]%}\ue0b4%{$reset_color%}"
  echo " $out"
}

PROMPT='%{$fg_bold[magenta]%}\ue0b6%{$bg[magenta]%}%{$fg_bold[white]%} \uf310 %c %{$reset_color%}%{$fg[magenta]%}\ue0b4%{$reset_color%}$(neonwave_git)
%{$fg[magenta]%}❯❯%{$reset_color%} '
