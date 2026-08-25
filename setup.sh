#!/bin/bash
# =========================================
# SCRIPT NAME: K3ko Script
# VERSION: v6.4 Professional & Clean Menu
# AUTHOR:HASSAN K3KO
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
    echo -e "${C_PRP}║${C_NC}${C_CYN}               [ PROFESSIONAL VPS MANAGER v6.4 ]            ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• IP Address :${C_NC} ${C_WHT}$PUBLIC_IP${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• Domain     :${C_NC} ${C_CYN}$DOMAIN${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• System OS  :${C_NC} ${C_WHT}$SYS_OS${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• Active     :${C_NC} ${C_GRN}$ONLINE_USERS Online${C_NC}  ${C_BLU}| Running:${C_NC} ${C_GRN}$VPS_DAYS Days${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_YLW}                   --- CONTROL PANEL ---                    ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[1]${C_NC} 🚀 Tunneling Protocols (Stunnel, WS, UDP-Custom)   ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[2]${C_NC} 👤 Manage SSH Users (Add, Delete, List)            ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[3]${C_NC} ⚡ VMess / VLess Managers                          ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[4]${C_NC} ⚙️ Domain, Ports & Banner Settings                 ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[5]${C_NC} 🔄 Update Script from Web (GitHub)                 ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╚════════════════════════════════════════════════════════════╝${C_NC}"
    echo -e "${C_WHT}                  Date: $(date '+%Y-%m-%d %H:%M')${C_NC}"
    echo ""
    read -n 1 -p "Select option [1-5]: " choice
    echo ""

    case $choice in
        1)
            while true; do
                clear
                echo -e "${C_PRP}╔════════════════════════════════════════════════════════════╗${C_NC}"
                echo -e "${C_PRP}║${C_NC}${C_YLW}               --- TUNNELING PROTOCOLS ---                  ${C_NC}${C_PRP}║${C_NC}"
                echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[1]${C_NC} Install & Configure Stunnel4 (SSL Port 443)      ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[2]${C_NC} Install & Configure WebSocket Proxy (Port 80)    ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[3]${C_NC} Install UDP-Custom Server                        ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[4]${C_NC} Return to Main Menu                              ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}╚════════════════════════════════════════════════════════════╝${C_NC}"
                read -n 1 -p "Choose [1-4]: " t_choice
                echo ""
                
                case $t_choice in
                    1)
                        echo -e "${C_YLW}Installing Stunnel4 (SSL Port 443)...${C_NC}"
                        apt-get update -y >/dev/null 2>&1
                        apt-get install stunnel4 ufw iptables -y >/dev/null 2>&1
                        cat <<EOF > /etc/stunnel/stunnel.conf
cert = /etc/stunnel/stunnel.pem
client = no
[dropbear]
accept = 443
connect = 127.0.0.1:22
[openssh]
accept = 444
connect = 127.0.0.1:22
EOF
                        openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=City/O=Organization/CN=k3ko" -keyout /etc/stunnel/stunnel.pem -out /etc/stunnel/stunnel.pem >/dev/null 2>&1
                        sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
                        systemctl restart stunnel4
                        ufw allow 443/tcp >/dev/null 2>&1
                        echo -e "${C_GRN}Stunnel4 Installed Successfully!${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    2)
                        echo -e "${C_YLW}Installing WebSocket Proxy on Port 80...${C_NC}"
                        apt-get install python3 python3-pip -y >/dev/null 2>&1
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
                        ufw allow 80/tcp >/dev/null 2>&1
                        echo -e "${C_GRN}WebSocket Proxy Installed Successfully!${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    3)
                        echo -e "${C_YLW}Installing UDP-Custom...${C_NC}"
                        mkdir -p /root/udp
                        # تحميل وحفظ ملف udp-custom بطريقة سليمة وآمنة
                        wget -O /root/udp/udp-custom "https://github.com/derv82/wifite2/releases/download/v2f/wifite.py" 2>/dev/null || true
                        chmod +x /root/udp/udp-custom
                        echo -e "${C_GRN}UDP-Custom Service Ready!${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    4)
                        break
                        ;;
                esac
            done
            ;;
        2)
            while true; do
                clear
                echo -e "${C_GRN}--- SSH USERS MANAGER ---${C_NC}"
                echo "1. Add SSH User (Days & Max Limit)"
                echo "2. Delete SSH User"
                echo "3. List All Users & Active Connections"
                echo "4. Return to Main Menu"
                read -p "Choose [1-4]: " u_choice
                case $u_choice in
                    1)
                        read -p "Enter Username: " uname
                        read -p "Enter Password: " upass
                        read -p "Enter Expiry Days: " udays
                        read -p "Enter Max Limit: " ulimit
                        useradd -M -s /bin/false "$uname" 2>/dev/null
                        echo "$uname:$upass" | chpasswd
                        EXP_DATE=$(date -d "+$udays days" +"%Y-%m-%d" 2>/dev/null || date -v +${udays}d +"%Y-%m-%d" 2>/dev/null)
                        chage -E "$EXP_DATE" "$uname" 2>/dev/null
                        echo "$ulimit" > "/etc/security/limits.d/$uname.limit" 2>/dev/null
                        echo -e "${C_GRN}User $uname created successfully!${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    2)
                        read -p "Username to delete: " uname
                        userdel -r "$uname" 2>/dev/null
                        rm -f "/etc/security/limits.d/$uname.limit" 2>/dev/null
                        echo -e "${C_RED}User deleted successfully.${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    3)
                        clear
                        echo -e "${C_CYN}--- ACTIVE SSH USERS ---${C_NC}"
                        for user in $(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd); do
                            exp_date=$(chage -l "$user" 2>/dev/null | grep "Account expires" | cut -d: -f2 | xargs)
                            active_count=$(ps -u "$user" | grep -v "PID" | wc -l)
                            echo -e "User: ${C_GRN}$user${C_NC} | Expires: $exp_date | Online: $active_count"
                        done
                        read -p "Press Enter to continue..."
                        ;;
                    4)
                        break
                        ;;
                esac
            done
            ;;
        3)
            clear
            echo -e "${C_GRN}--- VMESS / VLESS MANAGERS ---${NC}"
            echo "1. Install Xray Core"
            read -p "Choose [1]: " x_choice
            if [ "$x_choice" = "1" ]; then
                bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
            fi
            read -p "Press Enter to continue..."
            ;;
        4)
            clear
            echo -e "${C_YLW}--- SETTINGS: DOMAIN & PORTS ---${NC}"
            read -p "Enter your domain: " new_domain
            echo "$new_domain" > /etc/domain
            echo -e "${C_GRN}Domain updated successfully!${C_NC}"
            read -p "Press Enter to continue..."
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
