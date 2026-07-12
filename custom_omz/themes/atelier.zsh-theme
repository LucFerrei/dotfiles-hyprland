# atelier.zsh-theme
# Requer Nerd Font. Visual "profissional/editorial": tons neutros, tipografia limpa,
# branch com ícone e status como texto pequeno ao lado — nada de blocos de fundo.

function atelier_git() {
  command git rev-parse --is-inside-work-tree &>/dev/null || return

  local branch status_text staged dirty untracked ahead behind stashed parts=()
  branch=$(command git symbolic-ref --short HEAD 2>/dev/null || command git rev-parse --short HEAD 2>/dev/null)
  status_text=$(command git status --porcelain -b 2>/dev/null)

  staged=$(echo "$status_text" | grep -cE '^[MADRC]')
  dirty=$(echo "$status_text" | grep -cE '^.[MD]')
  untracked=$(echo "$status_text" | grep -c '^??')
  ahead=$(echo "$status_text" | grep -o 'ahead [0-9]*' | grep -o '[0-9]*')
  behind=$(echo "$status_text" | grep -o 'behind [0-9]*' | grep -o '[0-9]*')
  stashed=$(command git stash list 2>/dev/null | wc -l | tr -d ' ')

  [[ -n "$ahead" ]]  && parts+=("%{$fg[cyan]%}\uf062$ahead")
  [[ -n "$behind" ]] && parts+=("%{$fg[cyan]%}\uf063$behind")
  [[ "$staged" -gt 0 ]] && parts+=("%{$fg[green]%}\uf055$staged")
  [[ "$dirty" -gt 0 ]] && parts+=("%{$fg[yellow]%}\uf040$dirty")
  [[ "$untracked" -gt 0 ]] && parts+=("%{$fg[red]%}\uf128$untracked")
  [[ "$stashed" -gt 0 ]] && parts+=("%{$fg[blue]%}\uf01c$stashed")

  local status_str=""
  if [[ ${#parts[@]} -gt 0 ]]; then
    status_str=" ${(j: :)parts}%{$reset_color%}"
  else
    status_str=" %{$fg[green]%}\uf00c%{$reset_color%}"
  fi

  echo "%{$fg[240]%}on%{$reset_color%} %{$fg_bold[white]%}\ue0a0 ${branch}%{$reset_color%}${status_str}"
}

PROMPT='%{$fg_bold[white]%}%~%{$reset_color%} %{$fg[240]%}$(atelier_git)%{$reset_color%}
%{$fg[240]%}▸%{$reset_color%} '

RPROMPT='%(?..%{$fg[red]%}exit %?%{$reset_color%})'
