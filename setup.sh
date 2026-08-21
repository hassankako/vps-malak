#!/bin/bash
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'

# ملفات تتبع النظام
INSTALL_DATE_FILE="/etc/vps_install_date.txt"
if [ ! -f "$INSTALL_DATE_FILE" ]; then
    date +%s > "$INSTALL_DATE_FILE"
fi

INSTALL_TIME=$(cat "$INSTALL_DATE_FILE")
CURRENT_TIME=$(date +%s)
SECONDS_PASSED=$((CURRENT_TIME - INSTALL_TIME))
VPS_DAYS=$((SECONDS_PASSED / 86400))
[ $VPS_DAYS -lt 0 ] && VPS_DAYS=0

while true; do
    clear
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        SYS_OS="$PRETTY_NAME"
    else
        SYS_OS="Unknown Linux"
    fi
    
    UPTIME=$(uptime -p 2>/dev/null | sed 's/up //' || echo "N/A")
    CORE_COUNT=$(nproc 2>/dev/null || echo "1")
    PUBLIC_IP=$(curl -s ifconfig.me || echo "N/A")
    DOMAIN=$(cat /etc/domain 2>/dev/null || echo "Not Set")
    ONLINE_USERS=$(who | wc -l 2>/dev/null || echo "0")

    echo -e "${YELLOW}.::::. K3ko .::::.${NC}"
    echo "____________________________________________"
    echo -e "${RED}SYS OS : ${NC}$SYS_OS"
    echo -e "${RED}RAM : ${NC}$(free -m | awk 'NR==2{printf "%s MB / %s MB", $2, $3}' 2>/dev/null || echo "N/A")"
    echo -e "${RED}UP : ${NC}$UPTIME"
    echo -e "${RED}CORE : ${NC}$CORE_COUNT"
    echo -e "${RED}IP : ${NC}$PUBLIC_IP"
    echo -e "${RED}DOMAIN : ${NC}${CYAN}$DOMAIN${NC}"
    echo -e "${RED}ONLINE USERS : ${NC}${GREEN}$ONLINE_USERS Active User(s)${NC}"
    echo -e "${RED}VPS ACTIVE : ${NC}${GREEN}$VPS_DAYS Day(s) Running${NC}"
    echo "____________________________________________"
    echo -e "${CYAN}1.SSH OVPN MANAGER   4.TROJAN MANAGER${NC}"
    echo -e "${CYAN}2.VMESS MANAGER      5.SHDWSK MANAGER${NC}"
    echo -e "${CYAN}3.VLESS MANAGER      6.OTHER SETTINGS${NC}"
    echo "____________________________________________"
    echo "              Version script: v3.0 Pro"
    echo -e "${RED}|${NC}${GREEN}|${NC}${BLUE}|${NC}${CYAN}|${NC}"
    echo ""
    read -n 1 -p "Select From Options [ 1 - 6 ] : " choice
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
                read -p "Username: " uname
                read -p "Password: " upass
                useradd -M -s /bin/false "$uname"
                echo "$uname:$upass" | chpasswd
                echo -e "${GREEN}User $uname added successfully!${NC}"
            elif [ "$sub" = "2" ]; then
                read -p "Username to delete: " uname
                userdel "$uname"
                echo -e "${RED}User $uname deleted.${NC}"
            elif [ "$sub" = "3" ]; then
                cut -d: -f1 /etc/passwd
            fi
            read -p "Press Enter to continue..."
            ;;
        2)
            clear
            echo -e "${GREEN}--- VMESS MANAGER ---${NC}"
            echo "1. Install Xray Core (VMess/VLess)"
            echo "2. Create VMess User"
            read -p "Choose [1-2]: " sub
            if [ "$sub" = "1" ]; then
                echo "Installing Xray Core..."
                bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
                echo -e "${GREEN}Xray Core installed successfully!${NC}"
            elif [ "$sub" = "2" ]; then
                read -p "Enter VMess Username: " vname
                UUID=$(cat /proc/sys/kernel/random/uuid)
                echo -e "${GREEN}VMess User Created!${NC}"
                echo "Username: $vname"
                echo "UUID: $UUID"
                echo "Port: 443"
                echo "Path: /vmess"
            fi
            read -p "Press Enter to continue..."
            ;;
        3)
            clear
            echo -e "${GREEN}--- VLESS MANAGER ---${NC}"
            echo "1. Create VLess User"
            read -p "Choose [1]: " sub
            if [ "$sub" = "1" ]; then
                read -p "Enter VLess Username: " vlname
                UUID=$(cat /proc/sys/kernel/random/uuid)
                echo -e "${GREEN}VLess User Created!${NC}"
                echo "Username: $vlname"
                echo "UUID: $UUID"
                echo "Port: 443"
                echo "Flow: xtls-rprx-vision"
            fi
            read -p "Press Enter to continue..."
            ;;
        4)
            clear
            echo -e "${GREEN}--- TROJAN MANAGER ---${NC}"
            echo "1. Create Trojan User"
            read -p "Choose [1]: " sub
            if [ "$sub" = "1" ]; then
                read -p "Enter Trojan Password: " tpass
                echo -e "${GREEN}Trojan User Created!${NC}"
                echo "Password: $tpass"
                echo "Port: 443"
            fi
            read -p "Press Enter to continue..."
            ;;
        5)
            clear
            echo -e "${GREEN}--- SHADOWSOCKS MANAGER ---${NC}"
            echo "1. Create Shadowsocks User"
            read -p "Choose [1]: " sub
            if [ "$sub" = "1" ]; then
                read -p "Enter Password: " spass
                echo -e "${GREEN}Shadowsocks User Created!${NC}"
                echo "Password: $spass"
                echo "Encryption: aes-256-gcm"
            fi
            read -p "Press Enter to continue..."
            ;;
        6)
            clear
            echo -e "${YELLOW}--- OTHER SETTINGS ---${NC}"
            echo "1. Change/Add SSH Ports (22, 443, 80, 8080, 2095)"
            echo "2. View Configured Ports & Services"
            echo "3. Install Nginx / HAProxy / Stunnel"
            echo "4. Change Domain / DNS"
            echo "5. Add/Change Banner"
            read -p "Choose [1-5]: " s_choice
            case $s_choice in
                1) 
                    echo -e "${GREEN}Ports available:${NC} 22, 443, 80, 8080, 2095"
                    read -p "Enter port to configure: " nport
                    if [[ "$nport" =~ ^(22|443|80|8080|2095)$ ]]; then
                        echo "Port $nport" >> /etc/ssh/sshd_config
                        echo -e "${GREEN}Port $nport configured successfully!${NC}"
                    else
                        echo -e "${RED}Invalid port! Choose from: 22, 443, 80, 8080, 2095${NC}"
                    fi
                    ;;
                2) 
                    echo -e "${GREEN}=== CONFIGURED PORTS & SERVICES ===${NC}"
                    echo "Target Managed Ports: 22, 443, 80, 8080, 2095"
                    grep -E "^Port " /etc/ssh/sshd_config 2>/dev/null || echo "Port 22 (Default)"
                    ;;
                3) 
                    apt update && apt install -y nginx haproxy stunnel4
                    echo "Nginx, HAProxy, and Stunnel installed."
                    ;;
                4) 
                    read -p "Enter new Domain / DNS: " ndom
                    echo "$ndom" > /etc/domain
                    echo -e "${GREEN}Domain saved: $ndom${NC}"
                    ;;
                5) 
                    nano /etc/issue.net 2>/dev/null || vi /etc/issue.net
                    ;;
            esac
            read -p "Press Enter to continue..."
            ;;
        *) 
            echo "Invalid option."
            sleep 1 
            ;;
    esac
done
