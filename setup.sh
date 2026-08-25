#!/bin/bash
# =========================================
# SCRIPT NAME: K3ko Script
# VERSION: v7.9 Full SSH + V2Ray + FastDNS & Ports
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
    [ "$SAVED_DOMAIN" = "Auto" ] && DOMAIN="$PUBLIC_IP" || DOMAIN="$SAVED_DOMAIN"
    
    SSH_USERS_COUNT=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)
    V2RAY_USERS_COUNT=$(wc -l < /etc/v2ray_users.txt 2>/dev/null || echo "0")

    echo -e "${C_PRP}╔════════════════════════════════════════════════════════════╗${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_YLW}                ⚡  H A S S A N   K 3 K O  ⚡               ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_CYN}             [ SCRIPT MANAGER v7.9 ]                    ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• IP Address  :${C_NC} ${C_WHT}$PUBLIC_IP${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• Domain      :${C_NC} ${C_CYN}$DOMAIN${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• Users Count :${C_NC} ${C_GRN}SSH: $SSH_USERS_COUNT${C_NC} | ${C_CYN}V2Ray: $V2RAY_USERS_COUNT${C_NC}       ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_YLW}                   --- MAIN CONTROL ---                     ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[1]${C_NC} 🚀 Install & Auto-Open All Ports (FastDNS/80/53)   ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[2]${C_NC} 📊 Information Port Service (Ports List)           ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[3]${C_NC} 👤 SSH Accounts Manager                            ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[4]${C_NC} 🌐 V2Ray Accounts Manager                          ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[5]${C_NC} 🔄 Update Script from GitHub                       ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[0]${C_NC} 🚪 Exit                                            ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╚════════════════════════════════════════════════════════════╝${C_NC}"
    echo ""
    read -n 1 -p "Select option [0-5]: " choice
    echo ""

    case $choice in
        1)
            clear
            echo -e "${C_YLW}--- INSTALLING TOOLS & OPENING HIGH-SPEED PORTS (80, 53, DNS) ---${C_NC}"
            apt-get update -y >/dev/null 2>&1
            apt-get install ufw iptables -y >/dev/null 2>&1
            
            echo -e "${C_CYN}Configuring Firewall & Opening Ports (SSH, V2Ray, FastDNS)...${C_NC}"
            # بورتات الـ SSH، الويب، البورتات السريعة 80 و 53، و SlowDNS / FastDNS
            PORTS_TO_OPEN=(22 53 80 81 109 143 442 443 88 1194 2200 5300 7100 7200 7300 8080 8880)
            for p in "${PORTS_TO_OPEN[@]}"; do
                ufw allow "$p" >/dev/null 2>&1
                ufw allow "$p/udp" >/dev/null 2>&1
            done
            ufw --force enable >/dev/null 2>&1
            
            echo -e "${C_GRN}All Ports (including Port 80, 53 & FastDNS) Opened Successfully!${C_NC}"
            read -p "Press Enter to continue..."
            ;;
        2)
            clear
            echo -e "\n${C_WHT}\t┌──────────────────────────────────────────────┐${C_NC}"
            echo -e "\t│${C_RED}         » INFORMATION PORT SERVICE «         ${C_WHT}│${C_NC}"
            echo -e "\t└──────────────────────────────────────────────┘${C_NC}"
            echo -e "${C_YLW}\t┌──────────────────────────────────────────────┐${C_NC}"
            echo -e "\t│ ${C_GRN}» Open SSH                 ${C_CYN}: 443, 80, 22    ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» Dropbear                 ${C_CYN}: 443, 109, 143  ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» Dropbear Websocket       ${C_CYN}: 443, 109       ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» SSH Websocket SSL        ${C_CYN}: 443            ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» SSH Websocket            ${C_CYN}: 80             ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» SSH UDP (Speed Boost)    ${C_CYN}: 1-65535        ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» OpenVPN SSL              ${C_CYN}: 443            ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» OpenVPN Websocket SSL    ${C_CYN}: 443            ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» OpenVPN TCP              ${C_CYN}: 443, 1194      ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» OpenVPN UDP              ${C_CYN}: 2200           ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» Nginx Webserver          ${C_CYN}: 443, 80, 81    ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» Haproxy Loadbalancer     ${C_CYN}: 443, 80        ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» DNS Server               ${C_CYN}: 443, 53        ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» FastDNS / SlowDNS        ${C_CYN}: 53, 5300, 443  ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» XRAY Vmess TLS           ${C_CYN}: 443            ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» XRAY Vmess gRPC          ${C_CYN}: 443            ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» XRAY Vmess None TLS      ${C_CYN}: 80             ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» XRAY Vless TLS           ${C_CYN}: 443            ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» XRAY Vless gRPC          ${C_CYN}: 443            ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» XRAY Vless None TLS      ${C_CYN}: 80             ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» Trojan gRPC              ${C_CYN}: 443            ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» Trojan WS                ${C_CYN}: 443            ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» Shadowsocks WS           ${C_CYN}: 443            ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» BadVPN 1                 ${C_CYN}: 7100           ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» BadVPN 2                 ${C_CYN}: 7200           ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» BadVPN 3                 ${C_CYN}: 7300           ${C_YLW}│${C_NC}"
            echo -e "\t└──────────────────────────────────────────────┘${C_NC}"
            echo -e "\t${C_RED}* Upload By HASSAN K3KO *${C_NC}"
            echo ""
            read -p "Press Enter to return to main menu..."
            ;;
        3)
            while true; do
                clear
                echo -e "${C_PRP}╔════════════════════════════════════════════════════════════╗${C_NC}"
                echo -e "${C_PRP}║${C_NC}${C_YLW}                👤 SSH ACCOUNTS MANAGER                     ${C_NC}${C_PRP}║${C_NC}"
                echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[1]${C_NC} ➕ Create SSH Account                                ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[2]${C_NC} 🗑️ Delete SSH Account                              ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[3]${C_NC} 📋 List Active SSH Users                           ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[0]${C_NC} 🔙 Back to Main Menu                               ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}╚════════════════════════════════════════════════════════════╝${C_NC}"
                echo ""
                read -n 1 -p "Select option [0-3]: " ssh_choice
                echo ""
                
                case $ssh_choice in
                    1)
                        clear
                        echo -e "${C_YLW}--- CREATE NEW SSH ACCOUNT ---${C_NC}"
                        read -p "Enter Username: " username
                        if id "$username" >/dev/null 2>&1; then
                            echo -e "${C_RED}Error: User already exists!${C_NC}"
                        else
                            read -p "Enter Password: " password
                            read -p "Enter Expiry Days (e.g., 30): " days
                            
                            exp_date=$(date -d "+$days days" +"%Y-%m-%d" 2>/dev/null || date -v +${days}d +"%Y-%m-%d")
                            
                            useradd -e "$exp_date" -s /bin/false -M "$username" >/dev/null 2>&1
                            echo "$username:$password" | chpasswd >/dev/null 2>&1
                            
                            echo -e "${C_GRN}----------------------------------------${C_NC}"
                            echo -e "${C_GRN}Account Created Successfully!${C_NC}"
                            echo -e "Host/IP   : ${C_CYN}$PUBLIC_IP${C_NC}"
                            echo -e "Username  : ${C_WHT}$username${C_NC}"
                            echo -e "Password  : ${C_WHT}$password${C_NC}"
                            echo -e "Expires On: ${C_YLW}$exp_date${C_NC}"
                            echo -e "${C_GRN}----------------------------------------${C_NC}"
                        fi
                        read -p "Press Enter to continue..."
                        ;;
                    2)
                        clear
                        echo -e "${C_YLW}--- DELETE SSH ACCOUNT ---${C_NC}"
                        read -p "Enter Username to Delete: " del_user
                        if id "$del_user" >/dev/null 2>&1; then
                            userdel -r "$del_user" >/dev/null 2>&1
                            echo -e "${C_GRN}User '$del_user' deleted successfully!${C_NC}"
                        else
                            echo -e "${C_RED}Error: User not found!${C_NC}"
                        fi
                        read -p "Press Enter to continue..."
                        ;;
                    3)
                        clear
                        echo -e "${C_YLW}--- ACTIVE SSH USERS ---${C_NC}"
                        echo -e "${C_CYN}Username\t\tExpires Date${C_NC}"
                        echo -e "----------------------------------------"
                        awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | while read u; do
                            exp=$(chage -l "$u" | grep "Account expires" | cut -d: -f2)
                            echo -e "${C_GRN}$u\t\t${C_WHT}$exp${C_NC}"
                        done
                        echo -e "----------------------------------------"
                        read -p "Press Enter to continue..."
                        ;;
                    0)
                        break
                        ;;
                esac
            done
            ;;
        4)
            clear
            echo -e "${C_GRN}V2Ray Manager Menu (Coming soon)${C_NC}"
            read -p "Press Enter to continue..."
            ;;
        5)
            clear
            echo -e "${C_YLW}Updating script from GitHub...${C_NC}"
            wget --no-cache -O setup.sh https://raw.githubusercontent.com/hassankako/vps-malak/main/setup.sh >/dev/null 2>&1
            chmod +x setup.sh
            echo -e "${C_GRN}Script updated successfully! Restarting...${C_NC}"
            sleep 2
            exec ./setup.sh
            ;;
        0)
            clear
            exit 0
            ;;
    esac
done
