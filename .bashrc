# General
export EDITOR=vim
export HISTSIZE=1000
export HISTFILESIZE=0

# Prompt
if [ -n "$PS1" ]; then
  if [ "$REALM_SIMPLE_PROMPT" != "1" ]; then PREFIX='\h:'; fi
  if [ -n "$SCREEN" ]; then PREFIX="$SCREEN-$WINDOW $PREFIX"; fi
  if [ "$USER" == "root" ]; then
    export PS1="$PREFIX\w# "
  else
    export PS1="$PREFIX\w% "
  fi
  if [ "$TERM" != "linux" ]; then
    export PS1="\[\033]0;$PREFIX\w\007\]$PS1" # Show prompt in title bar
  fi
  unset PREFIX
fi

# Aliases
alias ls='ls -F --color'
alias ll='ls -hlF'
alias x='chmod +x'
alias irb='irb --simple-prompt'
alias vim='vim -X'
alias lastcmd='history | grep -v lastcmd | tail -1 | cut -b 8-'
alias savelastcmd='echo -n "    " >> README.md; lastcmd >> README.md'
alias rc='. $HOME/.bashrc'
alias xc='xclip -sel clip'

alias di='sudo apt-get install'
alias ds='apt-cache search'
alias dr='sudo apt-get autoremove'

# Save/restore X display
sx() {
  echo $DISPLAY
  echo $DISPLAY > $HOME/.display
  echo $KRB5CCNAME
  echo $KRB5CCNAME > $HOME/.krb5ccname
}
rx() {
  echo -n $DISPLAY
  export DISPLAY=`cat $HOME/.display`
  echo " => $DISPLAY"
  echo -n $KRB5CCNAME
  export KRB5CCNAME=`cat $HOME/.krb5ccname`
  echo " => $KRB5CCNAME"
}

# Run command and remember it
cmd() {
  echo "$@" >> cmd
  echo "$@" | xclip -sel clip
  "$@"
}

# Save current directory, and recover it.
sd() {
  pwd > $HOME/.dir
}
rd() {
  cd $(cat $HOME/.dir)
}

alias l='less -qf' # Quiet, force non-regular files

# Get file from a directory (useful if a directory has a lot of files)
f1() { # First file
  /bin/ls $1 | head -1
}
fr() { # Random file
  /bin/ls $1 | shuffle | head -1
}
fp() { # Print full path
  echo $PWD/$1
}

# Go up a directory
u() {
  n=$1; n=${n:=1}
  s=..
  for ((i=1; i<$n; i++)); do s=../$s; done
  cd $s
}
# Go up a directory, following symlinks
U() {
  cd `ruby -e 'puts File.expand_path(Dir.getwd+"/..")'`
}

# Zip a file or directory
z() {
  f=$1; shift
  zip "$@" -r $f.zip $f
}
zd() { # Delete directory after done
  f=$1; shift
  zip "$@" -r `basename $f`.zip $f && rm -r $f
}

# Vimdiff: |other_base| |file|
vd() {
  vimdiff $2 $1/$2
}

wvim() {
  vim `which $1`
}

# Grep
g() {
  if [ -f "nav" ]; then # created by vimide
    grep "$*" `cat nav`
  else
    grep -r "$*" .
  fi
}

# Sort and uniq
hist() {
  sort | uniq -c | sort -nr | less
}

export PATH=$PATH:$HOME/simple-env/bin

[ -r rc ] && . rc
