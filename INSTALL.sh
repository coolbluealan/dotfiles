#!/bin/bash

dots=~/dotfiles
cd $dots

safelink() {
  if test -e ~/$2; then
    echo "Already exists: ~/$2"
  else
    ln -s $dots/$1 ~/$2
    echo "Created: ~/$2"
  fi
}
link() {
  safelink $1 $1
}

for dir in .config/*; do
  link $dir
done

link .astylerc
link .asy
link .chktexrc
link .indentconfig.yaml
link .xinitrc
link texmf

safelink .config/polybar/$(hostname).ini .config/polybar/config.ini
