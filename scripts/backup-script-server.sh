#!/bin/bash
# incremental backup script

# CRON # 10 1 1 * * / SCRIPTPATH complete
# CRON # 10 1 2-31 * * / SCRIPTPATH

##
## init folders
##
BACKUPDIR=/tmplocal/backup
LASTMONTHDIR=lastmonth
TSNAME=timestamp.snar
BACKUPNAME=backup
MYSQL="mysql"
DIRS="home var/mail var/customers var/www opt tmplocal/backup/mysql"
DATE=$(date +'%Y-%m-%d_%H-%M-%S')

mkdir -p $BACKUPDIR
mkdir -p $BACKUPDIR/$MYSQL

##
## backup mysql databases
##
dbnames=$(mysql -u$SWM_DB_USER -p$SWM_DB_PASSWORD -e 'show databases')
while read dbname; do
    if [ "$dbname" != "Database" ] && [ "$dbname" != "performance_schema" ] && [ "$dbname" != "information_schema" ]; then
        mysqldump -u$SWM_DB_USER -p$SWM_DB_PASSWORD --events --ignore-table=mysql.event --complete-insert "$dbname" > "$BACKUPDIR/$MYSQL/$dbname-$DATE".sql;
    fi
done <<< "$dbnames"

##
## backup local folders
##
if [[ $1 == "complete" ]]; then
    #full backup
    MYDATE=complete
    #Alte Timestamps löschen
    rm -f "$BACKUPDIR/$TSNAME"
    #Alte Backups löschen
    rm -rf "$BACKUPDIR/$LASTMONTHDIR.$BACKUPNAME.d"
    #Neue alte Backups in Ordner verschieben
    mkdir "$BACKUPDIR/$LASTMONTHDIR.$BACKUPNAME.d"
    mv -f "$BACKUPDIR/$BACKUPNAME.*".tgz "$BACKUPDIR/$LASTMONTHDIR.$BACKUPNAME.d"
else
    #Inkrementelles Backup
    MYDATE=$(date +%y%m%d)
fi

##
## create backup file
##
cd /
tar czf "$BACKUPDIR"/"$BACKUPNAME".$MYDATE.tgz --exclude="**/cache/*" -g "$BACKUPDIR/$TSNAME" $DIRS

##
## remove tmp mysql folder
##
rm -r $BACKUPDIR/$MYSQL

##
## backup zip to ftp
##
ftp-upload -h $SWM_FTP_HOST -u $SWM_FTP_USER --password $SWM_FTP_PASSWORD -d / "$BACKUPDIR"/"$BACKUPNAME".$MYDATE.tgz

##
## restore information
##
## tar xzf /var/local/backup.complete.tgz --listed-incremental=/var/local/timestamp.snar
## ls /var/local/backup.[0-9][0-9][0-9][0-9][0-9][0-9].tgz | sort | xargs tar xzf --listed-incremental=/var/local/timestamp.snar

##
## send mail
##
## echo "the backup of ashi  is completed in the version '$MYDATE'." | mail -s "Backup on ashi completed" mail

##
## log result
## 
LOGFILE="/var/log/custom/server-status.log"
echo "$DATE - backup successfully run - $MYDATE" >> $LOGFILE