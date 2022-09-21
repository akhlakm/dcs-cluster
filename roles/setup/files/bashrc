# Custom .bashrc
# Author: Akhlak Mahmood <mahmoodakhlak at gmail dot com>
# Version: 2022.9
# ------------------------------------------------------------------------

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	  *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color|*-256color|cygwin) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
	else
	color_prompt=
	fi
fi

# do not unset $color_prompt, we need it in xterm_setcolor()
unset force_color_prompt

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Some stuff we will need later on
# ---------------------------------

# Define Colors {{
	export black='\e[00;90m'
	export BLACK='\e[01;30m'
	export red='\e[00;91m'
	export RED='\e[01;31m'
	export green='\e[00;92m'
	export GREEN='\e[01;32m'
	export yellow='\e[00;93m'
	export YELLOW='\e[01;33m'
	export blue='\e[00;94m'
	export BLUE='\e[01;34m'
	export magenta='\e[00;95m'
	export MAGENTA='\e[01;35m'
	export cyan='\e[00;96m'
	export CYAN='\e[01;36m'
	export white='\e[00;97m'
	export WHITE='\e[01;37m'
	export NC='\e[00m'          # No Color / Reset
# }}


# if command exists
havecmd() { type "$1" &> /dev/null; }

# the `test` may get overwritten
alias __test=$(which test)

# Allows you to see repository status in your prompt.
# Helper function to install it.
# ------------------------------
git_prompt() {
	if [[ ! -f ~/.git-prompt.sh ]]; then
		# download and use the official one
		echo "Downloading git-prompt ..."
		if havecmd wget; then
			wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -O ~/.git-prompt.sh
		elif havecmd curl; then
			curl "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh" > ~/.git-prompt.sh
		fi
	fi
	source ~/.git-prompt.sh && echo "git-prompt loaded."
	unset git_prompt
}

# Git helpers
# Some later items depend on it.
# It should be configured first.
# ---------------------------------
if havecmd git; then
	__test -f /usr/share/bash-completion/completions/git && source /usr/share/bash-completion/completions/git

	if [[ ! -f ~/.git-prompt.sh ]]; then
		echo "git-prompt not found. It allows you to see repository status in your prompt."
		echo "Please run 'git_prompt' to download and install it."
	else
		source ~/.git-prompt.sh
		unset git_prompt
	fi

	# show all the files in current git repo
	alias gittree='git ls-tree --full-tree -r HEAD'

	# shortcuts for frequently used commands
	alias gits='git status'
	gitac() {
		git add -u
		git status
		local msg="${@:-AutoSave}"
		echo
		read -e -i "$msg" -p "Commit Message (CTRL-c to cancel): " msg
		git commit -m "${msg}"
	}

	# git oneliner log
	alias gitol='git log --oneline -n'

	# "A Dog" = All Decorate Oneline Graph
	alias gitadog='git log --all --decorate --oneline --graph'

	# git create and switch to a new branch
	# ex: git checkout -b new-branch
	# ex: git checkout -b new-branch based-on-this-old-branch
	alias gitnb='git checkout -b'

	# checkout from stash[0]
	alias gitcs='git checkout "stash@{0}" --'
else
	echo "Git not found. Please consider installing it."
fi

# Terminal title and prompt
# ---------------------------------

# Prints the latest non-zero exit code
# inspired by https://github.com/slomkowski/bash-full-of-colors
__exit_code() {
	local exit_code=$?
	if [[ exit_code -eq 0 ]]; then
		echo ''
	else
		echo -e " ${RED}?${exit_code}${NC}"
	fi
}

# Set the length of pwd shown on prompt and title
export PROMPT_DIRTRIM=2

# Change the user, host and path colors.
# Also set the terminal title.
# Call from ~/.bash_aliases
xterm_setcolor() {
	local user host path

	user="${1:-$GREEN}"
	host="${2:-$CYAN}"
	path="${3:-$BLUE}"

	# Set prompt style
	if [ "$color_prompt" = yes ]; then
		# Ubuntu default
		# PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

		# Our custom style
		if havecmd __git_ps1; then
			PS1="${debian_chroot:+($debian_chroot)}\[${user}\]\u\[${BLACK}\]@\[${host}\]\h\[${WHITE}\]:\[${path}\]\w\[$MAGENTA\]\$(__git_ps1)\[${NC}\]\$(__exit_code)\$ "
		else
			PS1="${debian_chroot:+($debian_chroot)}\[${user}\]\u\[${BLACK}\]@\[${host}\]\h\[${WHITE}\]:\[${path}\]\w\[$MAGENTA\]\[${NC}\]\$(__exit_code)\$ "
		fi

	else
		# we don't have color, go plain and simple
		PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
	fi

	# If this is an xterm, set terminal title
	case "$TERM" in
		xterm*|rxvt*)
			# Ubuntu default user@host: dir
			# PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"

			# Our style host: dir
			PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\h: \w\a\]$PS1"
			;;
		*)
			;;
	esac

	# BugFix: command overwrites prompt
	shopt -s checkwinsize
}

# Set default colors
xterm_setcolor $green $GREEN $BLUE

# Common terminal aliases
# ---------------------------------

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto -lh'
	alias dir='dir --color=auto'
	alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# clear screen
alias cls='clear'

# Set the default editor
if havecmd kate; then
	export EDITOR=kate
elif havecmd subl; then
	export EDITOR=subl
elif havecmd code; then
	export EDITOR=code
elif havecmd vim; then
	export EDITOR=vim
else
	export EDITOR=vi
fi

export VISUAL="$EDITOR"

# add some humanity
alias free='free -h'
alias du='du -h'
alias df='df -h'

# interactive mv and cp
alias mv='mv -i'
alias cp='cp -i'

# alias rm='rm -I'
# for some reason I always mess up mv with rm
# so here is this override of rm
alias rm="echo 'Please use remove to delete'"
alias remove="/bin/rm -I"

# text to speak
# example 'say "ding dong"'
alias say='spd-say'


# display sorted directory file size
alias dus="du --max-depth=1 | sort -nr"

# grep history
# you can run a command from history by typing
# !N where N is the command number in history
alias gh='history | grep'

# grep running processes
alias gp='ps aux | grep'

# Copy with a progress bar, limit speed to 50mbps
alias rsync2="rsync -avrRh --info=progress2"
alias rsynclimit="rsync -avhrR --progress --bwlimit=50000"

# Navigation helpers
# ---------------------------------

# Hide pushd popd outputs
pushd () {
	command pushd "$@" > /dev/null
}

popd () {
	command popd "$@" > /dev/null
}

cd() {
	if [[ -z "$1" ]]; then
		command cd ~
		# printf "$RED$PWD/$NC: "
	else
		pushd "$1"
	fi
	ls # "it is useful to call ls from cd"
}

alias d='dirs -v'
alias b='pushd +1'
alias p='pwd'

# case insensitive search inside current directory
search() {
	command find . -iname "*$1*"
}

# Quick and fast access
# ---------------------------------
alias bashrc='${EDITOR} ~/.bashrc'
alias bashaliases='${EDITOR} ~/.bash_aliases'
alias installer='${EDITOR} ~/.installer.sh'
if havecmd git; then alias gitconfig='${EDITOR} ~/.gitconfig'; fi

# source bashrc
alias src='. ~/.bashrc'

# frequently used cd
alias cddl='cd ~/Downloads'
alias cddoc='cd ~/Documents'
alias cdt='cd /tmp'
alias cdmed='cd /media/$(whoami)'

__test -d ~/Dropbox &&          alias cddb='cd ~/Dropbox'
__test -d ~/data &&             alias cdd='cd ~/data'
__test -d ~/programs &&         alias cdp='cd ~/programs'
__test -d ~/mnt &&              alias cdm='cd ~/mnt'

# Installed applications helpers
# ---------------------------------
if havecmd vmd; then alias vmdrc='${EDITOR} ~/.vmdrc'; fi

if havecmd google-chrome; then alias chrome='google-chrome'; fi

if __test -d ~/.config/matplotlib; then
	alias mplrc='${EDITOR} ~/.config/matplotlib/matplotlibrc'
	mplrc="~/.config/matplotlib/matplotlibrc"
fi

# Useful tools
# ---------------------------------

# Open nautilus here or somewhere
here() {
	local path="${1:-$(pwd)}"

	if havecmd nautilus; then
		nautilus "$path" &
	elif havecmd explorer; then
		# cygwin or git-bash
		explorer "$path" &
	fi
}

# Open a new terminal at a specific directory
alias term="gnome-terminal --working-directory"

# open file with default application
function open () {
	if havecmd xdg-open; then
		xdg-open "$@">/dev/null 2>&1
	elif havecmd start; then
		# cygwin or git-bash
		start "$@">/dev/null 2>&1
	fi
}

# open a jupyter lab workspace
jlab() {
	# check if server is running or start it
	nc -4 -d -z -w 1 127.0.0.1 7800 &> /dev/null
	if [[ $? -ne 0 ]]; then
		nohup jupyter lab --port=7800 --no-browser &> /tmp/jlab.log &
		sleep 1
	fi
	open "http://localhost:7800/$1"
}

# Quick google search
# example 'google "Weather Today"'
google() {
	open "https://www.google.com/search?q=$@"
}

# usage: localhost <path> <port>
localhost() {
	local port=${2:-8000}
	local path="${1:-/}"
	open "http://localhost:${port}${path}"
}

backupd() {
	# Backup a directory
	[[ -d $1 ]] || return 1
	dest=$(date +%y%m%d)$1
	mkdir -p $dest || return 2
	echo "** [$USER@$HOSTNAME:$PWD $(date)]\$ backupd"	| tee ${dest}/README.txt
	echo "** RESTORE: tar -C $1 -xzf backup.tar.gz" 	| tee -a ${dest}/README.txt
	tar -cvzpf ${dest}/backup.tar.gz -C $1 . 			| tee -a ${dest}/README.txt
	echo; echo "** OK: ${dest}/backup.tar.gz"
}

backupd-sudo() {
	# Backup a directory with sudo
	[[ -d $1 ]] || return 1
	dest=$(date +%y%m%d)$1
	sudo mkdir -p $dest || return 2
	echo "** [$USER@$HOSTNAME:$PWD $(date)]\$ backupd-sudo"	| sudo tee ${dest}/README.txt
	echo "** RESTORE: tar -C $1 -xzf backup.tar.gz" 		| sudo tee -a ${dest}/README.txt
	sudo tar -cvzpf ${dest}/backup.tar.gz -C $1 . 			| sudo tee -a ${dest}/README.txt
	echo; echo "** OK: ${dest}/backup.tar.gz"
}

# Swap two files.
# If the second file doesn't exist, empty one is created for it.
# Be careful, both files will exist, only contents are exchaned.
swap() {
	local file1 file2
	file1="$1"; file2="$2"
	[[ -f "${file2}" ]] || touch "${file2}"
	cp -fv "${file1}" "swap.${file1}" && \
	mv -fv "${file2}" "${file1}" && \
	mv -v "swap.${file1}" "${file2}"
	echo done
}

# from https://github.com/helmuthdu/dotfiles/blob/master/.bashrc
# REMIND ME, ITS IMPORTANT!
# usage: remindme <time> <text>
# e.g.: remindme 10m "omg, the pizza"
remindme() { sleep $1 && zenity --info --text "$2" & }

tellme() { sleep $1 && spd-say "$2" & }

# from https://github.com/trentm/dotfiles/blob/master/home/.bashrc
# List path entries of PATH or environment variable <var>.
# Usage: pls [<var>]
pls () { eval echo \$${1:-PATH} |tr : '\n'; }

# add current directory to the environment path variables
# e.g.: pla, pla PYTHONPATH
pla () {
	eval export ${1:-PATH}=`pwd`:\$${1:-PATH}
}

ffmpeg-compress() {
	ffmpeg -i "$1" -vcodec h264 -b:v 1000k -acodec mp2 "${2:-compressed.mp4}"
	# ffmpeg -i "$1" -vcodec libx264 -x264-params crf=18 -preset veryslow -acodec copy "${2:-compressed.mp4}"
}

ffmpeg-slowdown() {
	ffmpeg -i "$1" -filter:v "setpts=PTS*$2" "${3:-slow.mp4}"
}

ffmpeg-scale() {
	ffmpeg -i "$1" -vf scale=$2:$3 "${4:-scaled$2by$3.mp4}"
}

# do math
math() {
	echo "scale=4;$*" | bc
}

# create some env vars for applications
export PASS=$(</dev/urandom tr -dc A-Za-z0-9_$#%*+=@$ | head -c16)
if [[ ! -f ~/.passwords ]]; then
	echo "# List of bashrc auto-generated passwords." > ~/.passwords
fi
echo $PASS >> ~/.passwords
alias pass="tail -n 1 ~/.passwords"

# SSH Operations
# ---------------------------------

# ssh agent for pass phrases
alias ssha='eval $(ssh-agent) && ssh-add'

# make key pair
ssh-key() {
	if [[ ! -f ~/.ssh/id_ed25519 ]]; then
		ssh-keygen -t ed25519 -C ${HOSTNAME}
		chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys
	fi
	cat ~/.ssh/id_ed25519.pub
}

# upload the ed25519 ssh public key to a server
ssh-upload-key() {
	read -p "Remote Server IP: " server
	read -p "User: " username
	[[ -f ~/.ssh/id_ed25519 ]] || ssh-key
	cat ~/.ssh/id_ed25519.pub | ssh ${username}@${server} "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
}

# END OF BASHRC DEFINITIONS
# -----------------------------------------------------------------
# Load the local aliases and then the bash completion at the end,
# so local aliases can modify any definitions above if needed.
# -----------------------------------------------------------------

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
else
	cat << EOF > ~/.bash_aliases
# ~/.bash_aliases for ${USER}@${HOSTNAME}
# This file should contain everything that is only specific to
# this computer (path, variable, alias, color etc.).
# Any sharable configuration should go into ~/.bashrc

# xterm_setcolor \$green \$RED

# If you have a backup in Dropbox, create a symlink. Examples -
# sudo ln -s ~/Dropbox/dotfiles/work_aliases ~/.bash_aliases
# sudo ln -s ~/Dropbox/dotfiles/home_aliases ~/.bash_aliases

EOF
	vi ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
  fi
fi
