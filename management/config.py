import os

# GLOBAL CONFIG #
projectHome = os.environ["SWM_PATH"]
scriptsFolder = projectHome+"scripts/"
cronPath = "/etc/init.d/"  # cronPath = "/etc/cron.d/"
cronRegex = "# CRON #"
scriptRegex = "SCRIPTPATH"

# SCRIPT CONFIG #

## BACKUP SCRIPT ###
