import os
import requests

# CRON # */30 * * * * root source $HOME/.bash_profile; usr/bin/python SCRIPTPATH

#
# init
#


def sendMail(message):
    os.system("echo \""+message+"\" | mail -s \"$MAILHEADER\" \"$SWM_MAIL\"")


def checkDomain(domain):
    try:
        r = requests.get(domain, timeout=5)

        if r.status_code != 200:
            sendMail(domain+" is DOWN")
    except Exception as e:
        sendMail(domain+" is DOWN")


checkDomain(os.environ["SWM_JC_DOMAIN"])
checkDomain(os.environ["SWM_JR_DOMAIN"])
