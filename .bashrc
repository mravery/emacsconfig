OS=''
case $OSTYPE in
  darwin*)  OS='Mac' ;; 
  linux*)   OS='Linux'  ;;
  *)        OS='UNKNOWN' ;;
esac

umask 006
export PATH=.:~/bin:$PATH
export CLICOLOR=1
export LSCOLORS=ExfxcxdxBxegedabagacad

if [ "$TERM" != "dumb" ]; then
    export PS1='\[\e[40m\e[1;32m\]\u\[\e[0m\][\[\e[0;31m\]\@\[\e[0m\]]\[\e[1;34m\]\w \[\e[1;30m\]\[\e[0m\]> \[\e[0m\]'
else
    export PROMPT_COMMAND=''
    export PS1='\u[\@]\w > '
fi

alias ls='ls -F'
alias ll='ls -Fahl'
alias lv='ls -@aehlFG'
alias e='emacs'

################################################################################
## FUNCTIONS
################################################################################

## Shortcut for find
srch (){ find . -type d \( -name "*temp" -o -name "*.svn*" -o -name ".git" \) -prune \
		-o \! \( -name "*.svn*" -o -name "._DS_Store" \) -print | xargs grep -I "$1"| cut -c 3- ; }

## Alters the permissions to allow for web deployment
webify(){
    find .  -type d \( -name "content" -o -name "*temp" -o -name "*.svn*" \) -prune \
	-o \( -name "*.svn*" -o -name "*.git*" -o -name "*.DS_Store*" \) -prune \
	-o -path "*cgi-bin/php.ini*" -print -exec chmod 660 {} \; \
	-o -path "*cgi-bin/php-wrapper.fcgi" -print -exec chmod 755 {} \; \
	-o -name ".htaccess" -print -exec chmod 644 {} \; \
	-o -type d -print -exec chmod 775 {} \; \
	-o -type f -print -exec chmod 664 {} \; | cut -c 3- ;
}

## Compares two version strings
vercomp () {
    ## returns: 0 equal
    ##          1 ver1 > ver 2
    ##          2 ver1 < ver 2
    if [[ $1 == $2 ]]; then
        return 0
    fi

    # IFS (Internal Field Separator) Fields are separated by a '.'
    # ($var) notation means turn $var into an array according to the IFS.
    local IFS=. 
    local i ver1=($1) ver2=($2) 

    # fill empty fields in ver1 with zeros
    # ${#var[@]} = the number of elements in the array/var.
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 2
        fi
    done
    return 0
}

################################################################################
## MAC ONLY
################################################################################
if [[ $OS = 'Mac' ]]; then

    ### EMACS VERSION CHECK
    # make sure that we're working with emacs >= 24
    wanted_ver=24
    curr_ver=`emacs --version | grep -oE '[[:digit:]]+\.[.[:digit:]]*'`
    vercomp $curr_ver $wanted_ver

    # If vercomp returns 2, then our emacs version isn't good enough.
    if [[ $? = 2 ]]; then
	if [[ -e '/usr/local/bin/emacs' ]]; then
	    emacs_path='/usr/local/bin/emacs -nw'
	elif  [[ -e '/Applications/Emacs.app/Contents/MacOS/Emacs' ]]; then
	    emacs_path='/Applications/Emacs.app/Contents/MacOS/Emacs -nw'
	else
	    echo -n "EMACS VERSION OUT OF DATE: $curr_emacs_version. "
	    echo 'Install a newer version.'
	    emacs_path=''
	fi
	export EDITOR="$emacs_path"
	alias emacs="$emacs_path"
    fi

    ### AUTOJUMP
    # This shell snippet sets the prompt command and the necessary aliases
    if [ -f `brew --prefix`/etc/autojump ]; then
	. `brew --prefix`/etc/autojump
    fi

    ### FUN
    fore(){
	php -c ~avery/dev/phpGolf/golf.ini $1
    }
    
    PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
fi


