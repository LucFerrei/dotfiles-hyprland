# aurora.zsh-theme
# Requer Nerd Font. Prompt em "pills" (blocos de cor) com branch e status detalhado:
#  branch          untracked          staged           modified           ahead/behind

function aurora_git_info() {
  local ref branch dirty staged untracked ahead behind out=""
  ref=$(command git symbolic-ref --short HEAD 2>/dev/null) || \
  ref=$(command git rev-parse --short HEAD 2>/dev/null) || return

  branch="$ref"
  local status_text
  status_text=$(command git status --porcelain -b 2>/dev/null)

  staged=$(echo "$status_text" | grep -c '^[MADRC]')
  dirty=$(echo "$status_text" | grep -c '^.[MD]')
  untracked=$(echo "$status_text" | grep -c '^??')
  ahead=$(echo "$status_text" | grep -o 'ahead [0-9]*' | grep -o '[0-9]*')
  behind=$(echo "$status_text" | grep -o 'behind [0-9]*' | grep -o '[0-9]*')

  out="%{$fg_bold[white]%}%{$bg[magenta]%} \ue0a0 ${branch} %{$reset_color%}"

  [[ -n "$ahead" ]]  && out+="%{$fg[cyan]%} \uf062${ahead}%{$reset_color%}"
  [[ -n "$behind" ]] && out+="%{$fg[cyan]%} \uf063${behind}%{$reset_color%}"
  [[ "$staged" -gt 0 ]] && out+="%{$fg[green]%} \uf055${staged}%{$reset_color%}"
  [[ "$dirty" -gt 0 ]] && out+="%{$fg[yellow]%} \uf040${dirty}%{$reset_color%}"
  [[ "$untracked" -gt 0 ]] && out+="%{$fg[red]%} \uf128${untracked}%{$reset_color%}"

  echo " $out"
}

local ret_status="%(?:%{$fg_bold[green]%}\uf00c:%{$fg_bold[red]%}\uf00d)"

PROMPT='%{$fg_bold[blue]%}%{$bg[blue]%} \uf07c %{$fg_bold[white]%}%{$bg[blue]%}%c %{$reset_color%}$(aurora_git_info)
${ret_status}%{$reset_color%} '

RPROMPT='%{$fg[grey]%}%*%{$reset_color%}'
