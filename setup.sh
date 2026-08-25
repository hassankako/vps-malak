#!/bin/bash
# =========================================
# SCRIPT NAME: K3ko Script
# VERSION: v5.2 Masterpiece
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

# ملفات تتبع النظام
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
    echo -e "${C_PRP}║${C_NC}${C_CYN}               [ PROFESSIONAL VPS MANAGER v5.2 ]            ${C_NC}${C_PRP}║${C_NC}"
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
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[4]${C_NC} ⚙️ All Ports & Settings                            ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╚════════════════════════════════════════════════════════════╝${C_NC}"
    echo -e "${C_WHT}                  Date: $(date '+%Y-%m-%d %H:%M')${C_NC}"
    echo ""
    read -n 1 -p "Select option [1-4]: " choice
    echo ""

    case $choice in
        1)
            clear
            echo -e "${C_GRN}--- SSH / OVPN MANAGER ---${NC}"
            echo "1. Add SSH User"
            echo "2. Delete SSH User"
            echo "3. List Users & Online Connections"
            read -p "Choose [1-3]: " sub
            if [ "$sub" = "1" ]; then
                read -p "Enter Username: " uname
                read -p "Enter Password: " upass
                read -p "Enter Expiry Days: " udays
                useradd -M -s /bin/false "$uname"
                echo "$uname:$upass" | chpasswd
                # تحديد تاريخ الانتهاء بناءً على عدد الأيام
                EXP_DATE=$(date -d "+$udays days" +"%Y-%m-%d" 2>/dev/null || date -v +${udays}d +"%Y-%m-%d" 2>/dev/null)
                chage -E "$EXP_DATE" "$uname" 2>/dev/null
                echo -e "${C_GRN}User $uname created successfully! Expires on: $EXP_DATE${C_NC}"
            elif [ "$sub" = "2" ]; then
                read -p "Username to delete: " uname
                userdel "$uname" && echo -e "${C_RED}User deleted.${C_NC}"
            elif [ "$sub" = "3" ]; then
                clear
                echo -e "${C_YLW}========================================================================${C_NC}"
                echo -e "${C_GRN}               SSH USERS MANAGEMENT & EXPIRY REPORT                     ${C_NC}"
                echo -e "${C_YLW}========================================================================${C_NC}"
                printf "${C_CYN}%-12s | %-12s | %-12s | %-15s${C_NC}\n" "ACCOUNT" "EXPIRES" "ONLINE/MAX" "STATUS"
                echo "------------------------------------------------------------------------"
                
                # جلب المستخدمين الذين معرفهم أكبر من أو يساوي 1000
                for user in $(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd); do
                    # حساب عدد المتصلين الحاليين
                    online_count=$(ps -u "$user" 2>/dev/null | grep -v "PID" | wc -l)
                    
                    # جلب تاريخ انتهاء الحساب من نظام chage
                    exp_info=$(chage -l "$user" 2>/dev/null | grep "Account expires" | cut -d: -f2)
                    if [ -n "$exp_info" ] && [ "$exp_info" != " never" ]; then
                        exp_date=$(date -d "$exp_info" "+%Y-%m-%d" 2>/dev/null || echo "$exp_info")
                    else
                        exp_date="Unlimited"
                    fi

                    # التحقق مما إذا كان الحساب منتهياً أو مقفلاً
                    is_locked=$(passwd -S "$user" 2>/dev/null | awk '{print $2}')
                    
                    if [ "$is_locked" = "L" ]; then
                        status="${C_RED}Locked/Expired${C_NC}"
                    else
                        status="${C_GRN}Active${C_NC}"
                    fi

                    # طباعة السطر بتنسيق مرتب
                    printf "${C_WHT}%-12s${C_NC} | ${C_YLW}%-12s${C_NC} | ${C_BLU}%-12s${C_NC} | %-15s\n" "$user" "$exp_date" "$online_count / 1" "$status"
                done
                echo -e "${C_YLW}========================================================================${C_NC}"
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
            echo -e "${C_YLW}--- ALL PORTS & SETTINGS ---${NC}"
            echo "1. Open Custom Port"
            echo "2. View All Open Ports"
            echo "3. Open All Standard VPN/Proxy Ports"
            read -p "Choose [1-3]: " s_choice
            case $s_choice in
                1)
                    read -p "Enter port number: " nport
                    ufw allow "$nport" 2>/dev/null
                    iptables -A INPUT -p tcp --dport "$nport" -j ACCEPT 2>/dev/null
                    echo -e "${C_GRN}Port $nport opened!${C_NC}"
                    ;;
                2)
                    netstat -tuln 2>/dev/null || ss -tuln
                    ;;
                3)
                    for p in 22 80 443 8080 2082 2083 2095 8443; do
                        ufw allow $p 2>/dev/null
                        iptables -A INPUT -p tcp --dport $p -j ACCEPT 2>/dev/null
                    done
                    echo -e "${C_GRN}All standard ports opened!${C_NC}"
                    ;;
            esac
            read -p "Press Enter to continue..."
            ;;
    esac
done
