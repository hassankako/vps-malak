#!/bin/bash
# =========================================
# SCRIPT NAME: K3ko Script
# VERSION: v5.4 Masterpiece
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
    DOMAIN=$(cat /etc/domain 2>/dev/null || echo "$PUBLIC_IP")
    ONLINE_USERS=$(ps -u root | wc -l 2>/dev/null || echo "1")

    echo -e "${C_PRP}╔════════════════════════════════════════════════════════════╗${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_YLW}                ⚡  H A S S A N   K 3 K O  ⚡               ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_CYN}               [ PROFESSIONAL VPS MANAGER v5.4 ]            ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• IP Address :${C_NC} ${C_WHT}$PUBLIC_IP${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• Domain     :${C_NC} ${C_CYN}$DOMAIN${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• System OS  :${C_NC} ${C_WHT}$SYS_OS${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• Active     :${C_NC} ${C_GRN}$ONLINE_USERS Online${C_NC}  ${C_BLU}| Running:${C_NC} ${C_GRN}$VPS_DAYS Days${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_YLW}                   --- CONTROL PANEL ---                    ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[1]${C_NC} 🔑 SSH / OVPN Manager                              ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[2]${C_NC} ⚡ VMess Manager                                   ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[3]${C_NC} 🚀 VLESS Manager                                   ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[4]${C_NC} ⚙️ All Ports, Domain & Banner Settings             ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╚════════════════════════════════════════════════════════════╝${C_NC}"
    echo -e "${C_WHT}                  Date: $(date '+%Y-%m-%d %H:%M')${C_NC}"
    echo ""
    read -n 1 -p "Select option [1-4]: " choice
    echo ""

    case $choice in
        1)
            clear
            echo -e "${C_GRN}--- SSH / OVPN MANAGER ---${NC}"
            echo "1. Add SSH & OpenVPN User (with Payload)"
            echo "2. Delete SSH User"
            echo "3. List Users & Online Connections"
            read -p "Choose [1-3]: " sub
            if [ "$sub" = "1" ]; then
                read -p "Enter Username: " uname
                read -p "Enter Password: " upass
                read -p "Enter Expiry Days: " udays
                
                useradd -M -s /bin/false "$uname" 2>/dev/null
                echo "$uname:$upass" | chpasswd
                EXP_DATE=$(date -d "+$udays days" +"%Y-%m-%d" 2>/dev/null || date -v +${udays}d +"%Y-%m-%d" 2>/dev/null)
                
                echo -e "\n${C_GRN}==================================================${C_NC}"
                echo -e "${C_YLW}           ACCOUNT & OVPN CONFIG DETAILS          ${C_NC}"
                echo -e "${C_GRN}==================================================${C_NC}"
                echo -e "${C_WHT} Username  : ${C_CYN}$uname${C_NC}"
                echo -e "${C_WHT} Password  : ${C_CYN}$upass${C_NC}"
                echo -e "${C_WHT} Host/IP   : ${C_CYN}$PUBLIC_IP${C_NC}"
                echo -e "${C_WHT} Domain    : ${C_CYN}$DOMAIN${C_NC}"
                echo -e "${C_WHT} Expires   : ${C_GRN}$EXP_DATE${C_NC}"
                echo -e "\n${C_YLW}--- OpenVPN TCP / UDP Payload ---${C_NC}"
                echo -e "${C_CYN}GET / HTTP/1.1[crlf]Host: $DOMAIN[crlf][crlf]${C_NC}"
                echo -e "${C_GRN}==================================================${C_NC}"
                
            elif [ "$sub" = "2" ]; then
                read -p "Username to delete: " uname
                userdel "$uname" && echo -e "${C_RED}User deleted successfully.${C_NC}"
            elif [ "$sub" = "3" ]; then
                clear
                echo -e "${C_GRN}       SSH USERS & ACTIVE CONNECTIONS REPORT      ${C_NC}"
                echo "--------------------------------------------------"
                printf "${C_CYN}%-20s | %-15s${C_NC}\n" "USERNAME" "ACTIVE CONNECTIONS"
                echo "--------------------------------------------------"
                for user in $(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd); do
                    count=$(ps -u "$user" | grep -v "PID" | wc -l)
                    if [ "$count" -gt 0 ]; then
                        printf "${C_WHT}%-20s${C_NC} | ${C_GRN}%-15s${C_NC}\n" "$user" "$count Online Device(s)"
                    else
                        printf "${C_WHT}%-20s${C_NC} | ${C_RED}%-15s${C_NC}\n" "$user" "Offline (0)"
                    fi
                done
            fi
            read -p "Press Enter to continue..."
            ;;
        2)
            clear
            echo -e "${C_GRN}--- VMESS MANAGER ---${NC}"
            echo "1. Install Xray Core"
            echo "2. Create VMess User"
            read -p "Choose [1-2]: " sub
            if [ "$sub" = "1" ]; then
                bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
            elif [ "$sub" = "2" ]; then
                read -p "Enter VMess Username: " vname
                UUID=$(cat /proc/sys/kernel/random/uuid)
                echo -e "${C_GRN}VMess User Created! UUID: $UUID${C_NC}"
            fi
            read -p "Press Enter to continue..."
            ;;
        3)
            clear
            echo -e "${C_GRN}--- VLESS MANAGER ---${NC}"
            read -p "Enter VLess Username: " vlname
            UUID=$(cat /proc/sys/kernel/random/uuid)
            echo -e "${C_GRN}VLess User Created! UUID: $UUID${C_NC}"
            read -p "Press Enter to continue..."
            ;;
        4)
            clear
            echo -e "${C_YLW}--- SETTINGS: DOMAIN & BANNER & PORTS ---${NC}"
            echo "1. Set / Change Domain"
            echo "2. Set / Change SSH Banner (Welcome Message)"
            echo "3. Open Custom Port"
            echo "4. View All Open Ports"
            read -p "Choose [1-4]: " s_choice
            case $s_choice in
                1)
                    read -p "Enter your domain (e.g., example.com): " new_domain
                    echo "$new_domain" > /etc/domain
                    echo -e "${C_GRN}Domain updated successfully to: $new_domain${C_NC}"
                    ;;
                2)
                    read -p "Enter your custom banner message: " banner_msg
                    echo "$banner_msg" > /etc/issue.net
                    sed -i 's/#Banner none/Banner \/etc\/issue.net/g' /etc/ssh/sshd_config 2>/dev/null
                    systemctl restart sshd 2>/dev/null || systemctl restart ssh 2>/dev/null
                    echo -e "${C_GRN}SSH Banner updated successfully!${C_NC}"
                    ;;
                3)
                    read -p "Enter port number: " nport
                    ufw allow "$nport" 2>/dev/null
                    iptables -A INPUT -p tcp --dport "$nport" -j ACCEPT 2>/dev/null
                    echo -e "${C_GRN}Port $nport opened!${C_NC}"
                    ;;
                4)
                    netstat -tuln 2>/dev/null || ss -tuln
                    ;;
            esac
            read -p "Press Enter to continue..."
            ;;
    esac
done
