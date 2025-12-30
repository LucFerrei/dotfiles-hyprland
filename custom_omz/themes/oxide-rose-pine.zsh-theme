# Oxide theme for Zsh
#
# Author: Diki Ananta <diki1aap@gmail.com>
# Repository: https://github.com/dikiaap/dotfiles
# License: MIT

# Prompt:
# %F => Color codes
# %f => Reset color
# %~ => Current path
# %(x.true.false) => Specifies a ternary expression
#   ! => True if the shell is running with root privileges
#   ? => True if the exit status of the last command was success
#
# Git:
# %a => Current action (rebase/merge)
# %b => Current branch
# %c => Staged changes
# %u => Unstaged changes
#
# Terminal:
# \n => Newline/Line Feed (LF)

# Rosé Pine theme for Zsh - Versão Otimizada
setopt PROMPT_SUBST

autoload -U add-zsh-hook
autoload -Uz vcs_info

if [[ "${terminfo[colors]}" -ge 256 ]]; then
    # Definições Rosé Pine (xterm 256)
    oxide_pine="%F{30}"       # Verde/Teal (Substitui o vermelho em locais de sucesso)
    oxide_rose="%F{181}"      # Rose (Pêssego/Dourado)
    oxide_love="%F{168}"      # Vermelho (Apenas para erros/alertas)
    oxide_foam="%F{116}"      # Turquesa/Ciano
    oxide_iris="%F{183}"      # Roxo/Lavanda (Para o diretório)
else
    oxide_pine="%F{green}"
    oxide_rose="%F{yellow}"
    oxide_love="%F{red}"
    oxide_foam="%F{cyan}"
    oxide_iris="%F{magenta}"
fi

oxide_reset_color="%f"

# Estilo VCS (Git)
# ● Unstaged: Rose (Atenção moderada)
FMT_UNSTAGED="%{$oxide_reset_color%} %{$oxide_rose%}●"
# ✚ Staged: Pine (Pronto/Verde)
FMT_STAGED="%{$oxide_reset_color%} %{$oxide_pine%}✚"
FMT_ACTION="(%{$oxide_rose%}%a%{$oxide_reset_color%})"
# Branch: Foam (Turquesa para destacar do resto)
FMT_VCS_STATUS="on %{$oxide_foam%} %b%u%c%{$oxide_reset_color%}"

zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr    "${FMT_UNSTAGED}"
zstyle ':vcs_info:*' stagedstr      "${FMT_STAGED}"
zstyle ':vcs_info:*' actionformats  "${FMT_VCS_STATUS} ${FMT_ACTION}"
zstyle ':vcs_info:*' formats        "${FMT_VCS_STATUS}"
zstyle ':vcs_info:*' nvcsformats    ""
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

+vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
            git status --porcelain | grep --max-count=1 '^??' &> /dev/null; then
        # Arquivos novos: Love (Vermelho) para chamar atenção
        hook_com[staged]+="%{$oxide_reset_color%} %{$oxide_love%}●"
    fi
}

add-zsh-hook precmd vcs_info

# PROMPT - AJUSTES DE CONTEXTO:
# 1. O caminho (%~) agora usa Iris (Roxo) para não cansar a vista.
# 2. O cursor (❯) usa Pine (Verde) quando o comando anterior for sucesso.
# 3. O cursor (❯) usa Love (Vermelho) apenas se o comando falhar.

PROMPT=$'\n%{$oxide_iris%}%~%{$oxide_reset_color%} ${vcs_info_msg_0_}\n%(?.%{$oxide_pine%}.%{$oxide_love%})%(!.#.❯)%{$oxide_reset_color%} '
