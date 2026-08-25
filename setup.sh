#!/bin/bash
# =========================================
# SCRIPT NAME: K3ko Script
# VERSION: v7.3 All Ports Integrated & Auto-Open
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
if [ ! -f "$CONFIG_FILE" ]; then
    echo "DOMAIN=Auto" > "$CONFIG_FILE"
    echo "DNS_DOMAIN=None" >> "$CONFIG_FILE"
    echo "PORT_SSH=22" >> "$CONFIG_FILE"
    echo "PORT_SSL=443" >> "$CONFIG_FILE"
    echo "PORT_WS=80" >> "$CONFIG_FILE"
    echo "PORT_WS2=8080" >> "$CONFIG_FILE"
    echo "PORT_CF1=2053" >> "$CONFIG_FILE"
    echo "PORT_CF2=2083" >> "$CONFIG_FILE"
    echo "PORT_CF3=2096" >> "$CONFIG_FILE"
    echo "PORT_XRAY=8443" >> "$CONFIG_FILE"
fi

LOCKED_BANNER="
════════════════════════════════════════════════════════════
 💥 ɪɴᴛᴇʀɴᴇᴛ ɪʟɪᴍɪᴛᴀᴅᴏ ☄️
                 『 HASSAN K3KO 』
               بسم الله الرحمن الرحيم 🛰️
                     حسان كعكو
 |whatsapp 
‏أضف رقمي كجهة اتصال في واتساب: https://wa.me/qr/BQSQFESYU5NUB1 📳
 |حسان كعكو 📺 |لخدمات الإنترنت 🗂
 كافة الخطوط وشرائح esim التي يعمل عليها الانترنت
 شكرا لاستخدام خدماتنا
════════════════════════════════════════════════════════════
"
echo "$LOCKED_BANNER" > /etc/issue.net
sed -i '/Banner/d' /etc/ssh/sshd_config 2>/dev/null
echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
systemctl restart ssh 2>/dev/null || systemctl restart sshd 2>/dev/null

while true; do
    clear
    [ -f /etc/os-release ] && . /etc/os-release && SYS_OS="$NAME" || SYS_OS="Linux"
    
    PUBLIC_IP=$(curl -s ifconfig.me || echo "N/A")
    SAVED_DOMAIN=$(grep "DOMAIN=" "$CONFIG_FILE" | cut -d= -f2)
    SAVED_DNS=$(grep "DNS_DOMAIN=" "$CONFIG_FILE" | cut -d= -f2)
    [ "$SAVED_DOMAIN" = "Auto" ] && DOMAIN="$PUBLIC_IP" || DOMAIN="$SAVED_DOMAIN"
    
    SSH_USERS_COUNT=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)
    V2RAY_USERS_COUNT=$(wc -l < /etc/v2ray_users.txt 2>/dev/null || echo "0")

    echo -e "${C_PRP}╔════════════════════════════════════════════════════════════╗${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_YLW}                ⚡  H A S S A N   K 3 K O  ⚡               ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_CYN}             [ ALL PORTS MANAGER v7.3 ]                 ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• IP Address  :${C_NC} ${C_WHT}$PUBLIC_IP${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• Domain / DNS:${C_NC} ${C_CYN}$DOMAIN${C_NC} | ${C_YLW}$SAVED_DNS${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• Users Count :${C_NC} ${C_GRN}SSH: $SSH_USERS_COUNT${C_NC} | ${C_CYN}V2Ray: $V2RAY_USERS_COUNT${C_NC}       ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_YLW}                   --- MAIN CONTROL ---                     ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[1]${C_NC} 🚀 Install Core Protocols & Open All Ports         ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[2]${C_NC} 👤 SSH Accounts Manager (Create, Delete, Online)   ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[3]${C_NC} 🌐 V2Ray Accounts Manager (Create, Delete, List)   ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[4]${C_NC} ⚙️ Settings (Domain, DNS, All Ports, Locked Banner) ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[5]${C_NC} 🔄 Update Script from Web (GitHub)                 ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╚════════════════════════════════════════════════════════════╝${C_NC}"
    echo ""
    read -n 1 -p "Select option [1-5]: " choice
    echo ""

    case $choice in
        1)
            clear
            echo -e "${C_YLW}--- INSTALLING SERVICES & OPENING ALL PORTS ---${C_NC}"
            apt-get update -y >/dev/null 2>&1
            apt-get install stunnel4 python3 python3-pip ufw iptables -y >/dev/null 2>&1
            
            # فتح جميع البورتات تلقائياً في جدار الحماية UFW
            ufw allow 22/tcp >/dev/null 2>&1
            ufw allow 80/tcp >/dev/null 2>&1
            ufw allow 443/tcp >/dev/null 2>&1
            ufw allow 8080/tcp >/dev/null 2>&1
            ufw allow 8880/tcp >/dev/null 2>&1
            ufw allow 2053/tcp >/dev/null 2>&1
            ufw allow 2083/tcp >/dev/null 2>&1
            ufw allow 2096/tcp >/dev/null 2>&1
            ufw allow 8443/tcp >/dev/null 2>&1
            ufw --force enable >/dev/null 2>&1

            P_SSL=$(grep "PORT_SSL=" "$CONFIG_FILE" | cut -d= -f2)
            P_SSH=$(grep "PORT_SSH=" "$CONFIG_FILE" | cut -d= -f2)

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

            echo -e "${C_GRN}All Services Installed & All Ports Opened Successfully!${C_NC}"
            read -p "Press Enter to continue..."
            ;;
        2)
            while true; do
                clear
                echo -e "${C_PRP}╔════════════════════════════════════════════════════════════╗${C_NC}"
                echo -e "${C_PRP}║${C_NC}${C_YLW}               --- SSH ACCOUNTS MANAGER ---                 ${C_NC}${C_PRP}║${C_NC}"
                echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[1]${C_NC} Create SSH Account (Username, Password, Days)    ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[2]${C_NC} Delete SSH Account                                 ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[3]${C_NC} Modify SSH Account (Password or Expiry Days)       ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[4]${C_NC} List SSH Users & Check Online Connections          ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[5]${C_NC} Return to Main Menu                              ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}╚════════════════════════════════════════════════════════════╝${C_NC}"
                read -p "Choose [1-5]: " ssh_opt
                
                case $ssh_opt in
                    1)
                        clear
                        echo -e "${C_GRN}--- CREATE SSH USER ---${C_NC}"
                        read -p "Enter Username: " uname
                        read -p "Enter Password: " upass
                        read -p "Enter Expiry Days (e.g., 30): " udays
                        read -p "Enter Max Devices Limit: " ulimit
                        
                        useradd -M -s /bin/false "$uname" 2>/dev/null
                        echo "$uname:$upass" | chpasswd
                        EXP_DATE=$(date -d "+$udays days" +"%Y-%m-%d" 2>/dev/null || date -v +${udays}d +"%Y-%m-%d" 2>/dev/null)
                        chage -E "$EXP_DATE" "$uname" 2>/dev/null
                        echo "$ulimit" > "/etc/security/limits.d/$uname.limit" 2>/dev/null
                        
                        echo -e "\n${C_GRN}==================================================${C_NC}"
                        echo -e "${C_YLW}           SSH USER CREATED SUCCESSFULLY          ${C_NC}"
                        echo -e "${C_GRN}==================================================${C_NC}"
                        echo -e "${C_WHT} Username   : ${C_CYN}$uname${C_NC}"
                        echo -e "${C_WHT} Password   : ${C_CYN}$upass${C_NC}"
                        echo -e "${C_WHT} Expires On : ${C_GRN}$EXP_DATE ($udays Days)${C_NC}"
                        echo -e "${C_WHT} Max Limit  : ${C_GRN}$ulimit Device(s)${C_NC}"
                        echo -e "${C_WHT} Host / IP  : ${C_CYN}$PUBLIC_IP${C_NC}"
                        echo -e "${C_GRN}==================================================${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    2)
                        clear
                        echo -e "${C_RED}--- DELETE SSH USER ---${C_NC}"
                        read -p "Enter Username to delete: " uname
                        userdel -r "$uname" 2>/dev/null
                        rm -f "/etc/security/limits.d/$uname.limit" 2>/dev/null
                        echo -e "${C_RED}SSH User $uname deleted successfully!${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    3)
                        clear
                        echo -e "${C_YLW}--- MODIFY SSH USER ---${C_NC}"
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
                        TOTAL_SSH=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)
                        echo -e "${C_GRN}=== TOTAL SSH USERS: $TOTAL_SSH ===${C_NC}"
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
                echo -e "${C_PRP}║${C_NC}${C_YLW}              --- V2RAY ACCOUNTS MANAGER ---                ${C_NC}${C_PRP}║${C_NC}"
                echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[1]${C_NC} Create V2Ray Account (VMess / VLess UUID)        ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[2]${C_NC} Delete V2Ray Account                             ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[3]${C_NC} List All V2Ray Users & UUIDs                     ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[4]${C_NC} Return to Main Menu                              ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}╚════════════════════════════════════════════════════════════╝${C_NC}"
                read -p "Choose [1-4]: " v2_opt
                
                case $v2_opt in
                    1)
                        clear
                        echo -e "${C_GRN}--- CREATE V2RAY USER ---${C_NC}"
                        read -p "Enter V2Ray Username: " v_name
                        V_UUID=$(cat /proc/sys/kernel/random/uuid)
                        echo "$v_name:$V_UUID" >> /etc/v2ray_users.txt
                        
                        echo -e "\n${C_GRN}==================================================${C_NC}"
                        echo -e "${C_YLW}          V2RAY USER CREATED SUCCESSFULLY         ${C_NC}"
                        echo -e "${C_GRN}==================================================${C_NC}"
                        echo -e "${C_WHT} Username   : ${C_CYN}$v_name${C_NC}"
                        echo -e "${C_WHT} V2Ray UUID : ${C_CYN}$V_UUID${C_NC}"
                        echo -e "${C_WHT} Host / IP  : ${C_CYN}$PUBLIC_IP${C_NC}"
                        echo -e "${C_GRN}==================================================${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    2)
                        clear
                        echo -e "${C_RED}--- DELETE V2RAY USER ---${C_NC}"
                        read -p "Enter V2Ray Username to delete: " v_name
                        sed -i "/^$v_name:/d" /etc/v2ray_users.txt 2>/dev/null
                        echo -e "${C_RED}V2Ray user deleted successfully!${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    3)
                        clear
                        V_COUNT=$(wc -l < /etc/v2ray_users.txt 2>/dev/null || echo "0")
                        echo -e "${C_GRN}=== TOTAL V2RAY USERS: $V_COUNT ===${C_NC}"
                        echo "----------------------------------------------------------------------------------"
                        printf "${C_CYN}%-15s | %-36s${C_NC}\n" "USERNAME" "UUID KEY"
                        echo "----------------------------------------------------------------------------------"
                        if [ -f /etc/v2ray_users.txt ]; then
                            while IFS=':' read -r v_u v_uuid; do
                                printf "${C_WHT}%-15s${C_NC} | ${C_YLW}%-36s${C_NC}\n" "$v_u" "$v_uuid"
                            done < /etc/v2ray_users.txt
                        fi
                        echo "----------------------------------------------------------------------------------"
                        read -p "Press Enter to continue..."
                        ;;
                    4)
                        break
                        ;;
                esac
            done
            ;;
        4)
            while true; do
                clear
                echo -e "${C_PRP}╔════════════════════════════════════════════════════════════╗${C_NC}"
                echo -e "${C_PRP}║${C_NC}${C_YLW}               --- ALL PORTS SETTINGS ---                   ${C_NC}${C_PRP}║${C_NC}"
                echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[1]${C_NC} Set / Change Main Domain                           ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[2]${C_NC} Set / Change DNS Domain (Cloudflare/Subdomain)     ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[3]${C_NC} Configure All Ports (SSH, SSL, WS, CF, Xray)       ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[4]${C_NC} View Locked Official Banner                      ${C_PRP}║${C_NC}"
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
                        echo -e "${C_CYN}--- ALL PORTS CONFIGURATION ---${C_NC}"
                        c_ssh=$(grep "PORT_SSH=" "$CONFIG_FILE" | cut -d= -f2)
                        c_ssl=$(grep "PORT_SSL=" "$CONFIG_FILE" | cut -d= -f2)
                        c_ws=$(grep "PORT_WS=" "$CONFIG_FILE" | cut -d= -f2)
                        c_ws2=$(grep "PORT_WS2=" "$CONFIG_FILE" | cut -d= -f2)
                        c_cf1=$(grep "PORT_CF1=" "$CONFIG_FILE" | cut -d= -f2)
                        c_cf2=$(grep "PORT_CF2=" "$CONFIG_FILE" | cut -d= -f2)
                        c_cf3=$(grep "PORT_CF3=" "$CONFIG_FILE" | cut -d= -f2)
                        c_xray=$(grep "PORT_XRAY=" "$CONFIG_FILE" | cut -d= -f2)
                        
                        echo -e "SSH Port      : ${C_YLW}$c_ssh${C_NC}"
                        echo -e "SSL Port      : ${C_YLW}$c_ssl${C_NC}"
                        echo -e "WS Port 1     : ${C_YLW}$c_ws${C_NC}"
                        echo -e "WS Port 2     : ${C_YLW}$c_ws2${C_NC}"
                        echo -e "Cloudflare 1  : ${C_YLW}$c_cf1${C_NC}"
                        echo -e "Cloudflare 2  : ${C_YLW}$c_cf2${C_NC}"
                        echo -e "Cloudflare 3  : ${C_YLW}$c_cf3${C_NC}"
                        echo -e "Xray Port     : ${C_YLW}$c_xray${C_NC}"
                        echo "--------------------------------------------------------"
                        read -p "Enter new SSH Port (Enter to keep): " n_ssh
                        read -p "Enter new SSL Port (Enter to keep): " n_ssl
                        read -p "Enter new WS Port 1 (Enter to keep): " n_ws
                        read -p "Enter new WS Port 2 (Enter to keep): " n_ws2
                        read -p "Enter new CF Port 1 (Enter to keep): " n_cf1
                        read -p "Enter new CF Port 2 (Enter to keep): " n_cf2
                        read -p "Enter new CF Port 3 (Enter to keep): " n_cf3
                        read -p "Enter new Xray Port (Enter to keep): " n_xray
                        
                        [ ! -z "$n_ssh" ] && sed -i "/PORT_SSH=/c\PORT_SSH=$n_ssh" "$CONFIG_FILE" && ufw allow "$n_ssh"/tcp >/dev/null 2>&1
                        [ ! -z "$n_ssl" ] && sed -i "/PORT_SSL=/c\PORT_SSL=$n_ssl" "$CONFIG_FILE" && ufw allow "$n_ssl"/tcp >/dev/null 2>&1
                        [ ! -z "$n_ws" ] && sed -i "/PORT_WS=/c\PORT_WS=$n_ws" "$CONFIG_FILE" && ufw allow "$n_ws"/tcp >/dev/null 2>&1
                        [ ! -z "$n_ws2" ] && sed -i "/PORT_WS2=/c\PORT_WS2=$n_ws2" "$CONFIG_FILE" && ufw allow "$n_ws2"/tcp >/dev/null 2>&1
                        [ ! -z "$n_cf1" ] && sed -i "/PORT_CF1=/c\PORT_CF1=$n_cf1" "$CONFIG_FILE" && ufw allow "$n_cf1"/tcp >/dev/null 2>&1
                        [ ! -z "$n_cf2" ] && sed -i "/PORT_CF2=/c\PORT_CF2=$n_cf2" "$CONFIG_FILE" && ufw allow "$n_cf2"/tcp >/dev/null 2>&1
                        [ ! -z "$n_cf3" ] && sed -i "/PORT_CF3=/c\PORT_CF3=$n_cf3" "$CONFIG_FILE" && ufw allow "$n_cf3"/tcp >/dev/null 2>&1
                        [ ! -z "$n_xray" ] && sed -i "/PORT_XRAY=/c\PORT_XRAY=$n_xray" "$CONFIG_FILE" && ufw allow "$n_xray"/tcp >/dev/null 2>&1
                        
                        echo -e "${C_GRN}All Ports updated and opened successfully in firewall!${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    4)
                        clear
                        echo -e "${C_CYN}--- LOCKED OFFICIAL BANNER ---${C_NC}"
                        cat /etc/issue.net
                        echo "--------------------------------------------------------"
                        echo -e "${C_YLW}Note: This banner is officially locked and cannot be modified or removed.${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    5)
                        break
                        ;;
                esac
            done
            ;;
        5)
            clear
            echo -e "${C_YLW}Updating script...${C_NC}"
            wget --no-cache -O setup.sh https://raw.githubusercontent.com/hassankako/vps-malak/main/setup.sh >/dev/null 2>&1
            chmod +x setup.sh
            exec ./setup.sh
            ;;
    esac
done
