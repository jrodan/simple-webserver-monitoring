#!/bin/bash
source $HOME/.bash_profile
source $HOME/.bashrc

mkdir -p $SWM_PATH/backup

cp /etc/passwd /etc/shadow /etc/group /etc/gshadow $SWM_PATH/backup/newsusers.bak

cat $SWM_PATH/users/passwd.mig >> /etc/passwd
cat $SWM_PATH/users/group.mig >> /etc/group
cat $SWM_PATH/users/shadow.mig >> /etc/shadow
/bin/cp $SWM_PATH/users/gshadow.mig /etc/gshadow
