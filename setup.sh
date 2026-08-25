#!/bin/bash
# =========================================
# SCRIPT NAME: K3ko Script
# VERSION: v9.1 Ultimate Pro Edition + Xray Engine
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
XRAY_CONF="/usr/local/etc/xray/config.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "DOMAIN=Auto" > "$CONFIG_FILE"
fi
[ ! -f "$V2RAY_DB" ] && touch "$V2RAY_DB"

# تثبيت وتشغيل محرك Xray تلقائياً لو مش موجود
if [ ! -f /usr/local/bin/xray ]; then
    echo -e "${C_YLW}Installing Xray Engine for V2Ray...${C_NC}"
    apt-get update -y >/dev/null 2>&1
    apt-get install curl unzip -y >/dev/null 2>&1
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install >/dev/null 2>&1
fi

LOCKED_BANNER="
════════════════════════════════════════════════════════════
 💥 ɪɴᴛᴇʀɴᴇᴛ ɪʟɪᴍɪᴛᴀᴅᴏ ☄️
                 『 HASSAN K3KO 』
               بسم الله الرحمن الرحيم 🛰️
                     حسان كعكو
 |whatsapp 
‏أضف رقمي كجهة اتصال في واتساب: https://wa.me/qr/BQSQFESYU5NUB1 📳
 |حسان كعكو 📺 |لخدمات الإنترنت 🗂
 كافة الخطوط وشرائح esim التي يعمل عليها الانترنت
 شكرا لاستخدام خدماتنا
════════════════════════════════════════════════════════════
"
echo "$LOCKED_BANNER" > /etc/issue.net
sed -i '/Banner/d' /etc/ssh/sshd_config 2>/dev/null
echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
systemctl restart ssh 2>/dev/null || systemctl restart sshd 2>/dev/null

while true; do
    clear
    PUBLIC_IP=$(curl -s ifconfig.me || echo "N/A")
    SAVED_DOMAIN=$(grep "DOMAIN=" "$CONFIG_FILE" | cut -d= -f2)
    [ "$SAVED_DOMAIN" = "Auto" ] && DOMAIN="$PUBLIC_IP" || DOMAIN="$SAVED_DOMAIN"
    
    SSH_USERS_COUNT=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)
    V2RAY_USERS_COUNT=$(wc -l < "$V2RAY_DB")

    echo -e "${C_PRP}╔════════════════════════════════════════════════════════════╗${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_YLW}                ⚡  H A S S A N   K 3 K O  ⚡               ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_CYN}             [ SCRIPT MANAGER v9.1 ULTIMATE ]           ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• IP Address  :${C_NC} ${C_WHT}$PUBLIC_IP${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• Domain      :${C_NC} ${C_CYN}$DOMAIN${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• Users Count :${C_NC} ${C_GRN}SSH: $SSH_USERS_COUNT${C_NC} | ${C_CYN}V2Ray: $V2RAY_USERS_COUNT${C_NC}       ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_YLW}                   --- MAIN CONTROL ---                     ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[1]${C_NC} 🚀 Install & Auto-Open All Ports (SSL/80/53/Proxy)   ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[2]${C_NC} 📊 Information Port Service (Ports List)           ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[3]${C_NC} 👤 SSH Accounts Manager                            ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[4]${C_NC} 🌐 V2Ray Accounts Manager                          ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[5]${C_NC} 🔄 Update Script from GitHub                       ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[0]${C_NC} 🚪 Exit                                            ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╚════════════════════════════════════════════════════════════╝${C_NC}"
    echo ""
    read -n 1 -p "Select option [0-5]: " choice
    echo ""

    case $choice in
        1)
            clear
            echo -e "${C_YLW}--- OPENING ALL PORTS & RESTARTING FIREWALL ---${C_NC}"
            apt-get update -y >/dev/null 2>&1
            apt-get install ufw iptables -y >/dev/null 2>&1
            
            PORTS_TO_OPEN=(22 53 80 81 109 143 442 443 88 1194 2200 5300 7100 7200 7300 8080 8880)
            for p in "${PORTS_TO_OPEN[@]}"; do
                ufw allow "$p" >/dev/null 2>&1
                ufw allow "$p/udp" >/dev/null 2>&1
            done
            ufw --force enable >/dev/null 2>&1
            systemctl restart xray >/dev/null 2>&1
            
            echo -e "${C_GRN}All Ports Opened and Xray Engine Restarted Successfully!${C_NC}"
            read -p "Press Enter to continue..."
            ;;
        2)
            clear
            echo -e "\n${C_WHT}\t┌──────────────────────────────────────────────┐${C_NC}"
            echo -e "\t│${C_RED}         » INFORMATION PORT SERVICE «         ${C_WHT}│${C_NC}"
            echo -e "\t└──────────────────────────────────────────────┘${C_NC}"
            echo -e "${C_YLW}\t┌──────────────────────────────────────────────┐${C_NC}"
            echo -e "\t│ ${C_GRN}» Open SSH                 ${C_CYN}: 443, 80, 22    ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» Dropbear                 ${C_CYN}: 443, 109, 143  ${C_YLW}│${C_NC}"
            echo -e "\t│ ${C_GRN}» XRAY Vmess / Vless       ${C_CYN}: 443, 80        ${C_YLW}│${C_NC}"
            echo -e "\t└──────────────────────────────────────────────┘${C_NC}"
            echo -e "\t${C_RED}* Upload By HASSAN K3KO *${C_NC}"
            echo ""
            read -p "Press Enter to return to main menu..."
            ;;
        3)
            while true; do
                clear
                echo -e "${C_PRP}╔════════════════════════════════════════════════════════════╗${C_NC}"
                echo -e "${C_PRP}║${C_NC}${C_YLW}                👤 SSH ACCOUNTS MANAGER                     ${C_NC}${C_PRP}║${C_NC}"
                echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[1]${C_NC} ➕ Create SSH Account                                ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[2]${C_NC} 🗑️ Delete SSH Account                              ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[3]${C_NC} 📋 List Active SSH Users                           ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[0]${C_NC} 🔙 Back to Main Menu                               ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}╚════════════════════════════════════════════════════════════╝${C_NC}"
                echo ""
                read -n 1 -p "Select option [0-3]: " ssh_choice
                echo ""
                
                case $ssh_choice in
                    1)
                        clear
                        echo -e "${C_YLW}--- CREATE NEW SSH ACCOUNT ---${C_NC}"
                        read -p "Enter Username: " username
                        if id "$username" >/dev/null 2>&1; then
                            echo -e "${C_RED}Error: User already exists!${C_NC}"
                        else
                            read -p "Enter Password: " password
                            read -p "Enter Expiry Days (e.g., 30): " days
                            exp_date=$(date -d "+$days days" +"%Y-%m-%d" 2>/dev/null || date -v +${days}d +"%Y-%m-%d")
                            useradd -e "$exp_date" -s /bin/false -M "$username" >/dev/null 2>&1
                            echo "$username:$password" | chpasswd >/dev/null 2>&1
                            echo -e "${C_GRN}Account Created Successfully!${C_NC}"
                        fi
                        read -p "Press Enter to continue..."
                        ;;
                    2)
                        clear
                        read -p "Enter Username to Delete: " del_user
                        userdel -r "$del_user" >/dev/null 2>&1
                        echo -e "${C_GRN}Deleted successfully!${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    3)
                        clear
                        awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd
                        read -p "Press Enter to continue..."
                        ;;
                    0)
                        break
                        ;;
                esac
            done
            ;;
        4)
            while true; do
                clear
                echo -e "${C_PRP}╔════════════════════════════════════════════════════════════╗${C_NC}"
                echo -e "${C_PRP}║${C_NC}${C_YLW}               🌐 V2RAY ACCOUNTS MANAGER                    ${C_NC}${C_PRP}║${C_NC}"
                echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[1]${C_NC} ➕ Create V2Ray (VMess/Vless)                        ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[2]${C_NC} 🗑️ Delete V2Ray Account                            ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[3]${C_NC} 📋 List V2Ray Accounts                             ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}║${C_NC}  ${C_GRN}[0]${C_NC} 🔙 Back to Main Menu                               ${C_PRP}║${C_NC}"
                echo -e "${C_PRP}╚════════════════════════════════════════════════════════════╝${C_NC}"
                echo ""
                read -n 1 -p "Select option [0-3]: " v2ray_choice
                echo ""
                
                case $v2ray_choice in
                    1)
                        clear
                        echo -e "${C_YLW}--- CREATE V2RAY ACCOUNT ---${C_NC}"
                        read -p "Enter V2Ray Username: " v_user
                        if grep -q "^$v_user" "$V2RAY_DB"; then
                            echo -e "${C_RED}Error: User already exists!${C_NC}"
                        else
                            UUID=$(cat /proc/sys/kernel/random/uuid 2>/dev/null || uuidgen)
                            echo "$v_user:$UUID" >> "$V2RAY_DB"
                            
                            # تحديث ملف إعدادات Xray الحقيقي على البورت 443
                            cat << EOF > "$XRAY_CONF"
{
  "inbounds": [
    {
      "port": 443,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {"id": "$UUID", "alterId": 0}
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/vmess"
        }
      }
    },
    {
      "port": 80,
      "protocol": "vless",
      "settings": {
        "clients": [
          {"id": "$UUID", "flow": ""}
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/vless"
        }
      }
    }
  ],
  "outbounds": [{"protocol": "freedom"}]
}
EOF
                            systemctl restart xray
                            
                            VMESS_LINK="vmess://$(echo -e "{\"v\":\"2\",\"ps\":\"$v_user-K3KO\",\"add\":\"$PUBLIC_IP\",\"port\":\"443\",\"id\":\"$UUID\",\"aid\":\"0\",\"net\":\"ws\",\"type\":\"none\",\"host\":\"$DOMAIN\",\"path\":\"/vmess\",\"tls\":\"\"}" | base64 -w 0)"
                            VLESS_LINK="vless://$UUID@$PUBLIC_IP:80?encryption=none&security=none&type=ws&host=$DOMAIN&path=%2Fvless#$v_user-K3KO"
                            
                            echo -e "${C_GRN}----------------------------------------${C_NC}"
                            echo -e "${C_GRN}V2Ray Account Created & Started Successfully!${C_NC}"
                            echo -e "User  : ${C_WHT}$v_user${C_NC}"
                            echo -e "UUID  : ${C_CYN}$UUID${C_NC}"
                            echo -e "${C_YLW}--- VMess Link (Port 443) ---${C_NC}"
                            echo -e "${C_WHT}$VMESS_LINK${C_NC}"
                            echo -e "${C_YLW}--- VLess Link (Port 80) ---${C_NC}"
                            echo -e "${C_WHT}$VLESS_LINK${C_NC}"
                            echo -e "${C_GRN}----------------------------------------${C_NC}"
                        fi
                        read -p "Press Enter to continue..."
                        ;;
                    2)
                        clear
                        read -p "Enter V2Ray Username to Delete: " del_v
                        sed -i "/^$del_v/d" "$V2RAY_DB"
                        echo -e "${C_GRN}Deleted successfully!${C_NC}"
                        read -p "Press Enter to continue..."
                        ;;
                    3)
                        clear
                        if [ -s "$V2RAY_DB" ]; then
                            cat "$V2RAY_DB"
                        else
                            echo -e "${C_RED}No accounts found.${C_NC}"
                        fi
                        read -p "Press Enter to continue..."
                        ;;
                    0)
                        break
                        ;;
                esac
            done
            ;;
        5)
            clear
            echo -e "${C_YLW}Updating script from GitHub...${C_NC}"
            wget --no-cache -O setup.sh https://raw.githubusercontent.com/hassankako/vps-malak/main/setup.sh >/dev/null 2>&1
            chmod +x setup.sh
            echo -e "${C_GRN}Script updated successfully! Restarting...${C_NC}"
            sleep 2
            exec ./setup.sh
            ;;
        0)
            clear
            exit 0
            ;;
    esac
done
