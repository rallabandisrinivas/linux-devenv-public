#!/usr/bin/env python3
import subprocess
import sys

environment : str = sys.argv[1]

keys = ["org.gnome.DejaDup last-restore",
        "org.gnome.DejaDup last-restore",
        "org.gnome.DejaDup periodic",
        "org.gnome.DejaDup periodic-period",
        "org.gnome.DejaDup full-backup-period",
        "org.gnome.DejaDup backend",
        "org.gnome.DejaDup last-run",
        "org.gnome.DejaDup nag-check",
        "org.gnome.DejaDup prompt-check",
        "org.gnome.DejaDup root-prompt",
        "org.gnome.DejaDup include-list",
        "org.gnome.DejaDup exclude-list",
        "org.gnome.DejaDup last-backup",
        "org.gnome.DejaDup allow-metered",
        "org.gnome.DejaDup delete-after",
        "org.gnome.DejaDup.Remote folder"]

backupDir: str
scriptFile: str

if environment == "vm":
    backupDir = "BackupVM"
    scriptFile = "restore_dejadupsettings_vm.sh"
elif environment == "pc":
    backupDir = "BackupPC"
    scriptFile = "restore_dejadupsettings_pc.sh"

scriptText : str = "#!/bin/bash\n\n"

for key in keys:
    get = lambda cmd: subprocess.check_output(["/bin/bash", "-c", cmd]).decode("utf-8")
    
    array_str = get("gsettings get " + key)
    command_result = array_str.lstrip("@as")

    "gsettings set " + key + " " + command_result

    scriptText += "gsettings set " + key + " " + "\"" + command_result.replace("\n", "") + "\"" + "\n"

with open(scriptFile, 'w') as f:
    f.write(scriptText)