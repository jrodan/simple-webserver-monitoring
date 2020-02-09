#!/bin/bash
source $HOME/.bash_profile

# incremental backup script

# CRON # 10 1 2 * * root SCRIPTPATH

# init 
## export RESTIC_PASSWORD=""
## export RESTIC_REPOSITORY=""

echo -e "\n`date` - Starting backup...\n"

restic backup /home --exclude .cache --exclude .local
restic backup /var/mail --exclude *.log
restic backup /var/customers --exclude logs
restic backup /var/www 
restic backup /opt

dbnames=$(mysql -u$SWM_DB_USER -p$SWM_DB_PASSWORD -e 'show databases')
while read dbname; do
    if [ "$dbname" != "Database" ] && [ "$dbname" != "performance_schema" ] && [ "$dbname" != "information_schema" ]; then
        mysqldump -u$SWM_DB_USER -p$SWM_DB_PASSWORD --events --ignore-table=mysql.event --complete-insert "$dbname" > restic backup --stdin --stdin-filename "$dbname-$DATE".sql;
    fi
done <<< "$dbnames"

echo -e "\n`date` - Running forget and prune...\n"

restic forget --prune --keep-daily 7 --keep-weekly 4 --keep-monthly 12

echo -e "\n`date` - Backup finished.\n"
