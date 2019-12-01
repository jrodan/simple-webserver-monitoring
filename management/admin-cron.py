import os
import config as cfg
import sys
import json

# INSTALL: adds the scripts header cronjob description to /etc/cron.d/FILENAME
# STATUS: shows the status of available scripts and their INSTALL status
# UNINSTALL: removed the cron file


def main():

    command = ""
    param = ""

    if(len(sys.argv) == 2):
        command = "status"
    elif(len(sys.argv) == 3):
        command = sys.argv[1].lower()
        param = sys.argv[2]
    else:
        command = "status"

    if(command == "install"):
        installScript(param)
    elif(command == "uninstall"):
        uninstallScript(param)
    else:
        showStatus()


def installScript(scriptName):

    availableFiles = getAvailableScripts()
    foundName = ""

    # get script name
    for fileName in availableFiles:
        if(fileName.startswith(scriptName)):
            foundName = fileName
            break

    # extract cron details
    cronText = ""
    with open(cfg.scriptsFolder+foundName, 'rt') as openedFile:
        for line in openedFile:
            if(line.startswith(cfg.cronRegex)):
                cronText += line[len(cfg.cronRegex):len(line)
                                 ].replace(cfg.scriptRegex, cfg.scriptsFolder+foundName)

    # write new file
    cronFileName = foundName[0:foundName.find(".")]
    f = open(cfg.cronPath+cronFileName, 'w')
    f.write(cronText)
    f.close()

    # set execute permission for script and cronfile
    os.chmod(cfg.scriptsFolder+foundName, 0o744)
    os.chmod(cfg.cronPath+cronFileName, 0o744)

    print("script "+scriptName+" was successfully installed")


def uninstallScript(scriptName):

    installedFiles = getInstalledScripts()

    # get script name
    for fileName in installedFiles:
        if(fileName.startswith(scriptName)):
            foundName = fileName
            break

    os.remove(cfg.cronPath+fileName)

    print("script "+scriptName+" was uninstalled successfully")


def showStatus():

    availableFiles = getAvailableScripts()
    installedFiles = getInstalledScripts()

    print("available scripts: "+json.dumps(availableFiles))
    print("installed scripts: "+json.dumps(installedFiles))


def getInstalledScripts():

    installedFiles = [f for f in os.listdir(
        cfg.cronPath) if os.path.isfile(os.path.join(cfg.cronPath, f))]

    return installedFiles


def getAvailableScripts():

    foundScripts = []

    onlyfiles = [f for f in os.listdir(
        cfg.scriptsFolder) if os.path.isfile(os.path.join(cfg.scriptsFolder, f))]

    for fileName in onlyfiles:
        if(not fileName.startswith(".")):
            foundScripts.append(fileName)

    return foundScripts


if __name__ == '__main__':
    main()
