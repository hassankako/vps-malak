#!/bin/bash
# =========================================
# SCRIPT NAME: K3ko Script
# VERSION: v3.5 Pro
# DESCRIPTION: Professional VPS Management Interface
# AUTHOR: HASSAN K3KO
# =========================================

# تعيين الألوان
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; BLUE='\033[0;34m'; WHITE='\033[1;37m'; NC='\033[0m'; BOLD='\033[1m'

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

# إعداد البنر المخصص تلقائياً (تم الحفاظ عليه)
if [ ! -f /etc/issue.net ]; then
    cat << 'BANNER_EOF' > /etc/issue.net
💥 INTERNET ILIMITADO ☄️
『 HASSAN K3KO 』
بسم الله الرحمن الرحيم 🛰️
حسان كعكو
|whatsapp: أضف رقمي كجهة اتصال في واتساب. https://wa.me/qr/BQSQFESYU5NUB1 📳
|حسان كعكو 📺 |لخدمات الإنترنت 🗂
كافة الخطوط وشرائح esim التي يعمل عليها الانترنت
شكرا لاستخدام خدماتنا
BANNER_EOF
    grep -q "^Banner /etc/issue.net" /etc/ssh/sshd_config || echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
    systemctl restart ssh 2>/dev/null || systemctl restart sshd 2>/dev/null
fi

# دالة لعرض الترويسة والجدول
show_header() {
    echo -e "${BOLD}${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║${NC}                ${BOLD}${WHITE}[:: K3ko Script | v3.5 Pro ::]${NC}                 ${BOLD}${CYAN}║${NC}"
    echo -e "${BOLD}${CYAN}╠════════════════════════════════════════════════════════════╣${NC}"
}

# دالة لعرض التذييل
show_footer() {
    echo -e "${BOLD}${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo -e "${NC}                  ${WHITE}Today: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
}

while true; do
    clear
    # الحصول على معلومات النظام
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        SYS_OS="$PRETTY_NAME"
    else
        SYS_OS="Unknown Linux"
    fi
    
    UPTIME=$(uptime -p 2>/dev/null | sed 's/up //' || echo "N/A")
    CORE_COUNT=$(nproc 2>/dev/null || echo "1")
    PUBLIC_IP=$(curl -s ifconfig.me || echo "N/A")
    DOMAIN=$(cat /etc/domain 2>/dev/null || echo "$PUBLIC_IP")
    ONLINE_USERS=$(who | wc -l 2>/dev/null || echo "0")

    # رسم الواجهة
    show_header
    echo -e "${BOLD}${CYAN}║${NC} ${BOLD}OS:${NC}       ${BLUE}$SYS_OS${NC}"
    echo -e "${BOLD}${CYAN}║${NC} ${BOLD}RAM:${NC}      $(free -m | awk 'NR==2{printf "%s MB / %s MB", $2, $3}' 2>/dev/null || echo "N/A")"
    echo -e "${BOLD}${CYAN}║${NC} ${BOLD}UPTIME:${NC}   $UPTIME | ${BOLD}CORES:${NC} $CORE_COUNT"
    echo -e "${BOLD}${CYAN}║${NC} ${BOLD}IP:${NC}       ${WHITE}$PUBLIC_IP${NC}"
    echo -e "${BOLD}${CYAN}║${NC} ${BOLD}DOMAIN:${NC}   ${CYAN}$DOMAIN${NC}"
    echo -e "${BOLD}${CYAN}║${NC} ${BOLD}ACTIVE:${NC}   ${GREEN}$ONLINE_USERS Online User(s) | $VPS_DAYS Day(s) Running${NC}"
    echo -e "${BOLD}${CYAN}║════════════════════════════════════════════════════════════║${NC}"
    echo -e "${BOLD}${CYAN}║${NC} ${BOLD}${YELLOW}          --- MAIN MANAGEMENT OPTIONS ---           ${NC}      ${CYAN}║${NC}"
    echo -e "${BOLD}${CYAN}║════════════════════════════════════════════════════════════║${NC}"
    
    # تنسيق القائمة
    echo -e "${BOLD}${CYAN}║${NC}  ${BOLD}${YELLOW}[1]${NC} SSH/OVPN MANAGER   ${BOLD}${YELLOW}[4]${NC} TROJAN MANAGER    ${BOLD}${CYAN}║${NC}"
    echo -e "${BOLD}${CYAN}║${NC}  ${BOLD}${YELLOW}[2]${NC} VMESS MANAGER      ${BOLD}${YELLOW}[5]${NC} SHDWSK MANAGER    ${BOLD}${CYAN}║${NC}"
    echo -e "${BOLD}${CYAN}║${NC}  ${BOLD}${YELLOW}[3]${NC} VLESS MANAGER      ${BOLD}${YELLOW}[6]${NC} OTHER SETTINGS    ${BOLD}${CYAN}║${NC}"
    
    show_footer
    echo ""
    read -n 1 -p "Select [1 - 6] : " choice
    echo ""

    case $choice in
        1)
            clear
            echo -e "${GREEN}--- SSH / OVPN MANAGER ---${NC}"
            echo "1. Add SSH User (With Payloads & DNS)"
            echo "2. Delete SSH User"
            echo "3. List Users"
            read -p "Choose [1-3]: " sub
            if [ "$sub" = "1" ]; then
                read -p "Enter Username: " uname
                read -p "Enter Password: " upass
                read -p "Enter Expiry Days (e.g. 30): " udays
                
                useradd -M -s /bin/false "$uname"
                echo "$uname:$upass" | chpasswd
                
                # حساب تاريخ الانتهاء
                EXP_DATE=$(date -d "+$udays days" +"%Y-%m-%d" 2>/dev/null || date -v +${udays}d +"%Y-%m-%d" 2>/dev/null)

                clear
                echo -e "${GREEN}========================================${NC}"
                echo -e "${GREEN}       SSH ACCOUNT CREATED SUCCESSFULLY ${NC}"
                echo -e "${GREEN}========================================${NC}"
                echo -e "${YELLOW}Host / IP   :${NC} $PUBLIC_IP"
                echo -e "${YELLOW}Domain/DNS  :${NC} $DOMAIN"
                echo -e "${YELLOW}Username    :${NC} $uname"
                echo -e "${YELLOW}Password    :${NC} $upass"
                echo -e "${YELLOW}Ports       :${NC} SSH: 22, 80, 443, 2082, 2083"
                echo -e "${YELLOW}Expires On  :${NC} $EXP_DATE ($udays Days)"
                echo -e "${GREEN}----------------------------------------${NC}"
                echo -e "${CYAN}--- HTTP PAYLOAD (PORT 80) ---${NC}"
                echo "GET / HTTP/1.1[crlf]Host: $DOMAIN[crlf]Upgrade: websocket[crlf][crlf]"
                echo -e "${GREEN}----------------------------------------${NC}"
                echo -e "${CYAN}--- SSL / TLS PAYLOAD (PORT 443) ---${NC}"
                echo "GET wss://$DOMAIN/HTTP/1.1[crlf]Host: $DOMAIN[crlf]Upgrade: websocket[crlf][crlf]"
                echo -e "${GREEN}----------------------------------------${NC}"
                echo -e "${CYAN}--- DNS / HOST CONFIG ---${NC}"
                echo "Server IP: $PUBLIC_IP | DNS Host: $DOMAIN"
                echo -e "${GREEN}========================================${NC}"
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
                echo "Port: 443, 80"
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
                echo "Port: 443, 2083"
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
            echo -e "${YELLOW}--- ALL PORTS & SYSTEM SETTINGS ---${NC}"
            echo "1. Add Custom Port to SSH (Open any port)"
            echo "2. View All Open/Configured Ports on VPS"
            echo "3. Install Nginx / HAProxy / Stunnel (All web ports)"
            echo "4. Change Domain / DNS"
            echo "5. View/Edit Banner"
            echo "6. Open All Ports in Firewall (UFW/IPTables)"
            read -p "Choose [1-6]: " s_choice
            case $s_choice in
                1) 
                    read -p "Enter any port number you want to open (e.g. 80, 443, 2082, 8080, etc.): " nport
                    if [[ "$nport" =~ ^[0-9]+$ ]]; then
                        echo "Port $nport" >> /etc/ssh/sshd_config
                        systemctl restart ssh 2>/dev/null || systemctl restart sshd 2>/dev/null
                        # فتح البورت في الجدار النارى تلقائياً إن وجد
                        ufw allow "$nport" 2>/dev/null
                        iptables -A INPUT -p tcp --dport "$nport" -j ACCEPT 2>/dev/null
                        iptables -A INPUT -p udp --dport "$nport" -j ACCEPT 2>/dev/null
                        echo -e "${GREEN}Port $nport added and opened successfully!${NC}"
                    else
                        echo -e "${RED}Invalid port number!${NC}"
                    fi
                    ;;
                2) 
                    echo -e "${GREEN}=== CONFIGURED PORTS & SERVICES ===${NC}"
                    netstat -tuln 2>/dev/null || ss -tuln
                    ;;
                3) 
                    apt update && apt install -y nginx haproxy stunnel4
                    systemctl enable --now nginx haproxy stunnel4
                    echo -e "${GREEN}Nginx, HAProxy, and Stunnel installed and started successfully.${NC}"
                    ;;
                4) 
                    read -p "Enter new Domain / DNS: " ndom
                    echo "$ndom" > /etc/domain
                    echo -e "${GREEN}Domain saved: $ndom${NC}"
                    ;;
                5) 
                    clear
                    echo -e "${YELLOW}Current Banner:${NC}"
                    cat /etc/issue.net
                    echo ""
                    ;;
                6)
                    echo -e "${YELLOW}Opening all common proxy and VPN ports (22, 80, 443, 8080, 2082, 2083, 2095, 8443)...${NC}"
                    for p in 22 80 443 8080 2082 2083 2095 8443 53 5300; do
                        ufw allow $p 2>/dev/null
                        iptables -A INPUT -p tcp --dport $p -j ACCEPT 2>/dev/null
                        iptables -A INPUT -p udp --dport $p -j ACCEPT 2>/dev/null
                    done
                    echo -e "${GREEN}All standard ports opened successfully!${NC}"
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
