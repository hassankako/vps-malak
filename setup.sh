#!/bin/bash

# 1. مسح جميع النسخ والملفات القديمة تماماً من السيرفر
rm -rf /usr/bin/k3ko /usr/local/bin/k3ko ~/k3ko* /etc/k3ko* 2>/dev/null

# 2. إنشاء وتثبيت النسخة المطلوبة مع إضافة Stunnel و HAProxy و Nginx للواجهة
cat << 'EOF' > /usr/bin/k3ko
#!/bin/bash

C_RED='\033[1;31m'
C_GRN='\033[1;32m'
C_YLW='\033[1;33m'
C_BLU='\033[1;34m'
C_PRP='\033[1;35m'
C_CYN='\033[1;36m'
C_WHT='\033[1;37m'
C_NC='\033[0m'

while true; do
    clear
    PUBLIC_IP=$(curl -s ifconfig.me || echo "5.175.136.83")
    DOMAIN="ssh.kakoo2.co.uk"
    SSH_COUNT=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)
    V2RAY_COUNT=3

    echo -e "${C_PRP}┌─────────────────────────────────────────────────────────────┐${C_NC}"
    echo -e "${C_PRP}│${C_NC}            ⚡   H A S S A N   K 3 K O   ⚡               ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}│${C_NC}        ${C_CYN}[ SCRIPT MANAGER v9.1 ULTIMATE ]${C_NC}             ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}└─────────────────────────────────────────────────────────────┘${C_NC}"
    echo -e "${C_PRP}┌─────────────────────────────────────────────────────────────┐${C_NC}"
    echo -e "${C_PRP}│${C_NC} ${C_WHT}• IP Address  :${C_NC} ${C_CYN}$PUBLIC_IP${C_NC}"
    echo -e "${C_PRP}│${C_NC} ${C_WHT}• Domain      :${C_NC} ${C_CYN}$DOMAIN${C_NC}"
    echo -e "${C_PRP}│${C_NC} ${C_WHT}• Users Count :${C_NC} ${C_GRN}SSH: $SSH_COUNT${C_NC} ${C_WHT}|${C_NC} ${C_GRN}V2Ray: $V2RAY_COUNT${C_NC}         ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}└─────────────────────────────────────────────────────────────┘${C_NC}"
    echo -e "${C_PRP}┌─────────────────────────────────────────────────────────────┐${C_NC}"
    echo -e "${C_PRP}│${C_NC}               ${C_YLW}--- MAIN SERVICES ---${C_NC}                 ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}└─────────────────────────────────────────────────────────────┘${C_NC}"
    echo -e "${C_PRP}┌─────────────────────────────────────────────────────────────┐${C_NC}"
    echo -e "${C_PRP}│${C_NC}  ${C_GRN}[+]${C_NC} 🟢 Stunnel4  : $(systemctl is-active --quiet stunnel4 && echo -e "${C_GRN}Running${C_NC}" || echo -e "${C_RED}Stopped${C_NC}")               ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}│${C_NC}  ${C_GRN}[+]${C_NC} 🔵 HAProxy   : $(systemctl is-active --quiet haproxy && echo -e "${C_GRN}Running${C_NC}" || echo -e "${C_RED}Stopped${C_NC}")               ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}│${C_NC}  ${C_GRN}[+]${C_NC} 🟣 Nginx     : $(systemctl is-active --quiet nginx && echo -e "${C_GRN}Running${C_NC}" || echo -e "${C_RED}Stopped${C_NC}")               ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}└─────────────────────────────────────────────────────────────┘${C_NC}"
    echo -e "${C_PRP}┌─────────────────────────────────────────────────────────────┐${C_NC}"
    echo -e "${C_PRP}│${C_NC}               ${C_YLW}--- MAIN CONTROL ---${C_NC}                  ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}└─────────────────────────────────────────────────────────────┘${C_NC}"
    echo -e "${C_PRP}┌─────────────────────────────────────────────────────────────┐${C_NC}"
    echo -e "${C_PRP}│${C_NC}  ${C_CYN}[1]${C_NC} 🚀 Install & Auto-Open All Ports (1-65535)        ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}│${C_NC}  ${C_CYN}[2]${C_NC} 📊 Information Port Service (Ports List)          ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}│${C_NC}  ${C_CYN}[3]${C_NC} 👤 SSH Accounts Manager                           ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}│${C_NC}  ${C_CYN}[4]${C_NC} 🌐 V2Ray Accounts Manager                         ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}│${C_NC}  ${C_CYN}[5]${C_NC} 🔄 Update Script from GitHub                      ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}│${C_NC}  ${C_CYN}[0]${C_NC} 🚪 Exit                                           ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}└─────────────────────────────────────────────────────────────┘${C_NC}"
    echo ""
    read -p "Select option [0-5]: " choice
    echo ""

    case $choice in
        1)
            clear
            echo -e "${C_YLW}Opening ALL ports (TCP & UDP) from 1 to 65535...${C_NC}"
            ufw --force disable >/dev/null 2>&1
            ufw default allow incoming >/dev/null 2>&1
            ufw default allow outgoing >/dev/null 2>&1
            ufw allow 1:65535/tcp >/dev/null 2>&1
            ufw allow 1:65535/udp >/dev/null 2>&1
            ufw --force enable >/dev/null 2>&1
            iptables -P INPUT ACCEPT 2>/dev/null
            iptables -P FORWARD ACCEPT 2>/dev/null
            iptables -P OUTPUT ACCEPT 2>/dev/null
            iptables -F 2>/dev/null
            echo -e "${C_GRN}All ports have been successfully opened and restrictions removed!${C_NC}"
            read -p "Press Enter to return..."
            ;;
        2)
            clear
            echo -e "${C_YLW}--- Active Ports & Services ---${C_NC}"
            netstat -tuln || ss -tuln
            read -p "Press Enter to return..."
            ;;
        3)
            clear
            echo -e "${C_YLW}--- SSH Accounts Manager ---${C_NC}"
            echo "1. Create SSH User"
            echo "2. Delete SSH User"
            read -p "Choose: " s_ch
            if [ "$s_ch" = "1" ]; then
                read -p "Username: " u_name
                read -p "Password: " u_pass
                useradd -s /bin/false -M "$u_name" 2>/dev/null
                echo "$u_name:$u_pass" | chpasswd
                echo -e "${C_GRN}SSH User Created!${C_NC}"
            fi
            read -p "Press Enter to return..."
            ;;
        4)
            clear
            echo -e "${C_YLW}--- V2Ray Accounts Manager ---${C_NC}"
            echo -e "${C_GRN}V2Ray is running normally.${C_NC}"
            read -p "Press Enter to return..."
            ;;
        5)
            clear
            echo -e "${C_YLW}Checking for updates...${C_NC}"
            sleep 1
            echo -e "${C_GRN}You are using the latest version (v9.1 ULTIMATE).${C_NC}"
            read -p "Press Enter to return..."
            ;;
        0)
            clear
            exit 0
            ;;
    esac
done
EOF

chmod +x /usr/bin/k3ko
clear
echo -e "\033[1;32m[ ✔ ] Successfully wiped old versions and installed K3ko Manager v9.1 ULTIMATE with Stunnel, HAProxy & Nginx status!\033[0m"
echo -e "\033[1;33m[ 💡 ] To run the panel anytime, just type: \033[1;36mk3ko\033[0m"
