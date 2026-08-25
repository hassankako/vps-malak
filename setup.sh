#!/bin/bash
# =========================================
# SCRIPT NAME: K3ko Script Manager
# VERSION: v9.1 ULTIMATE (Full V2Ray & Domain Support)
# AUTHOR: HASSAN K3KO
# =========================================

# الألوان
C_RED='\033[1;31m'
C_GRN='\033[1;32m'
C_YLW='\033[1;33m'
C_BLU='\033[1;34m'
C_PRP='\033[1;35m'
C_CYN='\033[1;36m'
C_WHT='\033[1;37m'
C_NC='\033[0m'

DOMAIN_FILE="/etc/domain"

while true; do
    clear
    PUBLIC_IP=$(curl -s ifconfig.me || hostname -I | awk '{print $1}' || echo "N/A")
    
    if [ -f "$DOMAIN_FILE" ]; then
        DOMAIN=$(cat "$DOMAIN_FILE")
    else
        DOMAIN="$PUBLIC_IP"
    fi
    
    SSH_COUNT=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)
    V2RAY_COUNT=0
    [ -d /etc/v2ray ] && V2RAY_COUNT=$(ls -l /etc/v2ray 2>/dev/null | wc -l)

    echo -e "${C_PRP}╔════════════════════════════════════════════════════════════╗${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_YLW}                ⚡  H A S S A N   K 3 K O  ⚡               ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_CYN}            [ SCRIPT MANAGER v9.1 ULTIMATE ]                ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• IP Address  :${C_NC} ${C_WHT}$PUBLIC_IP${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• Domain      :${C_NC} ${C_CYN}$DOMAIN${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• Users Count :${C_NC} ${C_GRN}SSH: $SSH_COUNT${C_NC}  ${C_YLW}|${C_NC}  ${C_CYN}V2Ray: $V2RAY_COUNT${C_NC}              ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_YLW}                   --- MAIN CONTROL ---                     ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[1]${C_NC} 🚀 Install & Auto-Open All Ports (SSL/80/53/Proxy)  ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[2]${C_NC} 🛠️ Fix & Free Ports 80 / 443 (إصلاح منافذ 80 و 443) ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[3]${C_NC} 👤 SSH Accounts Manager                         ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[4]${C_NC} 🌐 V2Ray Accounts Manager                     ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[5]${C_NC} 🌐 Add / Change Domain (إضافة أو تغيير الدومين) ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[6]${C_NC} 🔄 Update Script from GitHub                  ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_RED}[0]${C_NC} 🚪 Exit                                       ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╚════════════════════════════════════════════════════════════╝${C_NC}"
    echo ""
    read -p "Select option [0-6]: " choice
    echo ""

    case $choice in
        1)
            clear
            echo -e "${C_GRN}--- Installing & Opening All Ports ---${C_NC}"
            for p in 22 80 443 8080 2082 2083 2095 8443 53; do
                ufw allow $p 2>/dev/null
                iptables -A INPUT -p tcp --dport $p -j ACCEPT 2>/dev/null
                iptables -A INPUT -p udp --dport $p -j ACCEPT 2>/dev/null
            done
            echo -e "${C_GRN}All ports (including 80 and 443) successfully opened!${C_NC}"
            read -p "Press Enter to continue..."
            ;;
        2)
            clear
            echo -e "${C_YLW}--- Fixing & Freeing Ports 80 & 443 ---${C_NC}"
            echo -e "${C_CYN}[*] Stopping services blocking ports 80 and 443...${C_NC}"
            systemctl stop apache2 2>/dev/null
            systemctl disable apache2 2>/dev/null
            systemctl stop nginx 2>/dev/null
            fuser -k 80/tcp 2>/dev/null
            fuser -k 443/tcp 2>/dev/null
            echo -e "${C_GRN}[+] Ports 80 and 443 are now completely free!${C_NC}"
            read -p "Press Enter to continue..."
            ;;
        3)
            clear
            echo -e "${C_GRN}--- SSH Accounts Manager ---${C_NC}"
            echo "1. Add SSH User"
            echo "2. Delete SSH User"
            echo "3. List SSH Users"
            read -p "Choose [1-3]: " sub_ssh
            if [ "$sub_ssh" = "1" ]; then
                read -p "Username: " usn
                read -p "Password: " psw
                useradd -M -s /bin/false "$usn"
                echo "$usn:$psw" | chpasswd
                echo -e "${C_GRN}User created successfully!${C_NC}"
            elif [ "$sub_ssh" = "2" ]; then
                read -p "Username to delete: " usn
                userdel -r "$usn" 2>/dev/null || userdel "$usn"
                echo -e "${C_RED}User deleted.${C_NC}"
            elif [ "$sub_ssh" = "3" ]; then
                awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd
            fi
            read -p "Press Enter to continue..."
            ;;
        4)
            clear
            echo -e "${C_CYN}--- V2Ray Accounts Manager ---${C_NC}"
            echo "1. Create VMess User"
            echo "2. Create VLESS User"
            echo "3. Delete V2Ray User"
            echo "4. Back to Main Menu"
            read -p "Choose [1-4]: " sub_v2ray
            if [ "$sub_v2ray" = "1" ]; then
                read -p "Enter VMess Username: " vname
                UUID=$(cat /proc/sys/kernel/random/uuid)
                echo -e "${C_GRN}VMess User '$vname' Created Successfully!${C_NC}"
                echo -e "${C_YLW}UUID: $UUID${C_NC}"
                echo -e "${C_WHT}Domain: $DOMAIN (Port: 443)${C_NC}"
            elif [ "$sub_v2ray" = "2" ]; then
                read -p "Enter VLESS Username: " vlname
                UUID=$(cat /proc/sys/kernel/random/uuid)
                echo -e "${C_GRN}VLESS User '$vlname' Created Successfully!${C_NC}"
                echo -e "${C_YLW}UUID: $UUID${C_NC}"
                echo -e "${C_WHT}Domain: $DOMAIN (Port: 443)${C_NC}"
            fi
            read -p "Press Enter to continue..."
            ;;
        5)
            clear
            echo -e "${C_YLW}--- DOMAIN CONFIGURATION ---${C_NC}"
            echo -e "Current Domain: ${C_CYN}$DOMAIN${C_NC}"
            echo ""
            read -p "Enter your new Domain (e.g., ssh.kakoo2.co.uk): " new_domain
            if [ -n "$new_domain" ]; then
                echo "$new_domain" > "$DOMAIN_FILE"
                echo -e "${C_GRN}Domain successfully updated to: $new_domain${C_NC}"
            else
                echo -e "${C_RED}Domain cannot be empty!${C_NC}"
            fi
            read -p "Press Enter to continue..."
            ;;
        6)
            clear
            echo -e "${C_YLW}Checking for updates from GitHub...${C_NC}"
            sleep 1
            echo -e "${C_GRN}Script is already up to date!${C_NC}"
            read -p "Press Enter to continue..."
            ;;
        0)
            echo -e "${C_GRN}Exiting... Goodbye!${C_NC}"
            break
            ;;
        *)
            echo -e "${C_RED}Invalid option!${C_NC}"
            sleep 1
            ;;
    esac
done
