#############################
# Load zle
#############################
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

#############################
# Load plugins
#############################
# enable fuzzy finder if it exists
if ! [[ -f ~/.fzf.zsh ]] ; then
  if ! [[ -f ~/.fzf/install ]] ; then
    rm -rf ~/.fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  fi
  ~/.fzf/install --all
fi

source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="-m --cycle"
(( $+commands[ag] )) && export FZF_DEFAULT_COMMAND='ag -l -g ""'

if ! [[ -f "${HOME}/.zplug/init.zsh" ]]; then
  curl -sL https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi
zstyle :zplug:tag depth 1
source "${HOME}/.zplug/init.zsh"

zplug "zplug/zplug"
zplug "zsh-users/zsh-completions", use:"*.plugin.zsh"
zplug "mafredri/zsh-async", use:"async.zsh"
zplug "leomao/zsh-hooks", use:"*.plugin.zsh"
zplug "leomao/vim.zsh", use:vim.zsh, defer:1
zplug "leomao/pika-prompt", use:pika-prompt.zsh, defer:2

zplug "so-fancy/diff-so-fancy", as:command, use:diff-so-fancy

export ENHANCD_DISABLE_HOME=1
export ENHANCD_DOT_ARG='.'
zplug "b4b4r07/enhancd", use:init.sh

export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
zplug "zsh-users/zsh-syntax-highlighting", use:"*.plugin.zsh", defer:3

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load

#############################
# Options
#############################
# don't record duplicate history
setopt hist_ignore_dups

# no flow control
setopt noflowcontrol

# rm confirmation
setopt rm_star_wait

# Directory Stack settings
DIRSTACKSIZE=8
setopt auto_cd
setopt autopushd pushdminus pushdsilent pushdtohome pushd_ignore_dups

setopt mark_dirs
setopt multios

#############################
# Aliases
#############################
# List direcory contents
if (( $+commands[exa] )) ; then
  alias ls='exa --group-directories-first'
  alias l='ls -F'
  alias ll='ls -glF'
  alias la='ll -a'
  alias lx='ll -s extension'
  alias lk='ll -rs size'
  alias lt='ll -ars modified'
else
  alias ls='ls -h --color --group-directories-first'
  alias l='ls -F'
  alias ll='ls -lF'
  alias la='ls -lAF'
  alias lx='ls -lXB'
  alias lk='ls -lSr'
  alias lt='ls -lAFtr'
fi
alias sl=ls # often screw this up

# Show history
alias history='fc -l 1'

# Tmux 256 default
alias tmux='tmux -2'

# vim alias
if [[ `vim --version 2> /dev/null | grep -- +clientserver` ]] ; then
  # always use vim client server
  alias vim='vim --servername vim'
fi
alias vi='vim'
alias v='vim'
if (( $+commands[nvim] )) ; then
  alias v='nvim'
fi

# Directory Stack alias
alias dirs='dirs -v'
alias ds='dirs'

# use thefuck if available
if (( $+commands[thefuck] )) ; then
  eval $(thefuck --alias)
fi

#############################
# Completions
#############################
# Important
zstyle ':completion:*:default' menu yes=long select=2

# Completing Groping
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{226}Completing %F{214}%d%f'
zstyle ':completion:*' group-name ''

# Completing misc
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} r:|[._-]=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'
zstyle ':completion:*' use-cache true
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

# Directory
zstyle ':completion:*:cd:*' ignore-parents parent pwd
export LS_COLORS='di=01;94:ln=01;96:ex=01;92'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# default: --
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

# load custom settings
if [[ -f "${HOME}/.zshrc.local" ]]; then
  source "${HOME}/.zshrc.local"
fi
