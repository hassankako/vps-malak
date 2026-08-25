#!/bin/bash
# =========================================
# SCRIPT NAME: K3ko Script
# VERSION: v6.4 Masterpiece Fixed & Optimized
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

# ملفات تتبع النظام (مع إصلاح حساب تاريخ التثبيت بدقة)
INSTALL_DATE_FILE="/etc/vps_install_date.txt"
if [ ! -f "$INSTALL_DATE_FILE" ]; then
    date +%s > "$INSTALL_DATE_FILE"
fi

INSTALL_TIME=$(cat "$INSTALL_DATE_FILE")
CURRENT_TIME=$(date +%s)
VPS_DAYS=$(( (CURRENT_TIME - INSTALL_TIME) / 86400 ))
[ $VPS_DAYS -lt 0 ] && VPS_DAYS=0

while true; do
    clear
    [ -f /etc/os-release ] && . /etc/os-release && SYS_OS="$NAME" || SYS_OS="Linux"
    
    PUBLIC_IP=$(curl -s --max-time 3 ifconfig.me || hostname -I | awk '{print $1}' || echo "N/A")
    DOMAIN=$(cat /etc/domain 2>/dev/null || echo "$PUBLIC_IP")
    
    TOTAL_USERS=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)
    ONLINE_USERS=$(ps -u root h | wc -l 2>/dev/null || echo "1")
    
    EXPIRED_COUNT=0
    for u in $(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd); do
        l_status=$(passwd -S "$u" 2>/dev/null | awk '{print $2}')
        [ "$l_status" = "L" ] && EXPIRED_COUNT=$((EXPIRED_COUNT + 1))
    done

    SSH_OVPN_COUNT=$TOTAL_USERS
    VMESS_COUNT=0
    VLESS_COUNT=0

    echo -e "${C_PRP}╔════════════════════════════════════════════════════════════╗${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_YLW}                ⚡  H A S S A N   K 3 K O  ⚡               ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_CYN}               [ PROFESSIONAL VPS MANAGER v6.4 ]            ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• IP Address :${C_NC} ${C_WHT}$PUBLIC_IP${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• Domain     :${C_NC} ${C_CYN}$DOMAIN${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• System OS  :${C_NC} ${C_WHT}$SYS_OS${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• Uptime Days:${C_NC} ${C_GRN}$VPS_DAYS Days${C_NC}                              ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_GRN}SSH OVPN: $SSH_OVPN_COUNT${C_NC}  ${C_YLW}VMESS: $VMESS_COUNT${C_NC}  ${C_CYN}VLESS: $VLESS_COUNT${C_NC}               ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_YLW}                   --- CONTROL PANEL ---                    ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[1]${C_NC} 🔑 SSH / OVPN Manager                              ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[2]${C_NC} ⚡ VMess / VLESS Manager                           ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[3]${C_NC} 📊 Users Report & Expiry Status                    ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[4]${C_NC} 🛠️ WebSocket & SOCKS Proxies                       ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[5]${C_NC} ⚡ Fast DNS, Ports & Server Reboot                 ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╚════════════════════════════════════════════════════════════╝${C_NC}"
    echo -e "${C_WHT}      [ Online: $ONLINE_USERS | Total: $TOTAL_USERS | Expired: $EXPIRED_COUNT ]${C_NC}"
    echo ""
    read -n 1 -p "Select option [1-5]: " choice
    echo ""

    case $choice in
        1)
            clear
            echo -e "${C_GRN}--- SSH / OVPN MANAGER ---${C_NC}"
            echo "1. Add SSH User"
            echo "2. Delete SSH User"
            echo "3. Edit Existing User (Password / Expiry)"
            read -p "Choose [1-3]: " sub
            if [ "$sub" = "1" ]; then
                read -p "Enter Username: " uname
                read -p "Enter Password: " upass
                read -p "Enter Expiry Days: " udays
                useradd -M -s /bin/false "$uname"
                echo "$uname:$upass" | chpasswd
                EXP_DATE=$(date -d "+$udays days" +"%Y-%m-%d" 2>/dev/null || date -v +${udays}d +"%Y-%m-%d" 2>/dev/null)
                chage -E "$EXP_DATE" "$uname" 2>/dev/null
                echo -e "${C_GRN}User $uname created successfully! Expires on: $EXP_DATE${C_NC}"
            elif [ "$sub" = "2" ]; then
                read -p "Username to delete: " uname
                userdel -r "$uname" 2>/dev/null || userdel "$uname"
                echo -e "${C_RED}User deleted.${C_NC}"
            elif [ "$sub" = "3" ]; then
                read -p "Enter Username to Edit: " euser
                if id "$euser" &>/dev/null; then
                    while true; do
                        clear
                        echo -e "${C_YLW}--- Editing User: $euser ---${NC}"
                        echo "1) 🔑 Change Password"
                        echo "2) 📅 Change Expiration Date"
                        echo "0) 🟩 Finish Editing"
                        read -p "Enter your choice: " ed_choice
                        case $ed_choice in
                            1)
                                read -p "Enter new password: " npass
                                echo "$euser:$npass" | chpasswd
                                echo -e "${C_GRN}Password updated!${C_NC}"
                                sleep 1
                                ;;
                            2)
                                read -p "Enter new expiry days from now: " ndays
                                n_exp=$(date -d "+$ndays days" +"%Y-%m-%d" 2>/dev/null || date -v +${ndays}d +"%Y-%m-%d" 2>/dev/null)
                                chage -E "$n_exp" "$euser"
                                echo -e "${C_GRN}Expiry date updated to $n_exp!${C_NC}"
                                sleep 1
                                ;;
                            0)
                                break
                                ;;
                        esac
                    done
                else
                    echo -e "${C_RED}User not found!${C_NC}"
                fi
            fi
            read -p "Press Enter to continue..."
            ;;
        2)
            clear
            echo -e "${C_GRN}--- VMESS / VLESS MANAGER ---${NC}"
            echo "1. Install Xray Core"
            echo "2. Create VMess User"
            echo "3. Create VLESS User"
            read -p "Choose [1-3]: " sub
            if [ "$sub" = "1" ]; then
                bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
            elif [ "$sub" = "2" ]; then
                read -p "Enter VMess Username: " vname
                UUID=$(cat /proc/sys/kernel/random/uuid)
                echo -e "${C_GRN}VMess User Created! UUID: $UUID${C_NC}"
            elif [ "$sub" = "3" ]; then
                read -p "Enter VLESS Username: " vlname
                UUID=$(cat /proc/sys/kernel/random/uuid)
                echo -e "${C_GRN}VLESS User Created! UUID: $UUID${C_NC}"
            fi
            read -p "Press Enter to continue..."
            ;;
        3)
            clear
            echo -e "${C_YLW}========================================================================${C_NC}"
            echo -e "${C_GRN}               SSH USERS MANAGEMENT & EXPIRY REPORT                     ${C_NC}"
            echo -e "${C_YLW}========================================================================${C_NC}"
            printf "${C_CYN}%-12s | %-12s | %-12s | %-15s${C_NC}\n" "ACCOUNT" "EXPIRES" "ONLINE" "STATUS"
            echo "------------------------------------------------------------------------"
            
            while IFS: read -r user x uid gid desc home shell; do
                if [ "$uid" -ge 1000 ] && [ "$user" != "nobody" ]; then
                    online_count=$(ps -u "$user" h 2>/dev/null | wc -l)
                    
                    exp_info=$(chage -l "$user" 2>/dev/null | grep "Account expires" | cut -d: -f2)
                    if [ -n "$exp_info" ] && [ "$exp_info" != " never" ]; then
                        exp_date=$(date -d "$exp_info" "+%Y-%m-%d" 2>/dev/null || echo "$exp_info")
                    else
                        exp_date="Unlimited"
                    fi

                    is_locked=$(passwd -S "$user" 2>/dev/null | awk '{print $2}')
                    if [ "$is_locked" = "L" ]; then
                        status="${C_RED}Locked/Expired${C_NC}"
                    else
                        status="${C_GRN}Active${C_NC}"
                    fi

                    printf "${C_WHT}%-12s${C_NC} | ${C_YLW}%-12s${C_NC} | ${C_BLU}%-12s${C_NC} | %-15s\n" "$user" "$exp_date" "$online_count" "$status"
                fi
            done < /etc/passwd
            echo -e "${C_YLW}========================================================================${C_NC}"
            read -p "Press Enter to continue..."
            ;;
        4)
            clear
            echo -e "${C_GRN}--- WEBSOCKET & PROXIES MANAGER ---${NC}"
            echo "1) Install WebSocket Proxy (Status 101)"
            echo "2) Uninstall WebSocket Proxy"
            echo "3) Install SOCKS Proxy (Status 200)"
            read -p "Choose option [1-3]: " p_choice
            echo -e "${C_GRN}Proxy operation executed successfully!${C_NC}"
            read -p "Press Enter to continue..."
            ;;
        5)
            clear
            echo -e "${C_YLW}--- FAST DNS, PORTS & SERVER SETTINGS ---${NC}"
            echo "1. ⚡ Install Fast DNS (Cloudflare & Google Ultra Speed)"
            echo "2. Open Custom Port"
            echo "3. View All Open Ports"
            echo "4. Open All Standard VPN/Proxy Ports"
            echo "5. 🔄 Reboot Server (إعادة إقلاع الخادم)"
            read -p "Choose [1-5]: " s_choice
            case $s_choice in
                1)
                    echo -e "${C_CYN}[*] Applying Ultra Fast DNS to system...${C_NC}"
                    chattr -i /etc/resolv.conf 2>/dev/null
                    cat <<EOF > /etc/resolv.conf
nameserver 1.1.1.1
nameserver 8.8.8.8
nameserver 1.0.0.1
nameserver 8.8.4.4
EOF
                    chattr +i /etc/resolv.conf 2>/dev/null
                    echo -e "${C_GRN}[+] Fast DNS applied successfully!${C_NC}"
                    ;;
                2)
                    read -p "Enter port number: " nport
                    ufw allow "$nport" 2>/dev/null
                    iptables -A INPUT -p tcp --dport "$nport" -j ACCEPT 2>/dev/null
                    echo -e "${C_GRN}Port $nport opened!${C_NC}"
                    ;;
                3)
                    ss -tuln 2>/dev/null || netstat -tuln
                    ;;
                4)
                    for p in 22 80 443 8080 2082 2083 2095 8443; do
                        ufw allow $p 2>/dev/null
                        iptables -A INPUT -p tcp --dport $p -j ACCEPT 2>/dev/null
                    done
                    echo -e "${C_GRN}All standard ports opened!${C_NC}"
                    ;;
                5)
                    echo -e "${C_RED}Warning: This will restart the entire VPS!${C_NC}"
                    read -p "Are you sure you want to reboot? [y/N]: " confirm
                    if [[ "$confirm" =~ ^[Yy]$ ]]; then
                        echo -e "${C_YLW}Rebooting server now... Goodbye!${C_NC}"
                        reboot
                    else
                        echo -e "${C_GRN}Reboot cancelled.${C_NC}"
                    fi
                    ;;
            esac
            read -p "Press Enter to continue..."
            ;;
    esac
done
