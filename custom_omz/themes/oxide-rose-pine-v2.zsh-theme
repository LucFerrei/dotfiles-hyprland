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

# Rosé Pine theme for Zsh - Foco em Contraste (Fundo: #1F1D29)
setopt PROMPT_SUBST
# 󰇘✘
autoload -U add-zsh-hook
autoload -Uz vcs_info

# if [[ "${terminfo[colors]}" -ge 256 ]]; then
#     oxide_path="%F{189}"       
#     oxide_branch="%F{116}"     
#     # oxide_love="%F{204}"       
#     oxide_love="%F{211}"       
#     oxide_staged="%F{144}"  
#     oxide_unstaged="%F{216}"       
#     oxide_remote="%F{183}"     
#     oxide_stashed="%F{217}"     
# else
#     oxide_pine="%F{green}"
#     oxide_path="%F{yellow}"
#     oxide_love="%F{red}"
#     oxide_foam="%F{cyan}"
#     oxide_rose="%F{magenta}"
# fi

oxide_path="%F{#E0DEF4}"       
# oxide_path="%F{#908CAA}"       
oxide_branch="%F{#9CCFD8}"     
# oxide_love="%F{204}"       
oxide_love="%F{#EB6F92}"       
oxide_staged="%F{#A3BE8C}"  
oxide_unstaged="%F{#F6C177}"       
oxide_remote="%F{#C4A7E7}"     
oxide_stashed="%F{#EBBCBA}"     

oxide_reset_color="%f"


#local
FMT_UNTRACKED="%{$oxide_reset_color%} %{$oxide_love%}"
FMT_UNSTAGED="%{$oxide_reset_color%} %{$oxide_unstaged%}✘"
FMT_STAGED="%{$oxide_reset_color%} %{$oxide_staged%}✚"
# FMT_STASHED="%{$oxide_reset_color%} %{$oxide_rose%}󰀼"
FMT_STASHED="%{$oxide_reset_color%} %{$oxide_stashed%}*"

#Remote
FMT_AHEAD="%{$oxide_reset_color%} %{$oxide_remote%}⇡"
FMT_BEHIND="%{$oxide_reset_color%} %{$oxide_remote%}⇣"

FMT_ACTION="(%{$oxide_path%}%a%{$oxide_reset_color%})"
FMT_VCS_STATUS="on %{$oxide_branch%} %b%u%c%m%{$oxide_reset_color%}"

# Não rastreado (Untracked): ? ou 
#
# Modificado (Modified): 󰗡 ou !
#
# Adicionado ao Staging (Staged): ✚ ou 󰐖
#
# Renomeado (Renamed): ➜ ou 󰕈
#
# Conflito (Conflict): ✘ ou 󰅙
#
# Stashed: 󰀼 ou *
#
# Ahead (Commit à frente): ⇡ ou 󰶣
#
# Behind (Commit atrás): ⇣ ou 󰶡

zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr    "${FMT_UNSTAGED}"
zstyle ':vcs_info:*' stagedstr      "${FMT_STAGED}"
zstyle ':vcs_info:*' actionformats  "${FMT_VCS_STATUS} ${FMT_ACTION}"
zstyle ':vcs_info:*' formats        "${FMT_VCS_STATUS}"
# zstyle ':vcs_info:*' nvcsformats    ""
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-stash git-remote-status

+vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
            git status --porcelain | grep --max-count=1 '^??' &> /dev/null; then
        # hook_com[staged]+="%{$oxide_reset_color%} %{$oxide_love%}●"
        hook_com[staged]+="${FMT_UNTRACKED}"
    fi
}

+vi-git-stash() {
    if [[ -s $(git rev-parse --git-dir)/refs/stash ]]; then
        hook_com[misc]+="${FMT_STASHED}"
    fi
}

+vi-git-remote-status() {
    local ahead behind
    local -a gitstatus

    # Busca a contagem de commits ahead/behind
    gitstatus=($(git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null))

    ahead=$gitstatus[1]
    behind=$gitstatus[2]

    if (( ahead > 0 )); then
        hook_com[misc]+="${FMT_AHEAD}"
    fi

    if (( behind > 0 )); then
        hook_com[misc]+="${FMT_BEHIND}"
    fi
}

autoload -Uz vcs_info
add-zsh-hook precmd vcs_info


# PROMPT FINAL - Ajustado para Contraste:
# 1. Caminho em Gold (%F{222}): É a cor mais visível no Rosé Pine para texto longo.
# 2. Indicador em Pine (%F{30}) se OK, Love (%F{167}) se erro.
# PROMPT=$'\n%{$oxide_path%}%~%{$oxide_reset_color%} ${vcs_info_msg_0_}\n%(?.%{$oxide_pine%}.%{$oxide_love%})%(!.#.❯)%{$oxide_reset_color%} '
PROMPT=$'\n%{$oxide_path%}%~%{$oxide_reset_color%} ${vcs_info_msg_0_}\n%(?.%{$oxide_pine%}.%{$oxide_love%})%(!.#.❯)%{$oxide_reset_color%} '
