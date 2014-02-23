#!/usr/bin/env bash

info () {
  printf "  [ \033[00;34m..\033[0m ] $1"
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

find_dotfile_symlinks () {
  if [[ -n $2 ]]; then
      os=$2
  else
      os=$(detect_os)
  fi

  find $1 -maxdepth 2 -name \*.symlink -o -name \*.symlink*.${os}*
}

determine_dotfile_destination () {
  echo "$HOME/.`basename \"$1\" | sed 's/\([^.]*\).*/\1/'`"
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
