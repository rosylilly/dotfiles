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

setopt prompt_subst
PROMPT="${CYAN}\$ ${RESET}"
RPROMPT="${RESET}${WHITE}[${GREEN}%(5~,%-2~/.../%2~,%~)% ${RESET}${WHITE}]${WINDOW:+"[$WINDOW]"} ${RESET}"
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

autoload -Uz is-at-least
if is-at-least 4.3.10; then
	# この check-for-changes が今回の設定するところ
	zstyle ':vcs_info:git:*' check-for-changes true
	zstyle ':vcs_info:git:*' stagedstr "+"    # 適当な文字列に変更する
	zstyle ':vcs_info:git:*' unstagedstr "-"  # 適当の文字列に変更する
	zstyle ':vcs_info:git:*' formats '(%s)-[%c%u%b]'
	zstyle ':vcs_info:git:*' actionformats '(%s)-[%c%u%b|%a]'
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

export LSCOLORS=gxfxcxdxbxegedabagacad

setopt auto_cd
setopt auto_pushd
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
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
zstyle ':completion:*' list-colors di=34 fi=0
setopt multios
setopt noautoremoveslash
setopt nolistbeep

autoload history-search-end
bindkey '^R' history-incremental-pattern-search-backward

autoload -U compinit && compinit

autoload -U bashcompinit && bashcompinit && source ~/.zshrc.gitcomp

[ -f ~/.zshrc.alias ] && source ~/.zshrc.alias
case "${OSTYPE}" in
	darwin*)
		[ -f ~/.zshrc.osx ] && source ~/.zshrc.osx
		;;
	linux*)
		[ -f ~/.zshrc.linux ] && source ~/.zshrc.linux
		;;
esac
