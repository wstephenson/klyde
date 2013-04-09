#!/bin/bash

sysFile="$HOME/Desktop/myComputer.desktop"
if [ -e $sysFile ]; then
  rm -f $sysFile
  cp /usr/share/applications/kde4/kinfocenter.desktop $HOME/Desktop/
  chmod a+x $HOME/Desktop/kinfocenter.desktop
fi
