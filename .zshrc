#----- term with -----

#ufetch
#cowsay "welcome maaru^^"
#pokeget random  --hide-name 
#
#
#
#
#
export QT_QPA_PLATFORMTHEME=qt5ct
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#----- default -----
export VISUAL=nvim;
export EDITOR=nvim;
eval "$(zoxide init zsh)"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export XMODIFIERS="@im=none"
export ZSH="$HOME/.oh-my-zsh"

#----- theme -----
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
#ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    z
    )
source $ZSH/oh-my-zsh.sh

#----- alias -----


 alias gay="$HOME/suckless/scripts/gay.sh"
 alias ls='exa --icons --color'
 alias la='exa -a --icons --color'
 alias df="duf"
 alias find="fd"
 alias g="z"
 alias matrix="unimatrix -b -s 95  -c blue"
 alias teri="yetris"
 alias vim="nvim"
 alias nzsh="nvim ~/.zshrc"
 alias neofetch="$HOME/.config/neofetch/startFetch.sh"
 alias cls="clear"
 alias ex="exit"
 


#----- function -----

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

function yazi() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    command yazi --cwd-file="$tmp"
    
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi

    rm -f -- "$tmp"
}

