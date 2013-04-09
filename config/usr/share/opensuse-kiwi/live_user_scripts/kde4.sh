#! /bin/sh

set -e

desktop="`xdg-user-dir DESKTOP 2>/dev/null`"
if test -z "$desktop"; then
    desktop=$HOME/Desktop
fi

if test -e /usr/share/applications/YaST2/live-installer.desktop ; then
   if [ ! -e "$desktop/live-installer.desktop" -a -e "/usr/share/kde4/config/SuSE/default/live-installer.desktop" ]; then
        mkdir -p "$desktop"
        cp /usr/share/kde4/config/SuSE/default/live-installer.desktop "$desktop/"
        chmod u+x "$desktop/live-installer.desktop"
   fi
fi

# hack to get plasma to evaluate user-local plasma updates
echo "export KDEDIRS=/usr:$HOME/.kde4/share" >> $HOME/.profile
mkdir -p $HOME/.kde4/share/apps/plasma-desktop/updates
cp -a /usr/share/kde4/config/SuSE/default/clock-no-events.js.live $HOME/.kde4/share/apps/plasma-desktop/updates/clock-no-events.js

mkdir -p $HOME/.kde4/share/config
cp -a /usr/share/kde4/config/SuSE/default/lowspacesuse.live $HOME/.kde4/share/config/lowspacesuse
cp -a /usr/share/kde4/config/SuSE/default/kdedrc.live $HOME/.kde4/share/config/kdedrc
cp -a /usr/share/kde4/config/SuSE/default/kwalletrc.live $HOME/.kde4/share/config/kwalletrc
cp -a /usr/share/kde4/config/SuSE/default/krunnerrc.live $HOME/.kde4/share/config/krunnerrc
cp -a /usr/share/kde4/config/SuSE/default/nepomukserverrc.live $HOME/.kde4/share/config/nepomukserverrc
install -D -m 644 /usr/share/kde4/config/SuSE/default/mysql-local.conf.live $HOME/.config/akonadi/mysql-local.conf

#cp -a /usr/share/kde4/config/SuSE/default/kcmnspluginrc.live $HOME/.kde4/share/config/kcmnspluginrc

mkdir -p $HOME/.kde4/share/apps/kwallet
cp -a /usr/share/kde4/config/SuSE/default/kwallet.kwl.live $HOME/.kde4/share/apps/kwallet/kwallet.kwl

mkdir -p $HOME/.config/autostart


# 11.2 - disabled, see bnc#536545
# first generate ksycoca, it will be used by nsplugincan
/usr/bin/kbuildsycoca4
#/usr/bin/nspluginscan
# this also has quite a big cost during the first startup
#/usr/lib*/kde4/libexec/kconf_update
# create the final ksycoca
#/usr/bin/kbuildsycoca4

# the cache is hostname specific, so don't hardcode "build24". at least "linux"
mv $HOME/.kde4/cache-* $HOME/.kde4/cache-linux
