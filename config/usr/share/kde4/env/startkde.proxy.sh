test -r /etc/sysconfig/proxy && source /etc/sysconfig/proxy

if test "$PROXY_ENABLED" = "no"; then
   unset HTTP_PROXY
   unset FTP_PROXY
   unset GOPHER_PROXY
   unset NO_PROXY
   unset HTTPS_PROXY
else
   export HTTP_PROXY
   export HTTPS_PROXY
   export FTP_PROXY
fi

