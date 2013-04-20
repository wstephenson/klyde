#!/bin/sh

MESSAGE=`installation_sources -a "$*"`

if echo "$MESSAGE" | grep -q ERROR; then
 /usr/bin/kdialog --error "$MESSAGE"
else
 /usr/bin/kdialog --msgbox \
   "`TEXTDOMAINDIR=/usr/share/locale/ gettext -d kdebase4-openSUSE -s "YaST source added."`"
fi
