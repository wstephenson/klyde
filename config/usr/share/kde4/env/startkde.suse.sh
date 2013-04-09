#!/bin/sh

desktop="`xdg-user-dir DESKTOP 2>/dev/null`"
if test -z "$desktop"; then
    desktop=$HOME/Desktop
fi

#
# do we run in a prelinked system ?
#
if test -f /etc/sysconfig/prelink; then
. /etc/sysconfig/prelink
  if test "$USE_PRELINK" = "yes" ; then
     KDE_IS_PRELINKED=1
     export KDE_IS_PRELINKED
  else
     unset KDE_IS_PRELINKED
  fi
fi

# 
# workaround SaX/SUSE bug that doesn't setup a proper keyboard map
#

if [ -f /usr/share/hotkey-setup/hotkey-setup.xmodmap ]; then
  xmodmap /usr/share/hotkey-setup/hotkey-setup.xmodmap
fi

if [ -r /etc/sysconfig/windowmanager ]; then
  # Do the user want the SuSE theme ?
  source /etc/sysconfig/windowmanager

  # Should we really enable FAM support for KDE ?
  export USE_FAM="$KDE_USE_FAM"

  # Disable IPv6 ?
  if [ "$KDE_USE_IPV6" = "no" ]; then
     export KDE_NO_IPV6=1
  fi
  # Disable IDN ?
  if [ "$KDE_USE_IDN" = "no" ]; then
     export KDE_NO_IDN=1
  fi

else
  if [ -r /etc/rc.config ]; then
    # Do the user want the SuSE theme ?
    INSTALL_DESKTOP_EXTENSIONS=`bash -c "source /etc/rc.config && echo \\$INSTALL_DESKTOP_EXTENSIONS"`

    # Should we really enable FAM support for KDE ?
    USE_FAM=`bash -c "source /etc/rc.config && echo \\$KDE_USE_FAM"`
    export USE_FAM
  fi
fi

#
# create SuSE defaults
#
if [ ! -e "$HOME/.skel/kdebase4.120" ]; then
    mkdir -p "$desktop"

    if [ -e "/usr/bin/firefox" -a ! -e "$desktop/MozillaFirefox.desktop" -a -e "/usr/share/kde4/config/SuSE/default/MozillaFirefox.desktop" ]; then
          cp /usr/share/kde4/config/SuSE/default/MozillaFirefox.desktop "$desktop/"
    fi
    chmod u+x "$desktop/MozillaFirefox.desktop" 2>/dev/null

    if [ -e "/usr/bin/oofromtemplate" -a  ! -e "$desktop/Office.desktop" -a -e "/usr/share/kde4/config/SuSE/default/Office.desktop" ]; then
          cp /usr/share/kde4/config/SuSE/default/Office.desktop "$desktop/"
    fi
    chmod u+x "$desktop/Office.desktop" 2>/dev/null

    if [ ! -e "$desktop/SuSE.desktop" -a -e "/usr/share/kde4/config/SuSE/default/SuSE.desktop" ]; then
          cp /usr/share/kde4/config/SuSE/default/SuSE.desktop "$desktop/"
    fi
    chmod u+x "$desktop/SuSE.desktop" 2>/dev/null

    if [ ! -e "$desktop/Support.desktop" -a -e "/usr/share/kde4/config/SuSE/default/Support.desktop" ]; then
          cp /usr/share/kde4/config/SuSE/default/Support.desktop "$desktop/"
    fi
    sed -i 's/^Icon=susehelpcenter$/Icon=Support/' "$desktop/Support.desktop"
    chmod u+x "$desktop/Support.desktop" 2>/dev/null

    if [ ! -e "$desktop/kinfocenter.desktop" -a -e "/usr/share/applications/kde4/kinfocenter.desktop" ]; then
          cp /usr/share/applications/kde4/kinfocenter.desktop "$desktop/"
    fi
    chmod u+x "$desktop/kinfocenter.desktop" 2>/dev/null

    if [ ! -e "$HOME/.kde4/share/apps/konqueror/bookmarks.xml" -a -e "/usr/share/kde4/config/SuSE/default/bookmarks.xml" ]; then
          mkdir -p $HOME/.kde4/share/apps/konqueror
          cp /usr/share/kde4/config/SuSE/default/bookmarks.xml $HOME/.kde4/share/apps/konqueror/bookmarks.xml
    fi

    if [ ! -e "$HOME/.kde4/share/apps/akregator/data/feeds.opml" -a -e "/usr/share/kde4/config/SuSE/default/feeds.opml" ]; then
          mkdir -p $HOME/.kde4/share/apps/akregator/data
          cp /usr/share/kde4/config/SuSE/default/feeds.opml $HOME/.kde4/share/apps/akregator/data/feeds.opml
    fi

    documents="`xdg-user-dir DOCUMENTS 2>/dev/null`"
    if test -z "$documents"; then
        documents=$HOME/Documents
    fi
    mkdir -p "$documents"
    if [ ! -e "$documents/.directory" -a -e "/usr/share/kde4/config/SuSE/default/documents.directory" ]; then
          cp /usr/share/kde4/config/SuSE/default/documents.directory "$documents/.directory"
    fi

    # by default restrict strigi to index xdg-user-dir folders
    if [ ! -e $HOME/.kde4/share/config/nepomukstrigirc -a -x $(which xdg-user-dir) ]; then
        for i in DESKTOP DOWNLOAD TEMPLATES PUBLICSHARE DOCUMENTS MUSIC PICTURES VIDEOS;
        do
            strigi_paths="${strigi_paths},$(xdg-user-dir $i)"
        done

        strigi_paths=${strigi_paths:1}
        sedcommand="s,$HOME,\$HOME,g"
        strigi_paths=$(echo $strigi_paths|sed $sedcommand)

        echo -e "[General]\nfolders[\$e]=$strigi_paths" > $HOME/.kde4/share/config/nepomukstrigirc
    fi

    mkdir -p $HOME/.skel/
    touch $HOME/.skel/kdebase4.120
fi

# workaround for bnc#551333, bnc#601392
if [ ! -e "$HOME/.skel/kdebase4firefox.120" ]; then
    if [ -e "/usr/bin/firefox" ]; then
          gconftool-2 -s --type=string /desktop/gnome/url-handlers/http/command "/usr/bin/firefox \"%s\""
          gconftool-2 -s --type=string /desktop/gnome/url-handlers/https/command "/usr/bin/firefox \"%s\""
    fi
    touch $HOME/.skel/kdebase4firefox.120
fi

# workaround for bnc#614748
if [ ! -e "$HOME/.skel/kdebase4.wallpapercache.113" ]; then
    if [ -n "$KDEVARTMP" ]; then
        wallpapercache="$KDEVARTMP/plasma-wallpapers"
    else
        wallpapercache="/var/tmp/kdecache-$USER/plasma-wallpapers"
    fi
    if [ -e $wallpapercache ]; then
        rm -rf $wallpapercache
    fi
    touch $HOME/.skel/kdebase4.wallpapercache.113
fi

# check if any rpms have been (un)installed since ksycoca
# had been built, if yes, trigger ksycoca rebuild immediatelly
# instead of delayed

kdehome=$HOME/.kde4
test -n "$KDEHOME" && kdehome=`echo "$KDEHOME"|sed "s,^~/,$HOME/,"`
host=$HOSTNAME
test -n "$XAUTHLOCALHOSTNAME" && host=$XAUTHLOCALHOSTNAME
ksycoca="$kdehome/cache-$host/ksycoca"

if test -f "$ksycoca"; then
    if test -f /var/lib/rpm/Packages; then
	if test /var/lib/rpm/Packages -nt "$ksycoca"; then
	    rm -f "$ksycoca"
	fi
    fi
fi
