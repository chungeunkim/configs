#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all my BASH configurations and aliases
#
#  Sections:
#  1.   Environment Configuration
#  2.   Make Terminal Better (remapping defaults and adding functionality)
#  3.   File and Folder Management
#  4.   Searching
#  5.   Process Management
#  6.   Miscellaneous
#
#  ---------------------------------------------------------------------------

#   -------------------------------
#   1.  ENVIRONMENT CONFIGURATION
#   -------------------------------

#   Set Colors
    RED="\[\033[1;31m\]"
    GREEN="\[\033[32m\]"
    YELLOW="\[\033[1;33m\]"
    CYAN="\[\033[36m\]"
    NO_COLOR="\[\033[m\]"
    
#   Change Prompt
    function parse_git_branch {
      ref=$(git symbolic-ref HEAD 2> /dev/null) || return
        echo "("${ref#refs/heads/}")"
    }

    export PS1="| $CYAN\u$NO_COLOR@$GREEN\h:$YELLOW\w $RED\$(parse_git_branch)$NO_COLOR \n| => "
    export PS2="| => "

#   Set Paths
    export PATH="$PATH:/usr/local/bin/"

#   Set Vim as a defualt editor
    export EDITOR=/usr/local/bin/vim

#   Set default blocksize for ls, df, du
    export BLOCKSIZE=1k

#   Add color to terminal
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad

#   -----------------------------
#   2.  MAKE TERMINAL BETTER
#   -----------------------------

    alias cp='cp -iv'                           # Preferred 'cp' implementation
    alias mv='mv -iv'                           # Preferred 'mv' implementation
    alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
    alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
    alias less='less -FSRXc'                    # Preferred 'less' implementation
    cd() { builtin cd "$@"; ll; }               # Always list directory contents upon 'cd'
    alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
    alias ..='cd ../'                           # Go back 1 directory level
    alias ...='cd ../../'                       # Go back 2 directory levels
    alias .3='cd ../../../'                     # Go back 3 directory levels
    alias .4='cd ../../../../'                  # Go back 4 directory levels
    alias .5='cd ../../../../../'               # Go back 5 directory levels
    alias .6='cd ../../../../../../'            # Go back 6 directory levels
    alias edit='vim'                            # edit:         Opens any file in vim editor
    alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
    alias ~="cd ~"                              # ~:            Go Home
    alias c='clear'                             # c:            Clear terminal display
    alias which='type -all'                     # which:        Find executables
    alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
    alias show_options='shopt'                  # Show_options: display bash options settings
    alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
    alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
    mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
    trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
    ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview

#   mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
#           displays paginated result with colored search terms and two lines surrounding each hit.             Example: mans mplayer codec
#   --------------------------------------------------------------------
    mans () {
        man $1 | grep -iC2 --color=always $2 | less
    }

#   -------------------------------
#   3.  FILE AND FOLDER MANAGEMENT
#   -------------------------------

    zipf () { zip -r "$1".zip "$1" ; }          # zipf:         To create a ZIP archive of a folder
    alias numFiles='echo $(ls -1 | wc -l)'      # numFiles:     Count of non-hidden files in current dir

#   extract:  Extract most know archives with one command
#   ---------------------------------------------------------
    extract () {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
             esac
         else
             echo "'$1' is not a valid file"
         fi
    }


#   ---------------------------
#   4.  SEARCHING
#   ---------------------------

    alias qfind="find . -name "                 # qfind:    Quickly search for file
    ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
    ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
    ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

#   ---------------------------
#   5.  PROCESS MANAGEMENT
#   ---------------------------

#   findPid: find out the pid of a specified process
#   -----------------------------------------------------
#       Note that the command name can be specified via a regex
#       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#       Without the 'sudo' it will only find processes of the current user
#   -----------------------------------------------------
    findPid () { lsof -t -c "$@" ; }

#   memHogsTop, memHogsPs:  Find memory hogs
#   -----------------------------------------------------
    alias memHogsTop='top -l 1 -o rsize | head -20'
    alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#   cpuHogs:  Find CPU hogs
#   -----------------------------------------------------
    alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#   topForever:  Continual 'top' listing (every 10 seconds)
#   -----------------------------------------------------
    alias topForever='top -l 9999999 -s 10 -o cpu'

#   ttop:  Recommended 'top' invocation to minimize resources
#   ------------------------------------------------------------
#       Taken from this macosxhints article
#       http://www.macosxhints.com/article.php?story=20060816123853639
#   ------------------------------------------------------------
    alias ttop="top -R -F -s 10 -o rsize"

#   my_ps: List processes owned by my user:
    my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }

#   ---------------------------------------
#   6. Miscellaneous
#   ---------------------------------------

#   Node Version Management
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#   Python Version Management
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

#   Flutter
    export PATH="$PATH:$HOME/development/flutter/bin"

#   Ruby
    export PATH="/usr/local/opt/ruby/bin:$PATH"
    export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"
    export PATH="$HOME/.cargo/bin:$PATH"

#   autojump
    AUTOJUMP_FILE=$(brew --prefix)/etc/profile.d/autojump.sh
    [[ -s $AUTOJUMP_FILE ]] && . $AUTOJUMP_FILE
