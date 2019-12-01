# Setup
run the setup script (pip dependencies, ...)
`sudo /opt/simple-webserver-monitoring/management/setup.sh`
configure all by your scripts required environment variables.

# Install a script 
To enable a cronjob for a custom script, run the install command.
`admin-cron.py INSTALL|UNINSTALL|STATUS SCRIPT`
The script has to be stored in the script folder.
The script file has to contain therefore at least one cronjob definition: `# CRON # 10 2 2-31 * * / SCRIPTPATH`
The SCRIPTPATH will be replaced automatically with the filename and the path of the script folder.
`python3 /opt/simple-webserver-monitoring/management/admin-cron.sh install SCRIPT`


