#!/bin/bash
# =========================================
# SCRIPT NAME: K3ko Script Manager
# VERSION: v9.3 ULTIMATE (Real Config & Link Generator)
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

DOMAIN_FILE="/etc/domain"
CONFIG_DIR="/etc/v2ray"
CONFIG_FILE="$CONFIG_DIR/config.json"

mkdir -p "$CONFIG_DIR"

# دالة لإنشاء ملف إعدادات أساسي إذا لم يكن موجوداً
init_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        cat <<EOF > "$CONFIG_FILE"
{
  "inbounds": [
    {
      "port": 443,
      "protocol": "vless",
      "settings": {
        "clients": [],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "security": "none"
      }
    },
    {
      "port": 80,
      "protocol": "vmess",
      "settings": {
        "clients": []
      },
      "streamSettings": {
        "network": "tcp",
        "security": "none"
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}
EOF
    fi
}

init_config

while true; do
    clear
    PUBLIC_IP=$(curl -s ifconfig.me || hostname -I | awk '{print $1}' || echo "N/A")
    
    if [ -f "$DOMAIN_FILE" ]; then
        DOMAIN=$(cat "$DOMAIN_FILE")
    else
        DOMAIN="$PUBLIC_IP"
    fi
    
    SSH_COUNT=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)

    echo -e "${C_PRP}╔════════════════════════════════════════════════════════════╗${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_YLW}                ⚡  H A S S A N   K 3 K O  ⚡               ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_CYN}            [ SCRIPT MANAGER v9.3 ULTIMATE ]                ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• IP Address  :${C_NC} ${C_WHT}$PUBLIC_IP${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• Domain      :${C_NC} ${C_CYN}$DOMAIN${C_NC}"
    echo -e "${C_PRP}║${C_NC} ${C_BLU}• Users Count :${C_NC} ${C_GRN}SSH: $SSH_COUNT${C_NC}                            ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC}${C_YLW}                   --- MAIN CONTROL ---                     ${C_NC}${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╠════════════════════════════════════════════════════════════╣${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[1]${C_NC} 🚀 Open Ports 80 & 443 (فتح المنافذ)             ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[2]${C_NC} 🛠️ Fix & Free Ports 80 / 443 (تحرير المنافذ)      ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[3]${C_NC} 👤 SSH Accounts Manager                         ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[4]${C_NC} 🌐 V2Ray Real Config & Links (Ports 80 & 443) ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_GRN}[5]${C_NC} 🌐 Add / Change Domain (تغيير الدومين)         ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}║${C_NC}  ${C_RED}[0]${C_NC} 🚪 Exit                                       ${C_PRP}║${C_NC}"
    echo -e "${C_PRP}╚════════════════════════════════════════════════════════════╝${C_NC}"
    echo ""
    read -p "Select option [0-5]: " choice
    echo ""

    case $choice in
        1)
            clear
            echo -e "${C_GRN}--- Opening Ports 80 & 443 ---${C_NC}"
            ufw allow 80/tcp 2>/dev/null
            ufw allow 443/tcp 2>/dev/null
            iptables -A INPUT -p tcp --dport 80 -j ACCEPT 2>/dev/null
            iptables -A INPUT -p tcp --dport 443 -j ACCEPT 2>/dev/null
            echo -e "${C_GRN}Ports 80 and 443 opened successfully!${C_NC}"
            read -p "Press Enter to continue..."
            ;;
        2)
            clear
            echo -e "${C_YLW}--- Freeing Ports 80 & 443 ---${C_NC}"
            systemctl stop apache2 2>/dev/null
            systemctl disable apache2 2>/dev/null
            systemctl stop nginx 2>/dev/null
            fuser -k 80/tcp 2>/dev/null
            fuser -k 443/tcp 2>/dev/null
            echo -e "${C_GRN}Ports 80 and 443 are now free!${C_NC}"
            read -p "Press Enter to continue..."
            ;;
        3)
            clear
            echo -e "${C_GRN}--- SSH Accounts Manager ---${C_NC}"
            echo "1. Add SSH User"
            echo "2. Delete SSH User"
            read -p "Choose [1-2]: " sub_ssh
            if [ "$sub_ssh" = "1" ]; then
                read -p "Username: " usn
                read -p "Password: " psw
                useradd -M -s /bin/false "$usn"
                echo "$usn:$psw" | chpasswd
                echo -e "${C_GRN}SSH User created successfully!${C_NC}"
            elif [ "$sub_ssh" = "2" ]; then
                read -p "Username to delete: " usn
                userdel -r "$usn" 2>/dev/null
                echo -e "${C_RED}User deleted successfully.${C_NC}"
            fi
            read -p "Press Enter to continue..."
            ;;
        4)
            clear
            echo -e "${C_CYN}--- V2Ray Real Config & Links ---${C_NC}"
            echo "1. Add VLESS User (Port 443) & Get Link"
            echo "2. Add VMess User (Port 80) & Get Link"
            echo "3. View Full config.json File"
            read -p "Choose [1-3]: " sub_v2ray
            
            init_config
            
            if [ "$sub_v2ray" = "1" ]; then
                read -p "Enter VLESS Username: " vname
                UUID=$(cat /proc/sys/kernel/random/uuid)
                
                python3 -c "
import json
with open('$CONFIG_FILE', 'r') as f:
    data = json.load(f)
for inbound in data['inbounds']:
    if inbound.get('port') == 443:
        inbound['settings']['clients'].append({'id': '$UUID', 'level': 0, 'email': '$vname@$DOMAIN'})
with open('$CONFIG_FILE', 'w') as f:
    json.dump(data, f, indent=2)
"
                # توليد رابط VLESS الحقيقي
                VLESS_LINK="vless://$UUID@$DOMAIN:443?encryption=none&security=none&type=tcp#${vname}-VLESS443"

                echo -e "${C_GRN}VLESS User Added to Port 443 Successfully!${C_NC}"
                echo -e "${C_YLW}------------------------------------------------------${C_NC}"
                echo -e "${C_WHT}VLESS Link:${C_NC}"
                echo -e "${C_CYN}$VLESS_LINK${C_NC}"
                echo -e "${C_YLW}------------------------------------------------------${C_NC}"
                
            elif [ "$sub_v2ray" = "2" ]; then
                read -p "Enter VMess Username: " vname
                UUID=$(cat /proc/sys/kernel/random/uuid)
                
                python3 -c "
import json
with open('$CONFIG_FILE', 'r') as f:
    data = json.load(f)
for inbound in data['inbounds']:
    if inbound.get('port') == 80:
        inbound['settings']['clients'].append({'id': '$UUID', 'level': 0, 'alterId': 0, 'email': '$vname@$DOMAIN'})
with open('$CONFIG_FILE', 'w') as f:
    json.dump(data, f, indent=2)
"
                # تجهيز وتشفير رابط VMess بصيغة Base64 كالنظام القياسي
                VMESS_JSON="{\"v\":\"2\",\"ps\":\"${vname}-VMESS80\",\"add\":\"$DOMAIN\",\"port\":\"80\",\"id\":\"$UUID\",\"aid\":\"0\",\"scy\":\"auto\",\"net\":\"type\",\"type\":\"none\",\"host\":\"\",\"path\":\"/\"}"
                VMESS_LINK="vmess://$(echo -n "$VMESS_JSON" | base64 -w 0)"

                echo -e "${C_GRN}VMess User Added to Port 80 Successfully!${C_NC}"
                echo -e "${C_YLW}------------------------------------------------------${C_NC}"
                echo -e "${C_WHT}VMess Link:${C_NC}"
                echo -e "${C_CYN}$VMESS_LINK${C_NC}"
                echo -e "${C_YLW}------------------------------------------------------${C_NC}"
                
            elif [ "$sub_v2ray" = "3" ]; then
                echo -e "${C_YLW}--- Contents of $CONFIG_FILE ---${C_NC}"
                cat "$CONFIG_FILE"
            fi
            read -p "Press Enter to continue..."
            ;;
        5)
            clear
            echo -e "${C_YLW}--- DOMAIN CONFIGURATION ---${C_NC}"
            echo -e "Current Domain: ${C_CYN}$DOMAIN${C_NC}"
            read -p "Enter new Domain: " new_domain
            if [ -n "$new_domain" ]; then
                echo "$new_domain" > "$DOMAIN_FILE"
                echo -e "${C_GRN}Domain successfully updated to: $new_domain${C_NC}"
            fi
            read -p "Press Enter to continue..."
            ;;
        0)
            echo -e "${C_GRN}Goodbye!${C_NC}"
            break
            ;;
    esac
done
