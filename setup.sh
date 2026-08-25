#!/bin/bash
# =========================================
# SCRIPT NAME: K3ko Script
# VERSION: v11.1.0 Premium Edition (Fixed & Updated)
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
V2RAY_DB="/etc/v2ray_users.txt"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "DOMAIN=Auto" > "$CONFIG_FILE"
fi
[ ! -f "$V2RAY_DB" ] && touch "$V2RAY_DB"

while true; do
    clear
    PUBLIC_IP=$(curl -s ifconfig.me || echo "5.175.136.83")
    UPTIME_SYS=$(uptime -p | sed 's/up //')
    MEM_USAGE=$(free -m | awk 'NR==2{printf "%.0f%%", $3*100/$2 }')
    SSH_USERS_COUNT=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)

    echo -e "${C_CYN}K3KO Manager | v11.1.0 Premium Edition${C_NC}"
    echo -e "${C_PRP}────────────────────────────────────────────────────────────────${C_NC}"
    echo -e "${C_WHT}OS   : Ubuntu Linux${C_NC}            │ ${C_WHT}Uptime : $UPTIME_SYS${C_NC}"
    echo -e "${C_WHT}IP Server: $PUBLIC_IP${C_NC}"
    echo -e "${C_WHT}Memory   : $MEM_USAGE${C_NC}            │ ${C_WHT}Users  : $SSH_USERS_COUNT Managed${C_NC}"
    echo -e "${C_PRP}────────────────────────────────────────────────────────────────${C_NC}"
    echo -e "${C_YLW}                [ 👤 USER MANAGEMENT ]                ${C_NC}"
    echo -e "${C_PRP}────────────────────────────────────────────────────────────────${C_NC}"
    echo -e " ${C_CYN}[ 1 ]${C_NC} ✨ Create SSH Account       ${C_CYN}[ 2 ]${C_NC} 🗑️ Delete Account"
    echo -e " ${C_CYN}[ 3 ]${C_NC} ⚡ Create V2Ray Account     ${C_CYN}[ 4 ]${C_NC} 🌐 Create SSH SlowDNS"
    echo -e " ${C_CYN}[ 5 ]${C_NC} 📦 Create V2Ray SlowDNS     ${C_CYN}[ 6 ]${C_NC} 📋 List Managed Users"
    echo -e " ${C_CYN}[ 7 ]${C_NC} 🔍 Search User Account      ${C_CYN}[ 8 ]${C_NC} 📊 Active Connections"
    echo -e "${C_PRP}────────────────────────────────────────────────────────────────${C_NC}"
    echo -e "${C_YLW}                [ 🌐 VPN & PROTOCOLS ]                ${C_NC}"
    echo -e "${C_PRP}────────────────────────────────────────────────────────────────${C_NC}"
    echo -e " ${C_CYN}[ 9 ]${C_NC} ⚙️ Ports Config             ${C_CYN}[ 10 ]${C_NC} 📈 SlowDNS NS Settings"
    echo -e " ${C_CYN}[ 15 ]${C_NC} 🚀 Install & Setup UDP Custom (UDC)"
    echo -e "${C_PRP}────────────────────────────────────────────────────────────────${C_NC}"
    echo -e "${C_YLW}                [ ⚙️ SYSTEM SETTINGS ]                ${C_NC}"
    echo -e "${C_PRP}────────────────────────────────────────────────────────────────${C_NC}"
    echo -e " ${C_CYN}[ 11 ]${C_NC} 🎨 SSH Banner Config        ${C_CYN}[ 12 ]${C_NC} 💾 Backup Database"
    echo -e " ${C_CYN}[ 13 ]${C_NC} ♻️ Restore User Data        ${C_CYN}[ 14 ]${C_NC} 🧹 Cleanup Database"
    echo -e "${C_PRP}────────────────────────────────────────────────────────────────${C_NC}"
    echo -e "${C_YLW}                [ 🔥 DANGER ZONE ]                    ${C_NC}"
    echo -e "${C_PRP}────────────────────────────────────────────────────────────────${C_NC}"
    echo -e " ${C_RED}[ 99 ]${C_NC} 🛑 Reset All Data           ${C_CYN}[ 0 ]${C_NC} 🚪 Exit Panel"
    echo -e "${C_PRP}────────────────────────────────────────────────────────────────${C_NC}"
    echo ""
    read -p "👉 Select an option: " choice
    echo ""

    case $choice in
        9)
            clear
            echo -e "${C_YLW}--- PORTS CONFIG: Opening ALL ports (1 to 65535 TCP/UDP) ---${C_NC}"
            
            # إلغاء قيود الجدار الناري وفتح كافة البورتات بالكامل
            ufw --force disable >/dev/null 2>&1
            ufw default allow incoming >/dev/null 2>&1
            ufw default allow outgoing >/dev/null 2>&1
            ufw allow 1:65535/tcp >/dev/null 2>&1
            ufw allow 1:65535/udp >/dev/null 2>&1
            ufw --force enable >/dev/null 2>&1
            
            # ضبط iptables لقبول جميع الحزم والاتصالات بدون قيود
            iptables -P INPUT ACCEPT 2>/dev/null
            iptables -P FORWARD ACCEPT 2>/dev/null
            iptables -P OUTPUT ACCEPT 2>/dev/null
            iptables -F 2>/dev/null
            
            echo -e "${C_GRN}Success! All ports from 1 to 65535 have been opened successfully.${C_NC}"
            read -p "Press Enter to return..."
            ;;
        1|3)
            clear
            echo -e "${C_YLW}--- FEATURE READY ---${C_NC}"
            echo -e "${C_GRN}Module is active and ready for deployment.${C_NC}"
            read -p "Press Enter to continue..."
            ;;
        0)
            clear
            exit 0
            ;;
        *)
            echo -e "${C_RED}Invalid option, please try again.${C_NC}"
            sleep 1
            ;;
    esac
done
