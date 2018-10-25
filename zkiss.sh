SCRIPT_DIR=~
SCRIPT_LOC=$SCRIPT_DIR/zkiss.sh
machine=`hostname`

setup_misc () {
	# custom command prompt
	export PS1='\u@\h:\[\e[0;36m\]\w\[\e[0m\]$ '

	# stop some commands being added to bash history
	export HISTIGNORE="&:ls:[bf]g:exit:history:e:prev:ll"
	# don't put duplicate lines in the history. See bash(1) for more options
	# ... or force ignoredups and ignorespace
	HISTCONTROL=ignoredups:ignorespace
	# append to the history file, don't overwrite it
	shopt -s histappend
	# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
	HISTSIZE=2000
	#HISTFILESIZE=2000
	# check the window size after each command and, if necessary,
	# update the values of LINES and COLUMNS.
	shopt -s checkwinsize
	
	# If this is an xterm set the title to user@host:dir
	case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
	*)
		;;
	esac

	# enable color support of ls and also add handy aliases
	if [ "$TERM" != "dumb" ]; then
		eval "`dircolors -b`"
		alias ls='ls --color=auto'
		alias dir='ls --color=auto --format=vertical'
		alias vdir='ls --color=auto --format=long'
		alias grep='grep --color=auto'
	fi
	
	if [ $? -eq 0 ]; then
		LS_OPTIONS='--color=auto'

		LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:bd=40;33;01'
		LS_COLORS=$LS_COLORS:'or=40;31;01:ex=01;31:*.tar=01;31:*.tgz=01;31:*.arj=01;31'
		LS_COLORS=$LS_COLORS:'*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31'
		LS_COLORS=$LS_COLORS:'*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35'
		LS_COLORS=$LS_COLORS:'*.png=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35'
		LS_COLORS=$LS_COLORS:'*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35'
		LS_COLORS=$LS_COLORS:'*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35'
		LS_COLORS=$LS_COLORS:'*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:cd=40;33;01:*.taz=01;31'
		LS_COLORS=$LS_COLORS:'*.bz2=01;31:*.ppm=01;35:*.mpg=01;35:*.xcf=01;35'
		LS_COLORS=$LS_COLORS:'rs=0:di=01;34:ln=01;37:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'

		export LS_COLORS
		eval `dircolors ~/.colourrc >/dev/null 2>&1`
		export LS_OPTIONS
	fi

	export EDITOR=vi
	
	if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
		. /etc/bash_completion
	fi
}

setup_aliases () {
	#Use human-readable filesizes
	alias du='du -h'
	alias df='df -h'
	alias ?='du --max-depth 1'

	alias chmodw='chmod 644'
	alias chmodx='chmod 755'
	alias ll='ls -alFh'
	alias la='ls -A'
	alias l='ls -CF'
	alias les='less --shift=10 --hilite-unread --chop-long-lines'
	alias running='ps -ef | grep ${USER}'
	alias prev='history | grep '
	alias e='exit'
	
	alias diff='colordiff'
	alias sudo='sudo '

	# show manually installed packages
	# http://askubuntu.com/questions/2389/generating-list-of-manually-installed-packages-and-querying-individual-packages
	alias installed="comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)"
}

print_env () {
	color="\e[1;34m"
	echo 'Environment:'
	echo -e "${color}JAVA_HOME\e[00m="$JAVA_HOME
	echo -e "${color}MY_APPZ\e[00m="$MY_APPZ
	echo '-----------------------------------------------------'
}

zinit () {
	setup_aliases
	setup_misc

	# create a function with the hostname for hostname specific behaviour
	# it gets executed here
	$HOSTNAME 2>/dev/null
	
	. ~/zkiss_env.sh &> /dev/null

	# only print stuff in terminal mode
	if [ -t 0 ]; then
		echo "zkiss stuff loaded: $SCRIPT_LOC"
		print_env
	fi
}

zinit

# Functions

# save current dir as an alias
s () {
	typeset label=$1
	bookmark -l $label -d $PWD
}


bookmark () {
	typeset OPTIND OPTARG o label dir print
	while getopts ":l:d:p" o; do
		case "${o}" in
			l)
				label="${OPTARG}"
				;;
			d)
				dir="${OPTARG}"
				;;
			p)
				print=1
				;;
		esac
	done

	if [ "$print" = 1 ]; then
		echo $dir
	elif [ "$label" ]; then
		alias "$label"="bookmark -d $dir"
	else
		cd $dir
	fi
}

zed () {
	local FILE=$1
	if [ -z $FILE ]; then
		FILE=$SCRIPT_LOC
	fi
	#gedit $FILE &
	kate $FILE &> /dev/null &
}
