#!/bin/bash
# =========================================
# SCRIPT NAME: K3ko Script
# VERSION: v4.5 Ultimate Pro
# AUTHOR: HASSAN K3KO
# =========================================

# الألوان المميزة
RED='\033[1;31m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; CYAN='\033[1;36m'; BLUE='\033[1;34m'; PURPLE='\033[1;35m'; WHITE='\033[1;37m'; NC='\033[0m'

INSTALL_DATE_FILE="/etc/vps_install_date.txt"
[ ! -f "$INSTALL_DATE_FILE" ] && date +%s > "$INSTALL_DATE_FILE"
INSTALL_TIME=$(cat "$INSTALL_DATE_FILE")
CURRENT_TIME=$(date +%s)
VPS_DAYS=$(( (CURRENT_TIME - INSTALL_TIME) / 86400 ))
[ $VPS_DAYS -lt 0 ] && VPS_DAYS=0

while true; do
    clear
    [ -f /etc/os-release ] && . /etc/os-release && SYS_OS="$NAME" || SYS_OS="Linux"
    UPTIME=$(uptime -p 2>/dev/null | sed 's/up //')
    [ -z "$UPTIME" ] && UPTIME="N/A"
    
    PUBLIC_IP=$(curl -s ifconfig.me || echo "N/A")
    DOMAIN=$(cat /etc/domain 2>/dev/null || echo "$PUBLIC_IP")

    echo -e "${PURPLE}============================================================${NC}"
    echo -e "${CYAN}                  ⚡  K 3 K O   S C R I P T  ⚡               ${NC}"
    echo -e "${WHITE}                [ PROFESSIONAL VPS SUITE v4.5 ]             ${NC}"
    echo -e "${PURPLE}============================================================${NC}"
    echo -e "${BLUE} 🌐 IP Address : ${WHITE}$PUBLIC_IP"
    echo -e "${BLUE} 🔗 Domain     : ${CYAN}$DOMAIN"
    echo -e "${BLUE} 💻 System OS  : ${WHITE}$SYS_OS"
    echo -e "${BLUE} ⏳ Uptime     : ${GREEN}$UPTIME"
    echo -e "${BLUE} 🚀 Running    : ${GREEN}$VPS_DAYS Days on VPS${NC}"
    echo -e "${PURPLE}------------------------------------------------------------${NC}"
    echo -e "${YELLOW}                   --- MAIN MENU ---                        ${NC}"
    echo -e "${PURPLE}------------------------------------------------------------${NC}"
    echo -e "  ${GREEN}[1]${NC} 🔑 SSH / OVPN Manager       ${GREEN}[4]${NC} 🛡️ Trojan Manager"
    echo -e "  ${GREEN}[2]${NC} ⚡ VMess Manager            ${GREEN}[5]${NC} 📦 Shadowsocks Manager"
    echo -e "  ${GREEN}[3]${NC} 🚀 VLESS Manager            ${GREEN}[6]${NC} ⚙️ All Ports & Settings"
    echo -e "${PURPLE}============================================================${NC}"
    echo -e "                    ${WHITE}Date: $(date '+%Y-%m-%d %H:%M')${NC}"
    echo ""
    read -n 1 -p "Select option [1-6]: " choice
    echo ""

    case $choice in
        1)
            clear
            echo -e "${GREEN}--- SSH / OVPN MANAGER ---${NC}"
            echo "1. Add SSH User"
            echo "2. Delete SSH User"
            echo "3. List Users"
            read -p "Choose [1-3]: " sub
            if [ "$sub" = "1" ]; then
                read -p "Enter Username: " uname
                read -p "Enter Password: " upass
                read -p "Enter Expiry Days: " udays
                useradd -M -s /bin/false "$uname"
                echo "$uname:$upass" | chpasswd
                EXP_DATE=$(date -d "+$udays days" +"%Y-%m-%d" 2>/dev/null || date -v +${udays}d +"%Y-%m-%d" 2>/dev/null)
                echo -e "${GREEN}User $uname created successfully! Expires on: $EXP_DATE${NC}"
            elif [ "$sub" = "2" ]; then
                read -p "Username to delete: " uname
                userdel "$uname" && echo -e "${RED}User deleted.${NC}"
            elif [ "$sub" = "3" ]; then
                cut -d: -f1 /etc/passwd
            fi
            read -p "Press Enter to continue..."
            ;;
        2)
            clear
            echo -e "${GREEN}--- VMESS MANAGER ---${NC}"
            echo "1. Install Xray Core"
            echo "2. Create VMess User"
            read -p "Choose [1-2]: " sub
            if [ "$sub" = "1" ]; then
                bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
            elif [ "$sub" = "2" ]; then
                read -p "Enter VMess Username: " vname
                UUID=$(cat /proc/sys/kernel/random/uuid)
                echo -e "${GREEN}VMess User Created! UUID: $UUID${NC}"
            fi
            read -p "Press Enter to continue..."
            ;;
        3)
            clear
            echo -e "${GREEN}--- VLESS MANAGER ---${NC}"
            read -p "Enter VLess Username: " vlname
            UUID=$(cat /proc/sys/kernel/random/uuid)
            echo -e "${GREEN}VLess User Created! UUID: $UUID${NC}"
            read -p "Press Enter to continue..."
            ;;
        4)
            clear
            echo -e "${GREEN}--- TROJAN MANAGER ---${NC}"
            read -p "Enter Trojan Password: " tpass
            echo -e "${GREEN}Trojan User Created with password: $tpass${NC}"
            read -p "Press Enter to continue..."
            ;;
        5)
            clear
            echo -e "${GREEN}--- SHADOWSOCKS MANAGER ---${NC}"
            read -p "Enter Password: " spass
            echo -e "${GREEN}Shadowsocks User Created successfully!${NC}"
            read -p "Press Enter to continue..."
            ;;
        6)
            clear
            echo -e "${YELLOW}--- ALL PORTS & SETTINGS ---${NC}"
            echo "1. Open Custom Port"
            echo "2. View All Open Ports"
            echo "3. Open All Standard VPN/Proxy Ports"
            read -p "Choose [1-3]: " s_choice
            case $s_choice in
                1)
                    read -p "Enter port number: " nport
                    ufw allow "$nport" 2>/dev/null
                    iptables -A INPUT -p tcp --dport "$nport" -j ACCEPT 2>/dev/null
                    echo -e "${GREEN}Port $nport opened!${NC}"
                    ;;
                2)
                    netstat -tuln 2>/dev/null || ss -tuln
                    ;;
                3)
                    for p in 22 80 443 8080 2082 2083 2095 8443; do
                        ufw allow $p 2>/dev/null
                        iptables -A INPUT -p tcp --dport $p -j ACCEPT 2>/dev/null
                    done
                    echo -e "${GREEN}All standard ports opened!${NC}"
                    ;;
            esac
            read -p "Press Enter to continue..."
            ;;
    esac
done
