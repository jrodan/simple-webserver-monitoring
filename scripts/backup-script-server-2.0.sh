#!/bin/bash
source $HOME/.bash_profile
source $HOME/.bashrc

# incremental backup script

# CRON # 10 1 2 * * root SCRIPTPATH

# init 
## export RESTIC_PASSWORD=""
## export RESTIC_REPOSITORY=""

echo -e "\n`date` - Starting backup...\n"

###  backup user
mkdir -p $SWM_PATH/users

export UGIDLIMIT=500
awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' /etc/passwd > $SWM_PATH/users/passwd.mig
awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' /etc/group > $SWM_PATH/users/group.mig
awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534) {print $1}' /etc/passwd | tee - |egrep -f - /etc/shadow > $SWM_PATH/users/shadow.mig
cp /etc/gshadow $SWM_PATH/users/gshadow.mig
restic backup $SWM_PATH/users

### backup everything
restic backup /home --exclude .cache --exclude .local
restic backup /var/mail --exclude *.log
restic backup /var/customers --exclude logs
restic backup /var/www --exclude *.log
restic backup /opt --exclude *.log

### backup database
mkdir -p $SWM_PATH/sql

dbnames=$(mysql -u$SWM_DB_USER -p$SWM_DB_PASSWORD -e 'show databases')
while read dbname; do
    if [ "$dbname" != "Database" ] && [ "$dbname" != "performance_schema" ] && [ "$dbname" != "information_schema" ]; then
        mysqldump -u$SWM_DB_USER -p$SWM_DB_PASSWORD --events --ignore-table=mysql.event --complete-insert "$dbname" > $SWM_PATH/sql/$dbname.sql;
    fi
done <<< "$dbnames"

restic backup $SWM_PATH/sql

echo -e "\n`date` - Running forget and prune...\n"

restic forget --prune --keep-daily 7 --keep-weekly 4 --keep-monthly 12

echo -e "\n`date` - Backup finished.\n"
