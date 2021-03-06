export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8

autoload colors
colors

DEFAULT=$'%{\e[1;0m%]}'
RESET="%{${reset_color}%}"
GREEN="%{${fg[green]}%}"
BLUE="%{${fg[blue]}%}"
CYAN="%{${fg[cyan]}%}"
WHITE="%{${fg[white]}%}"
YELLOW="%{${fg[yellow]}%}"
BLACK="%{${fg[black]}%}"

setopt prompt_subst
PROMPT="${BLUE}(･_･) ${YELLOW}.oO ${RESET}"
RPROMPT="${RESET}${WHITE}[${GREEN}%(5~,%-2~/.../%2~,%~)${RESET}${WHITE}]${WINDOW:+"[$WINDOW]"} ${RESET}"
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history
function history-all { history -E 1 }
setopt share_history
setopt print_eight_bit

zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' formats '[]%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
zstyle ':vcs_info:(svn):*' branchformat '%b:r%r'

autoload -Uz is-at-least
if is-at-least 4.3.10; then
	# この check-for-changes が今回の設定するところ
	zstyle ':vcs_info:git:*' check-for-changes true
	zstyle ':vcs_info:git:*' stagedstr "+"    # 適当な文字列に変更する
	zstyle ':vcs_info:git:*' unstagedstr "-"  # 適当の文字列に変更する
	zstyle ':vcs_info:git:*' formats '[%c%u%b]'
	zstyle ':vcs_info:git:*' actionformats '[%c%u%b|%a]'
fi

function _update_vcs_info_msg() {
	psvar=()
	LANG=en_US.UTF-8 vcs_info
	psvar[2]=$(_git_not_pushed)
	[[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg

function _git_not_pushed()
{
	if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]; then
		head="$(git rev-parse HEAD)"
		for x in $(git rev-parse --remotes)
		do
			if [ "$head" = "$x" ]; then
				return 0
			fi
		done
		echo "{?}"
	fi
	return 0
}
RPROMPT="%1(v|%F${CYAN}%1v%2v%f|)${vcs_info_git_pushed}${RESET}${WHITE}[${GREEN}%(5~,%-2~/.../%2~,%~)% ${WHITE}]${WINDOW:+"[$WINDOW]"} ${RESET}"

function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd)
      PROMPT="${GREEN}(･v･) ${YELLOW}.oO ${RESET}"
    ;;
    main|viins)
      PROMPT="${BLUE}(･_･) ${YELLOW}.oO ${RESET}"
    ;;
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

export LSCOLORS=gxfxcxdxbxegedabagacad

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt correct
setopt correct_all
setopt list_packed
setopt list_types
setopt auto_list
setopt magic_equal_subst
setopt auto_param_keys
setopt auto_param_slash
setopt brace_ccl
setopt auto_menu
setopt mark_dirs
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
zstyle ':completion:*' list-colors di=34 fi=0
setopt multios
setopt noautoremoveslash
setopt nolistbeep

autoload history-search-end

# completion
fpath=($HOME/.zsh/functions/ $fpath)
fpath=(/usr/local/Cellar/git-now/0.1.0.9/share/zsh/functions $fpath)
autoload -U compinit && compinit

autoload -U bashcompinit && bashcompinit && source ~/.zshrc.gitcomp

# bindkeys
bindkey -v # vi mode
bindkey '^R' history-incremental-pattern-search-backward
bindkey "^P" up-line-or-history
bindkey "^N" down-line-or-history

# [ -f ~/.zshrc.vistatus ] && source ~/.zshrc.vistatus

[ -f ~/.zshrc.alias ] && source ~/.zshrc.alias
case "${OSTYPE}" in
	darwin*)
		[ -f ~/.zshrc.osx ] && source ~/.zshrc.osx
		;;
	linux*)
		[ -f ~/.zshrc.linux ] && source ~/.zshrc.linux
		;;
esac

[ -f ~/.zshrc.tmux ] && source ~/.zshrc.tmux
[ -f ~/.zshrc.dev ] && source ~/.zshrc.dev
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

typeset -U path
