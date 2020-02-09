import os

# GLOBAL CONFIG #
projectHome = os.environ["SWM_PATH"]
scriptsFolder = projectHome+"scripts/"
cronPath = "/etc/cron.d/"
cronRegex = "# CRON #"
scriptRegex = "SCRIPTPATH"
logPath = "/var/logs/simple-webserver-monitoring/"

# SCRIPT CONFIG #

## BACKUP SCRIPT ###
