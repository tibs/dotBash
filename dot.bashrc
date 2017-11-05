# .bashrc

# Which computer am I on? (e.g., spoon, ghlenlivid, etc.)
COMPUTER_NAME=`hostname -s`

if [ "${COMPUTER_NAME}" == "Digger" ]
then
  COMPUTER_NAME="digger"
fi

MAIN_WORK_MACHINE="fred"
MAIN_HOME_MACHINE="digger"

# Defaults, which may get set by the "local" scripts
CURRENT_GIT_HOME=/usr

# Stuff that is not suitable for putting on github
if [ -e ${HOME}/.bashrc_local ]
then
  . ${HOME}/.bashrc_local
fi

# Stuff that is specific to this particular machine
if [ -e ${HOME}/.bashrc_for_${COMPUTER_NAME} ]
then
  . ${HOME}/.bashrc_for_${COMPUTER_NAME}
fi

export CVS_RSH=ssh
export EDITOR=/usr/bin/vim

# Locally built programs

export MANPATH=${HOME}/local/vim/share/man:${MANPATH}

# The "bin" directory is mostly platform independent things
# (e.g., written in Python), mostly stored on github
export PATH=$PATH:${HOME}/bin
# The "local/bin" directory is compiled code
# Take files from there preferentially
export PATH=${HOME}/local/bin:$PATH

# And a local man directory might be useful too...
export MANPATH=$MANPATH:${HOME}/man

# Make my MPEG tools easily available
export PATH=$PATH:${HOME}/sw/tstools/bin

# Make weld available
export PATH=$PATH:${HOME}/sw/weld

# And Haskell stuff
export PATH=$PATH:${HOME}/.cabal/bin

# Muddle
if [ -e ${HOME}/bin/setup_muddle.sh ]
then
  alias setup_muddle='source ${HOME}/bin/setup_muddle.sh'
  source ${HOME}/bin/setup_muddle.sh
fi

# todo.txt
alias todo="${HOME}/sw/todo.txt_cli/todo.sh"

# when
alias when="${HOME}/sw/when/when"

# and what...
alias what="${HOME}/Dropbox/what.py"
alias report_hours="${HOME}/Dropbox/hours/report_hours.py"

# Opening a file in an existing Vim
alias gv="gvim --remote-silent"
# And in a new tab
alias gvt="gvim --remote-tab"

# When using IPython, provide a pysh shortcut
alias pysh="ipython -p sh"

# Run a new shell "inside" ssh-agent, so I can use ssh-add
alias ssh_shell=" exec ssh-agent bash"
# but also see my .profile which uses keychain instead...

# What...
alias what="${HOME}/Dropbox/what.py"

alias gitlog="git --no-pager log --oneline --graph --all --decorate"

# Ask bash not to remember duplicate commands in its history list
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# or, apparently, one can set things to ignore by:
#export HISTIGNORE="&:ls:[bf]g:exit"
# which would ignore duplicates, "ls" on a line by itself, and the "bg", "fg"
# and "exit" commands.

# Have we got virtualenvwrapper?
# If so, use "workon" to find out what virtualenv's exist, and to choose one
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
  export WORKON_HOME=$HOME/env
  export PROJECT_HOME=$HOME/sw
  source /usr/local/bin/virtualenvwrapper.sh

  # We may also want the following, to make pip aware of virtualenvwrapper
  export PIP_VIRTUALENV_BASE=$WORKON_HOME
  # and to allow use of pip to detect an active virtualenv without needing the
  # -E switch
  export PIP_RESPECT_VIRTUALENV=true
else
  export PIP_VIRTUALENV_BASE=$HOME/env
fi

# The following may also be sensible for virtualenv use:
# virtualenv should use Distribute instead of legacy setuptools
export VIRTUALENV_DISTRIBUTE=true
# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true

# I can never remember the switches to diff I use for patch preparation
# - this is as much a convenient memo as an actual command to use
# Usage: patchdiff <old-dir> <new-dir>
alias patchdiff="diff -NbBrua"
# "b" means ignore whitespace changes
# "B" means ignore blank lines
# "a" means treat all files as text
# "r" means recursive
# "u" means use unified diff (3 lines of context)
# "N" means treat new files as empty.
# "patch" itself suggests "diff -Naur"

# By default, ls appears to sort ignoring the "dot" in filenames. I find this
# disconcerting. The "info" page on ls suggests that this may be due to the
# locale in force (although LC_ALL does not appear to be set by default).
# Regardless, setting the locale to C appears to make ls work the way I am
# used to again - although what else does it affect?
###export LC_ALL=C

# Enable colour in listings at the terminal
# HOSTTYPE appears to be defined on spot (which is FreeBSD), and not on
# (for instance) sparkler, which is Linux
if [ "$HOSTTYPE" == "FreeBSD" -o "`uname`" == "Darwin" ]
then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
    ##if [ "$COMPUTER_NAME" == "sparkler" ]
    ##then
    ##  # And set the colours I want - this tries to avoid the yellow-on-white
    ##  # effect I normally get for "mknod" file types
    ##  LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=47;33:so=01;35:do=01;35:bd=47;33;01:cd=47;33;01:or=43;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';
    ##  export LS_COLORS
    ##  # (see the dircolors utility for how to work out these commands)
    ##fi
fi

# Maybe try using vi mode for command line editing, instead of (the default)
# emacs mode... the snag is there's no visual indication of what mode one is in
# set -o vi

if [ "$PS1" ]
then
  # By default, Mac OS X does not run X11. Running xmodmap would start it...
  if [ "`uname`" != "Darwin" ]; then
    # Disable the capslock key, if possible
    xmodmap -e "remove lock = Caps_Lock"
  fi

  # check the window size after each command and, if necessary,
  # update the values of LINES and COLUMNS.
  shopt -s checkwinsize

  if [ "$COMPUTER_NAME" == $MAIN_WORK_MACHINE -o "$COMPUTER_NAME" == $MAIN_HOME_MACHINE ]
  then
    HOSTNAME_PROMPT="\h"
  else
    # Emphasise the hostname in bold red
    # NB: apparently bash wants us to wrap non-printing characters in \[ .. \],
    # otherwise linewrap goes wrong
    HOSTNAME_PROMPT="\[\e[31;1m\]\h\[\e[0m\]"
  fi

  PROMPT_START="[\u@${HOSTNAME_PROMPT} \W"
  PROMPT_END="]\$ "

  if [ -x ${CURRENT_GIT_HOME}/bin/git ]
  then
    # If we're within a git repository, put the branch in light green
    # in the middle of the prompt. See above about \[ .. \]
    export PS1=${PROMPT_START}'$(__git_ps1 " \[\e[1;32m\]%s\[\e[m\]")'${PROMPT_END}
  fi

  # make less more friendly for non-text input files, see lesspipe(1)
  [ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

  case $TERM in
    xterm* | Eterm | screen* | rxvt )
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
    ;;
  esac

  # enable programmable completion features (you don't need to enable
  # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
  # sources /etc/bash.bashrc).
  if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# vim: set tabstop=8 softtabstop=2 shiftwidth=2 expandtab filetype=sh:
