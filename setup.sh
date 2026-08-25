#!/bin/bash
# =========================================
# SCRIPT NAME: K3ko Script
# VERSION: v7.0 All-In-One Unified Manager
# AUTHOR: HASSAN K3KO
# =========================================

C_RED='\033[1;31m'
C_GRN='\033[1;32m'
C_YLW='\033[1;33m'
C_BLU='\033[1;34m'
C_PRP='\033[1;35m'
C_CYN='\033[1;36m'
C_WHT='\033[1;37m'
C_NC='\033[0m'

CONFIG_FILE="/etc/k3ko_settings.conf"
[ ! -f "$CONFIG_FILE" ] && echo "DOMAIN=Auto" > "$CONFIG_FILE" && echo "DNS_DOMAIN=None" >> "$CONFIG_FILE" && echo "PORT_SSH=22" >> "$CONFIG_FILE" && echo "PORT_SSL=443" >> "$CONFIG_FILE" && echo "PORT_WS=80" >> "$CONFIG_FILE"

INSTALL_DATE_FILE="/etc/vps_install_date.txt"
[ ! -f "$INSTALL_DATE_FILE" ] && date +%s > "$INSTALL_DATE_FILE"
INSTALL_TIME=$(cat "$INSTALL_DATE_FILE")
CURRENT_TIME=$(date +%s)
VPS_DAYS=$(( (CURRENT_TIME - INSTALL_TIME) / 86400 ))
[ $VPS_DAYS -lt 0 ] && VPS_DAYS=0

while true; do
    clear
    [ -f /etc/os-release ] && . /etc/os-release && SYS_OS="$NAME" || SYS_OS="Linux"
    
    PUBLIC_IP=$(curl -s ifconfig.me || echo "N/A")
    SAVED_DOMAIN=$(grep "DOMAIN=" "$CONFIG_FILE" | cut -d= -f2)
    SAVED_DNS=$(grep "DNS_DOMAIN=" "$CONFIG_FILE" | cut -d= -f2)
    [ "$SAVED_DOMAIN" = "Auto" ] && DOMAIN="$PUBLIC_IP" || DOMAIN="$SAVED_DOMAIN"
    
    TOTAL_USERS=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)

    echo -e "${C_PRP}╔════════════════════════════════════════════════════════════╗${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_YLW}                ⚡  H A S S A N   K 3 K O  ⚡               ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_CYN}             [ ALL-IN-ONE VPS MANAGER v7.0 ]            ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• IP Address :${C_NC} ${C_WHT}$PUBLIC_IP${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• Main Domain:${C_NC} ${C_CYN}$DOMAIN${C_NC} | ${C_BLU}DNS:${C_NC} ${C_YLW}$SAVED_DNS${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• Total Users:${C_NC} ${C_GRN}$TOTAL_USERS Active Users${C_NC}                   ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_YLW}                   --- MAIN CONTROL ---                     ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[1]${C_NC} 🚀 Install & Setup Core Protocols (SSL, WS, Xray)  ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[2]${C_NC} 👤 Unified Users Manager (Create, Delete, Stats)   ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[3]${C_NC} ⚙️ All-In-One Settings (Domain, DNS, Ports, Banner) ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[4]${C_NC} 🔄 Update Script from Web (GitHub)                 ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╚════════════════════════════════════════════════════════════╝${C_NC}"
    echo ""
    read -n 1 -p "Select option [1-4]: " choice
    echo ""

    case $choice in
        1)
            clear
            echo -e "${C_YLW}--- INSTALLING SERVICES ---${C_NC}"
            apt-get update -y >/dev/null 2>&1
            apt-get install stunnel4 python3 python3-pip ufw iptables -y >/dev/null 2>&1
            
            P_SSL=$(grep "PORT_SSL=" "$CONFIG_FILE" | cut -d= -f2)
            P_SSH=$(grep "PORT_SSH=" "$CONFIG_FILE" | cut -d= -f2)
            P_WS=$(grep "PORT_WS=" "$CONFIG_FILE" | cut -d= -f2)

            cat <<EOF > /etc/stunnel/stunnel.conf
cert = /etc/stunnel/stunnel.pem
client = no
[dropbear]
accept = $P_SSL
connect = 127.0.0.1:$P_SSH
EOF
            openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=City/O=Org/CN=k3ko" -keyout /etc/stunnel/stunnel.pem -out /etc/stunnel/stunnel.pem >/dev/null 2>&1
            sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
            systemctl restart stunnel4

            cat << 'EOF' > /usr/local/bin/ws-proxy.py
import asyncio
import websockets
async def echo(websocket, path):
    async for message in websocket:
        await websocket.send(message)
start_server = websockets.serve(echo, "0.0.0.0", 80)
asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
EOF
            pip3 install websockets >/dev/null 2>&1
            bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install >/dev/null 2>&1

            echo -e "${C_GRN}Services Installed Successfully!${C_NC}"
            read -p "Press Enter to continue..."
            ;;
        2)
            while true; do
                clear
                echo -e "${C_PRP}╔════════════════════════════════════════════════════════════╗${C_NC}"
                echo -e "${C_PRP}║${C_NC}${C_YLW}              --- UNIFIED USERS MANAGER ---                 ${C_NC}${C_PRP}║${C_NC}"
                echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[1]${C_NC} Create New Account (SSH & V2Ray)                   ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[2]${C_NC} Delete Account                                     ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[3]${C_NC} Modify User (Password, Days, Max Devices)        ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[4]${C_NC} List All Users & Check Online Status               ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[5]${C_NC} Return to Main Menu                              ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}╚════════════════════════════════════════════════════════════╝${C_NC}"
                read -p "Choose [1-5]: " u_opt
                
                case $u_opt in
                    1)
                        clear
                        echo -e "${C_GRN}--- CREATE NEW USER ---${C_NC}"
                        read -p "Enter Username: " uname
                        read -p "Enter Password: " upass
                        read -p "Enter Expiry Days (e.g., 30): " udays
                        read -p "Enter Max Limit (Devices online): " ulimit
                        
                        useradd -M -s /bin/false "$uname" 2>/dev/null
                        echo "$uname:$upass" | chpasswd
                        EXP_DATE=$(date -d "+$udays days" +"%Y-%m-%d" 2>/dev/null || date -v +${udays}d +"%Y-%m-%d" 2>/dev/null)
                        chage -E "$EXP_DATE" "$uname" 2>/dev/null
                        echo "$ulimit" > "/etc/security/limits.d/$uname.limit" 2>/dev/null
                        
                        V_UUID=$(cat /proc/sys/kernel/random/uuid)
                        echo "$uname:$V_UUID" >> /etc/v2ray_users.txt 2>/dev/null
                        
                        echo -e "\n${C_GRN}==================================================${C_NC}"
                        echo -e "${C_YLW}         ACCOUNT CREATED SUCCESSFULLY             ${C_NC}"
                        echo -e "${C_GRN}==================================================${C_NC}"
                        echo -e "${C_WHT} Username   : ${C_CYN}$uname${C_NC}"
                        echo -e "${C_WHT} Password   : ${C_CYN}$upass${C_NC}"
                        echo -e "${C_WHT} V2Ray UUID : ${C_CYN}$V_UUID${C_NC}"
                        echo -e "${C_WHT} Valid Days : ${C_GRN}$udays Days (Expires: $EXP_DATE)${C_NC}"
                        echo -e "${C_WHT} Max Limit  : ${C_GRN}$ulimit Device(s)${C_NC}"
                        echo -e "${C_WHT} Host / IP  : ${C_CYN}$PUBLIC_IP${C_NC}"
                        echo -e "${C_GRN}==================================================${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    2)
                        clear
                        echo -e "${C_RED}--- DELETE USER ---${C_NC}"
                        read -p "Enter Username to delete: " uname
                        userdel -r "$uname" 2>/dev/null
                        rm -f "/etc/security/limits.d/$uname.limit" 2>/dev/null
                        sed -i "/^$uname:/d" /etc/v2ray_users.txt 2>/dev/null
                        echo -e "${C_RED}User deleted successfully!${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    3)
                        clear
                        echo -e "${C_YLW}--- MODIFY USER ---${C_NC}"
                        read -p "Enter Username to modify: " uname
                        if id "$uname" &>/dev/null; then
                            echo "1. Change Password"
                            echo "2. Change Expiry Days"
                            read -p "Choose [1-2]: " mod_c
                            if [ "$mod_c" = "1" ]; then
                                read -p "Enter New Password: " new_p
                                echo "$uname:$new_p" | chpasswd
                                echo -e "${C_GRN}Password updated successfully!${C_NC}"
                            elif [ "$mod_c" = "2" ]; then
                                read -p "Enter Days count (e.g., 30): " new_d
                                NEW_EXP=$(date -d "+$new_d days" +"%Y-%m-%d" 2>/dev/null || date -v +${new_d}d +"%Y-%m-%d" 2>/dev/null)
                                chage -E "$NEW_EXP" "$uname" 2>/dev/null
                                echo -e "${C_GRN}Expiry updated to: $NEW_EXP${C_NC}"
                            fi
                        else
                            echo -e "${C_RED}User does not exist!${C_NC}"
                        fi
                        read -p "Press Enter to continue..."
                        ;;
                    4)
                        clear
                        TOTAL_CHECK=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)
                        echo -e "${C_GRN}=== TOTAL CREATED USERS: $TOTAL_CHECK ===${C_NC}"
                        echo "----------------------------------------------------------------------------------"
                        printf "${C_CYN}%-12s | %-12s | %-15s | %-15s${C_NC}\n" "USERNAME" "EXPIRES" "MAX LIMIT" "ONLINE STATUS"
                        echo "----------------------------------------------------------------------------------"
                        for user in $(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd); do
                            exp_date=$(chage -l "$user" 2>/dev/null | grep "Account expires" | cut -d: -f2 | xargs)
                            [ -z "$exp_date" ] || [ "$exp_date" = "never" ] && exp_date="Unlimited"
                            max_limit=$(cat "/etc/security/limits.d/$user.limit" 2>/dev/null || echo "1")
                            active_count=$(ps -u "$user" | grep -v "PID" | wc -l)
                            [ "$active_count" -gt 0 ] && active_str="${C_GRN}$active_count Connected${C_NC}" || active_str="${C_RED}0 Offline${C_NC}"
                            printf "${C_WHT}%-12s${C_NC} | ${C_WHT}%-12s${C_NC} | ${C_YLW}%-15s${C_NC} | %-15s\n" "$user" "$exp_date" "$max_limit Device(s)" "$active_str"
                        done
                        echo "----------------------------------------------------------------------------------"
                        read -p "Press Enter to continue..."
                        ;;
                    5)
                        break
                        ;;
                esac
            done
            ;;
        3)
            while true; do
                clear
                echo -e "${C_PRP}╔════════════════════════════════════════════════════════════╗${C_NC}"
                echo -e "${C_PRP}║${C_NC}${C_YLW}               --- ALL-IN-ONE SETTINGS ---                  ${C_NC}${C_PRP}║${C_NC}"
                echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[1]${C_NC} Set / Change Main Domain                           ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[2]${C_NC} Set / Change DNS Domain (Cloudflare/Subdomain)     ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[3]${C_NC} Setup & Configure Ports (SSH, SSL, WS)             ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[4]${C_NC} Remove Server Banner                               ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[5]${C_NC} Return to Main Menu                              ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}╚════════════════════════════════════════════════════════════╝${C_NC}"
                read -p "Choose [1-5]: " s_opt
                
                case $s_opt in
                    1)
                        clear
                        read -p "Enter Main Domain (e.g., example.com): " d_main
                        sed -i "/DOMAIN=/c\DOMAIN=$d_main" "$CONFIG_FILE"
                        echo -e "${C_GRN}Main Domain updated to: $d_main${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    2)
                        clear
                        read -p "Enter DNS Domain (e.g., dns.example.com): " d_dns
                        sed -i "/DNS_DOMAIN=/c\DNS_DOMAIN=$d_dns" "$CONFIG_FILE"
                        echo -e "${C_GRN}DNS Domain updated to: $d_dns${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    3)
                        clear
                        echo -e "${C_CYN}--- PORTS CONFIGURATION ---${C_NC}"
                        curr_ssh=$(grep "PORT_SSH=" "$CONFIG_FILE" | cut -d= -f2)
                        curr_ssl=$(grep "PORT_SSL=" "$CONFIG_FILE" | cut -d= -f2)
                        curr_ws=$(grep "PORT_WS=" "$CONFIG_FILE" | cut -d= -f2)
                        
                        echo -e "Current SSH Port : ${C_YLW}$curr_ssh${C_NC}"
                        echo -e "Current SSL Port : ${C_YLW}$curr_ssl${C_NC}"
                        echo -e "Current WS Port  : ${C_YLW}$curr_ws${C_NC}"
                        echo "-----------------------------------"
                        read -p "Enter new SSH Port (or press enter to keep): " new_ssh
                        read -p "Enter new SSL Port (or press enter to keep): " new_ssl
                        read -p "Enter new WS Port (or press enter to keep): " new_ws
                        
                        [ ! -z "$new_ssh" ] && sed -i "/PORT_SSH=/c\PORT_SSH=$new_ssh" "$CONFIG_FILE"
                        [ ! -z "$new_ssl" ] && sed -i "/PORT_SSL=/c\PORT_SSL=$new_ssl" "$CONFIG_FILE"
                        [ ! -z "$new_ws" ] && sed -i "/PORT_WS=/c\PORT_WS=$new_ws" "$CONFIG_FILE"
                        
                        echo -e "${C_GRN}Ports updated successfully in configuration file!${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    4)
                        clear
                        rm -f /etc/issue.net
                        sed -i '/Banner/d' /etc/ssh/sshd_config 2>/dev/null
                        systemctl restart ssh 2>/dev/null || systemctl restart sshd 2>/dev/null
                        echo -e "${C_RED}Server Banner removed completely!${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    5)
                        break
                        ;;
                esac
            done
            ;;
        4)
            clear
            echo -e "${C_YLW}Updating script...${C_NC}"
            wget --no-cache -O setup.sh https://raw.githubusercontent.com/hassankako/vps-malak/main/setup.sh >/dev/null 2>&1
            chmod +x setup.sh
            exec ./setup.sh
            ;;
    esac
done
