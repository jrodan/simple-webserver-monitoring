#!/bin/bash
source $HOME/.bash_profile

# CRON # */5 * * * * root SCRIPTPATH
# CRON # */10 * * * * root SCRIPTPATH
# CRON # */15 * * * * root SCRIPTPATH

TIME=$(date +"%T")
MAILCONTENT="Diese Mail wurde um $TIME gesendet. Test."
MAILHEADER="Cronjob Testnachricht"

echo "$MAILCONTENT" | mail -s "$MAILHEADER" "$SWM_MAIL"
