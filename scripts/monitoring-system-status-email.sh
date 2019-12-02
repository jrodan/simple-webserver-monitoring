#!/bin/bash
source $HOME/.bash_profile

# CRON # 10 2 2-31 * * root SCRIPTPATH
# CRON # 10 2 * * * root SCRIPTPATH

##
## script to send server status emails once a day
##

## create logfile if not exists
LOGFILE="/var/log/custom/server-status.log"
if [ ! -f "$LOGFILE" ]; then
   mkdir -p "`dirname \"$LOGFILE\"`" 2>/dev/null
fi

## create temp log files 
SEPARATORLOG="/tmplocal/log/separator.log"
if [ ! -f "$SEPARATORLOG" ]; then
   mkdir -p "`dirname \"$SEPARATORLOG\"`" 2>/dev/null
fi
echo "###" >> $SEPARATORLOG
APACHELOG="/var/log/apache2/error.log"
SYSLOG="/tmplocal/log/syslog-err.log"
if [ ! -f "$SYSLOG" ]; then
   mkdir -p "`dirname \"$SYSLOG\"`" 2>/dev/null
fi
cat /var/log/syslog | grep "err" > $SYSLOG

UPDATESLOG="/tmplocal/log/syslog-updates.log"
#apt-get -u update
apt-get -u upgrade --assume-no | grep "installed" >> $UPDATESLOG

TMPLOG="/tmplocal/log/syslog-custom.log"
if [ ! -f "$TMPLOG" ]; then
   mkdir -p "`dirname \"$TMPLOG\"`" 2>/dev/null
fi
cat $LOGFILE $SEPARATORLOG $UPDATESLOG $SEPARATORLOG $SYSLOG $SEPARATORLOG $APACHELOG > $TMPLOG

## send mail
MAILCONTENT=$(<$LOGFILE)
MAILHEADER="Daily ashi report"
# send as attachment
#uuencode "$TMPLOG" "$TMPLOG" | mail -s "$MAILHEADER" "$MAILRECIEVER"
# send as content
cat $TMPLOG | mail -s "$MAILHEADER" "$SWM_MAIL"

## cleanup
rm -rf "/tmplocal/log"

## empty custom log
> $LOGFILE
