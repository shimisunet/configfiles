#prompt
autoload -U colors
colors

#PROMPT='%n@%m# '  #ホスト名、コンピュータ名を左側に表示
PROMPT='%B%F{cyan}%n%f%b %# '     #ホスト名のみを左側に表示(シアン、太字)
RPROMPT='%B%F{green}[%d]%f%b'     #カレントディレクトリを右側に表示(緑、太字)

#completion
autoload -U compinit
compinit
setopt correct
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history
setopt auto_pushd
setopt pushd_ignore_dups

# ls
export LSCOLORS=cxfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=2;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

# alias
alias ls='ls --color=auto'
alias ll='ls -lF'
alias la='ls -A'
alias l='ls -CF'
#alias rm='rm -i'
#alias cp='cp -i'
#alias mv='mv -i'
#alias vi='vim'
alias -g G='| grep'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g S='| sort'
alias -g W='| wc'
alias -g X='| xargs'
alias tsp='tmux new-session \; split-window -h -d'
alias tvsp='tmux new-session \; split-window -d'

#GitHub
autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null

function rprompt-git-current-branch {
    local name st color gitdir action
    if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
	return
    fi

    name=`git rev-parse --abbrev-ref=loose HEAD 2> /dev/null`
    if [[ -z $name ]]; then
	return
    fi

    gitdir=`git rev-parse --git-dir 2> /dev/null`
    action=`VCS_INFO_git_getaction "$gitdir"` && action="($action)"

    if [[ -e "$gitdir/rprompt-nostatus" ]]; then
	echo "$name$action "
	return
    fi

    st=`git status 2> /dev/null`
    if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
	color=%F{green}
    elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
	color=%F{yellow}
    elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
	color=%B%F{red}
    else
	color=%F{red}
    fi

    echo "$color$name$action%f%b "
}

setopt prompt_subst

RPROMPT='[`rprompt-git-current-branch`%~]'
