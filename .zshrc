# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git tmux python docker)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
# SINTAXE: alterar_texto <arquivo> <texto_antigo> <texto_novo>
function alterar_texto() {
    # 1. VALIDAÇÃO
    if [ "$#" -ne 3 ]; then
        echo "Uso: alterar_texto_corrigida <caminho/do/arquivo> <texto_antigo> <texto_novo>"
        return 1
    fi

    local arquivo="$1"
    local texto_antigo="$2"
    local texto_novo="$3"

    if [ ! -f "$arquivo" ]; then
        echo "Erro: Arquivo '$arquivo' não encontrado."
        return 1
    fi

    # 2. SANITIZAÇÃO (ESCAPAR CARACTERES ESPECIAIS)
    # Escapa caracteres especiais de REGEX no texto antigo para ser tratado como literal.
    # Usa um caractere diferente (\x2F = /) como separador para ser compatível com sed.
    local texto_antigo_escapado=$(printf '%s\n' "$texto_antigo" | sed -e 's/[]\/\.\*$^[]/\\&/g')

    # Escapa apenas o separador e o '&' no texto novo para evitar problemas de referência.
    local texto_novo_escapado=$(printf '%s\n' "$texto_novo" | sed -e 's/[\/&]/\\&/g')

    # Define o comando sed baseado no sistema (Linux vs. macOS/BSD)
    # Em muitos sistemas (BSD/macOS), 'sed -i' *requer* um argumento de backup,
    # caso contrário, apaga o conteúdo. O '' é o argumento de backup vazio.
    local sed_i=""
    if [[ "$(uname)" == "Darwin" ]] || [[ "$(uname)" == "FreeBSD" ]]; then
        sed_i="-i ''" # Argumento de backup vazio para sed em macOS/BSD
    else
        sed_i="-i" # Padrão em GNU/Linux
    fi
    
    # 3. EXECUÇÃO DA SUBSTITUIÇÃO
    # Usamos o pipe (\x7c = |) como delimitador para evitar conflitos com '/' em URLs.
    # O eval é necessário para que a variável $sed_i seja expandida corretamente.
    eval sed "$sed_i" 's/\x7c/\\x7c/g' "$arquivo" # Escapa o pipe no arquivo, por precaução

    # O comando final usando sed: s|texto_antigo|texto_novo|g
    # Nota: Usamos o caractere '/' como delimitador na substituição final após a sanitização
    # com printf, que é a forma mais robusta.
    eval sed "$sed_i" "s/$texto_antigo_escapado/$texto_novo_escapado/g" "$arquivo"

    if [ "$?" -eq 0 ]; then
        #echo "Sucesso: Todas as ocorrências de '$texto_antigo' foram substituídas em '$arquivo'."
    else
        echo "Aviso: O comando sed falhou ou não encontrou nenhuma correspondência."
        return 1
    fi
}

# --- Configuração de Cópia Personalizada ---

# Defina aqui o caminho da pasta de origem que é CONSTANTE
# *MUDE ESTE CAMINHO* para o seu diretório real.
PASTA_CONSTANTE_ORIGEM="/home/$USER/dotfiles/latex/" 
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

# --- Fim da Configuração de Cópia Personalizada ---

alias nvim_dia="alterar_texto ~/dotfiles/nvim/lua/plugins/coloscheme.lua rose-pine-main rose-pine-dawn"
#alias nvim_noite="alterar_texto ~/dotfiles/nvim/init.lua dawn moon"
alias nvim_noite="alterar_texto ~/dotfiles/nvim/lua/plugins/coloscheme.lua rose-pine-dawn rose-pine-main"

#hyrpland
alias hypr="nvim $HOME/dotfiles/hypr/"

eval "$(starship init zsh)"
nerdfetch

# Alias básico para substituir 'ls' e incluir ícones, detalhes e arquivos ocultos
alias ls='eza --icons --git'
alias la='eza -lha --icons --git'

# Alias para lista longa (como o 'll' tradicional)
alias ll='eza -lha --icons --git --group-directories-first'

# Alias para visualização em árvore
alias tree='eza -T --icons --git'
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
