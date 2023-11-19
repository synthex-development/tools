#!/bin/bash

clear

if [[ $EUID -ne 0 ]]; then
  echo "→ Dieser Installer muss mit root Rechten ausgeführt werden!" 1>&2
  exit 1
fi
echo "";
echo '###########################'
echo '  synthex - Configuration'
echo '###########################'
echo "";

ping -c1 -W1 -q google.com &>/dev/null
status=$( echo $? )
if [[ $status == 0 ]]
then
    echo "";
    echo "";
    echo "✓ Internet";
else
    echo "";
    echo "";
    echo "✗ Internet | Einstellungen Prüfen";
    exit 1
fi

apt update &>/dev/null
echo "✓ Update";

apt upgrade -y &>/dev/null
echo "✓ Upgrade";

sleep 2

echo "


                       _     _                   
                      | |   | |                  
 ___   _   _   _ __   | |_  | |__     ___  __  __
/ __| | | | | | '_ \  | __| | '_ \   / _ \ \ \/ /
\__ \ | |_| | | | | | | |_  | | | | |  __/  >  < 
|___/  \__, | |_| |_|  \__| |_| |_|  \___| /_/\_\\
        __/ |                                    
       |___/                                     


" | tee /etc/motd >/dev/null
echo "✓ Change MOTD";

sleep 2

echo "
Include /etc/ssh/sshd_config.d/*.conf

Port 22
PermitRootLogin yes

ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding yes

UsePAM yes
X11Forwarding yes
PrintMotd no
AcceptEnv LANG LC_*
Subsystem       sftp    /usr/lib/openssh/sftp-server

" | tee /etc/ssh/sshd_config >/dev/null
systemctl restart ssh
systemctl restart sshd
echo "✓ Change SSH Config";

sleep 1

apt install sudo screen htop -y &>/dev/null
echo "✓ Adding packages";

sleep 1

echo "";
echo "";
echo "";
echo "###########################";
echo -e "     \033[32mServer Neustart";
echo -e "\033[0m###########################";
echo "";

sleep 3

sudo reboot