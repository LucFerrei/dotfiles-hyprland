# voyager.zsh-theme
# Requer Nerd Font. Estilo powerline clássico com segmentos e setas ( ).
# Segmento git muda de COR conforme o estado (limpo=verde, sujo=amarelo, conflito=vermelho).

function voyager_git_segment() {
  command git rev-parse --is-inside-work-tree &>/dev/null || return

  local branch icon color status_text ahead behind conflicts dirty untracked
  branch=$(command git symbolic-ref --short HEAD 2>/dev/null || command git rev-parse --short HEAD 2>/dev/null)
  status_text=$(command git status --porcelain -b 2>/dev/null)

  conflicts=$(echo "$status_text" | grep -c '^UU')
  dirty=$(echo "$status_text" | grep -cE '^.[MDAR]')
  untracked=$(echo "$status_text" | grep -c '^??')
  ahead=$(echo "$status_text" | grep -o 'ahead [0-9]*' | grep -o '[0-9]*')
  behind=$(echo "$status_text" | grep -o 'behind [0-9]*' | grep -o '[0-9]*')

  if [[ "$conflicts" -gt 0 ]]; then
    color="red"; icon="\uf071"
  elif [[ "$dirty" -gt 0 || "$untracked" -gt 0 ]]; then
    color="yellow"; icon="\uf040"
  else
    color="green"; icon="\uf00c"
  fi

  local sync=""
  [[ -n "$ahead" ]]  && sync+=" \uf062${ahead}"
  [[ -n "$behind" ]] && sync+=" \uf063${behind}"

  echo "%{$bg[$color]%}%{$fg_bold[black]%} \ue0a0 ${branch} ${icon}${sync} %{$reset_color%}%{$fg[$color]%}\ue0b0%{$reset_color%}"
}

PROMPT='%{$bg[blue]%}%{$fg_bold[white]%} %n \ue0b1 %c %{$reset_color%}%{$fg[blue]%}\ue0b0%{$reset_color%} $(voyager_git_segment) '

RPROMPT='%(?:%{$fg[green]%}\uf00c %{$reset_color%}:%{$fg[red]%}\uf00d %?%{$reset_color%})'
