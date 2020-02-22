# Setup
run the setup script 
`sudo /opt/simple-webserver-monitoring/install.sh`
configure all by your scripts required environment variables.

# Intall all scripts
install all scripts
`python3 /opt/simple-webserver-monitoring/management/admin-cron.py install ALL`
configure all by your scripts required environment variables.

# Install a script 
To enable a cronjob for a custom script, run the install command.
`admin-cron.py INSTALL|UNINSTALL|STATUS SCRIPT`
The script has to be stored in the script folder.
The script file has to contain therefore at least one cronjob definition: `# CRON # 10 2 2-31 * * / SCRIPTPATH`
The SCRIPTPATH will be replaced automatically with the filename and the path of the script folder.
`python3 /opt/simple-webserver-monitoring/management/admin-cron.sh install SCRIPT`

# Findings

mail logging is huge - postfix/smtp
    disconnect from unknown
    warning: unknown[92.118.38.38]: SASL LOGIN authentication failed: UGFzc3dvcmQ6
    Dec  2 09:38:10 v37927 postfix/smtp[10604]: CFED4217CF: host mx01.emig.gmx.net[212.227.17.5] refused to talk to me: 554-gmx.net (mxgmx114) Nemesis ESMTP Service not available 554-No SMTP service 554-Bad DNS PTR resource record. 554 For explanation visit http://postmaster.gmx.com/en/error-messages?ip=178.254.18.246&c=rdns
