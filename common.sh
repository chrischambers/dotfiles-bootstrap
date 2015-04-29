#!/usr/bin/env bash

maxdepth=4

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m? \033[0m ] $1 "
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

abspath () {
  case "$1" in
    /*)
    printf "%s\n" "$1"
    ;;
    *)printf "%s\n" "$PWD/$1"
    ;;
  esac;
}

link_files () {
  ln -s "$1" "$2"
  success "linked $1 to $2"
}

remove_link () {
  rm "$1"
  success "removed $1"
}

check_dotfiles_root_provided () {
if [[ -n $1 ]]; then
    dotfiles_root="$(abspath $1)"
else
    fail "The path to the dotfiles root directory is a required argument."
fi
}

find_dotfile_symlinks () {
  if [[ -n $2 ]]; then
      os=$2
  else
      os=$(detect_os)
  fi

  if [[ -e $1 && -L $1 ]]; then
    if [[ $os = "osx" ]]; then
        s=`readlink $1`
    else
        s=`readlink -f $1`
    fi
  else
    s="$1"
  fi

  if [[ -n $3 ]]; then
    res=$(find $s -maxdepth $maxdepth \! -name "*.sw?" \! -name ".git" \! \
                  -name ".gitignore" -name \*.${3} -o -name \*.${3}*.${os}* )
  else
    res=$(find $s -maxdepth $maxdepth \! -name "*.sw?" \! -name ".git" \! \
                  -name ".gitignore" -name .\* -o -name .\*.${os}\* )
  fi
  echo $res
  # echo $res | grep -v '^\.$' | grep -v '^\.\.$'
}

determine_dotfile_destination () {
    fname=$(echo `basename "$1"` | sed -E 's/^\.?(.*)/\1/')
    echo "$HOME/.$(echo $fname | sed 's/\.[^.]*$//' )"
}

detect_os () {
  # Outputs one of the following, depending on your system:

  # * linux
  # * osx
  # * cygwin
  # * windows
  # * freebsd
  # * unknown (fallback)

  # http://stackoverflow.com/questions/394230/detect-the-os-from-a-bash-script

  if [[ "$OSTYPE" == "linux-gnu" ]]; then
      echo linux
  elif [[ "$OSTYPE" == "darwin"* ]]; then
      echo osx
  elif [[ "$OSTYPE" == "cygwin" ]]; then
      echo cygwin
  elif [[ "$OSTYPE" == "win32" ]]; then
      echo windows
  elif [[ "$OSTYPE" == "freebsd"* ]]; then
      echo freebsd
  else
      echo unknown
  fi
}
