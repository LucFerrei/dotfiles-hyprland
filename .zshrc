# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export EDITOR=nvim

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"
# ZSH_THEME="amuse"

zstyle ':omz:update' mode auto      # update automatically without asking
setopt IGNORE_EOF

plugins=(git tmux python docker vi-mode) 

source $ZSH/oh-my-zsh.sh

# tmux-sessionizer
export PATH="$HOME/dotfiles-hyprland/bin:$PATH"
bindkey -s ^f '^u"tmux-sessionizer"\n'

# Defina aqui o caminho da pasta de origem que é CONSTANTE
# *MUDE ESTE CAMINHO* para o seu diretório real.
PASTA_CONSTANTE_ORIGEM="$HOME/dotfiles-hyprland/latex/" 
# Exemplo: PASTA_CONSTANTE_ORIGEM="/Users/seunome/Documentos/ProjetosAtivos"

# Função: fazbackup
# Cria a pasta de destino e copia todos os arquivos da PASTA_CONSTANTE_ORIGEM para ela.
# Uso: fazbackup <nome_ou_caminho_da_nova_pasta_destino>
function latex_proj() {
    local PASTA_DESTINO="$1"

    # 1. Verifica se a pasta de destino foi fornecida
    if [ -z "$PASTA_DESTINO" ]; then
        echo "ERRO: Faltando argumento."
        echo "Uso: fazbackup <caminho_ou_nome_da_nova_pasta>"
        return 1
    fi

    # 2. Verifica se a pasta de origem constante existe
    if [ ! -d "$PASTA_CONSTANTE_ORIGEM" ]; then
        echo "ERRO: A pasta de origem constante '$PASTA_CONSTANTE_ORIGEM' não existe."
        return 1
    fi

    # 3. Cria a pasta de destino (se necessário)
    mkdir -p "$PASTA_DESTINO"

    if [ $? -eq 0 ]; then
        echo "Pasta de destino '$PASTA_DESTINO' criada ou já existente."
    else
        echo "ERRO: Não foi possível criar a pasta de destino '$PASTA_DESTINO'."
        return 1
    fi

    # 4. Copia os arquivos
    echo "Copiando arquivos de '$PASTA_CONSTANTE_ORIGEM' para '$PASTA_DESTINO'..."
    # -v: verbose (mostra os arquivos copiados)
    cp -v "$PASTA_CONSTANTE_ORIGEM"/* "$PASTA_DESTINO"

    echo "Cópia concluída para '$PASTA_DESTINO'."
    return 0
}

# Alias básico para substituir 'ls' e incluir ícones, detalhes e arquivos ocultos
alias la='eza -lha --icons --git'

alias ls='eza -lh --icons --git'

# Alias para lista longa (como o 'll' tradicional)
alias ll='eza -lha --icons --git --group-directories-first'

# Alias para visualização em árvore
alias tree='eza -T --icons --git'

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

alias tms='tmux-sessionizer'

#nvim theme config
# alias nvim_dia='nvim -c "NvimDia"'
# alias nvim_noite='nvim -c "NvimNoite"'
