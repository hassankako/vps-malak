#!/bin/bash
# =========================================
# SCRIPT NAME: K3ko Pro Manager & Proxy
# VERSION: v11.0 ULTIMATE PRO
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

init_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        cat <<EOF > "$CONFIG_FILE"
{
  "inbounds": [
    {"port": 443, "protocol": "vless", "settings": {"clients": [], "decryption": "none"}, "streamSettings": {"network": "ws", "security": "none", "wsSettings": {"path": "/"}}},
    {"port": 80, "protocol": "vmess", "settings": {"clients": []}, "streamSettings": {"network": "ws", "security": "none", "wsSettings": {"path": "/"}}}
  ],
  "outbounds": [{"protocol": "freedom", "settings": {}}]
}
EOF
    fi
}
init_config

while true; do
    clear
    IP=$(curl -s ifconfig.me || hostname -I | awk '{print $1}' || echo "N/A")
    [ -f "$DOMAIN_FILE" ] && DOMAIN=$(cat "$DOMAIN_FILE") || DOMAIN="$IP"

    systemctl is-active --quiet haproxy && HAP_STATUS="${C_GRN}Run${C_NC}" || HAP_STATUS="${C_RED}Stop${C_NC}"
    systemctl is-active --quiet nginx && NGINX_STATUS="${C_GRN}Run${C_NC}" || NGINX_STATUS="${C_RED}Stop${C_NC}"
    systemctl is-active --quiet stunnel4 && ST_STATUS="${C_GRN}Run${C_NC}" || ST_STATUS="${C_RED}Stop${C_NC}"
    
    ONLINE_USERS=$(netstat -tn 2>/dev/null | grep -E ':80|:443|:22' | grep ESTABLISHED | wc -l)

    echo -e "${C_PRP}┌──────────────────────────────────────────────────┐${C_NC}"
    echo -e "${C_PRP}│${C_NC}${C_YLW}          ⚡ HASSAN K3KO - PRO MANAGER ⚡         ${C_NC}${C_PRP}│${C_NC}"
    echo -e "${C_PRP}├──────────────────────────────────────────────────┤${C_NC}"
    echo -e "${C_PRP}│${C_NC} ${C_BLU}IP Server :${C_NC} ${C_WHT}$IP${C_NC}"
    echo -e "${C_PRP}│${C_NC} ${C_BLU}Domain    :${C_NC} ${C_CYN}$DOMAIN${C_NC}"
    echo -e "${C_PRP}│${C_NC} ${C_BLU}Hap:${C_NC}$HAP_STATUS ${C_BLU}Ngx:${C_NC}$NGINX_STATUS ${C_BLU}Stn:${C_NC}$ST_STATUS ${C_BLU}On:${C_NC}${C_GRN}$ONLINE_USERS${C_NC}      ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}├──────────────────────────────────────────────────┤${C_NC}"
    echo -e "${C_PRP}│${C_NC}  ${C_GRN}[1]${C_NC} 🚀 Open Ports (80, 443 & Firewall)        ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}│${C_NC}  ${C_GRN}[2]${C_NC} 👤 SSH Manager (Add/Delete)             ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}│${C_NC}  ${C_GRN}[3]${C_NC} 🌐 Add VLESS WS User (Port 443 + Days/GB) ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}│${C_NC}  ${C_GRN}[4]${C_NC} 🌐 Add VMess WS User (Port 80 + Days/GB)  ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}│${C_NC}  ${C_GRN}[5]${C_NC} ⚡ Manage Nginx & HAProxy Services        ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}│${C_NC}  ${C_GRN}[6]${C_NC} 📄 View config.json                       ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}│${C_NC}  ${C_GRN}[7]${C_NC} ⚙️ Change Domain                          ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}│${C_NC}  ${C_RED}[0]${C_NC} 🚪 Exit                                   ${C_PRP}│${C_NC}"
    echo -e "${C_PRP}└──────────────────────────────────────────────────┘${C_NC}"
    echo ""
    read -p "Choose option [0-7]: " opt
    echo ""

    case $opt in
        1)
            echo -e "${C_GRN}Configuring and opening ports (80, 443, 22)...${C_NC}"
            ufw allow 80/tcp 2>/dev/null
            ufw allow 443/tcp 2>/dev/null
            ufw allow 22/tcp 2>/dev/null
            iptables -A INPUT -p tcp --dport 80 -j ACCEPT 2>/dev/null
            iptables -A INPUT -p tcp --dport 443 -j ACCEPT 2>/dev/null
            iptables -A INPUT -p tcp --dport 22 -j ACCEPT 2>/dev/null
            echo -e "${C_GRN}Ports opened successfully!${C_NC}"
            read -p "Press Enter..."
            ;;
        2)
            echo -e "${C_GRN}1. Add SSH User\n2. Delete SSH User${C_NC}"
            read -p "Choice: " sopt
            if [ "$sopt" = "1" ]; then
                read -p "Username: " usn
                read -p "Password: " psw
                useradd -M -s /bin/false "$usn"
                echo "$usn:$psw" | chpasswd
                echo -e "${C_GRN}SSH Direct User Created Successfully!${C_NC}"
            elif [ "$sopt" = "2" ]; then
                read -p "Username: " usn
                userdel -r "$usn" 2>/dev/null
                echo -e "${C_RED}User Deleted!${C_NC}"
            fi
            read -p "Press Enter..."
            ;;
        3)
            read -p "Username: " vname
            read -p "Expiry Days (الأيام): " vdays
            read -p "Data Limit GB (الجيجابايت): " vgb
            UUID=$(cat /proc/sys/kernel/random/uuid)
            EXP=$(date -d "+${vdays:-30} days" +"%Y-%m-%d" 2>/dev/null || date -v+${vdays:-30}d +"%Y-%m-%d")
            
            python3 -c "
import json
with open('$CONFIG_FILE', 'r') as f: data = json.load(f)
for i in data['inbounds']:
    if i.get('port') == 443: i['settings']['clients'].append({'id': '$UUID', 'level': 0, 'email': '$vname@$DOMAIN'})
with open('$CONFIG_FILE', 'w') as f: json.dump(data, f, indent=2)
"
            LINK="vless://$UUID@$DOMAIN:443?encryption=none&security=none&type=ws&host=$DOMAIN&path=%2F#${vname}-VLESS-WS"
            echo -e "${C_GRN}--- VLESS WebSocket Created Successfully ---${C_NC}"
            echo -e "${C_YLW}User:${C_NC} $vname | ${C_YLW}Days:${C_NC} $vdays ($EXP) | ${C_YLW}GB:${C_NC} $vgb"
            echo -e "${C_CYN}$LINK${C_NC}"
            read -p "Press Enter..."
            ;;
        4)
            read -p "Username: " vname
            read -p "Expiry Days (الأيام): " vdays
            read -p "Data Limit GB (الجيجابايت): " vgb
            UUID=$(cat /proc/sys/kernel/random/uuid)
            EXP=$(date -d "+${vdays:-30} days" +"%Y-%m-%d" 2>/dev/null || date -v+${vdays:-30}d +"%Y-%m-%d")
            
            python3 -c "
import json
with open('$CONFIG_FILE', 'r') as f: data = json.load(f)
for i in data['inbounds']:
    if i.get('port') == 80: i['settings']['clients'].append({'id': '$UUID', 'level': 0, 'alterId': 0, 'email': '$vname@$DOMAIN'})
with open('$CONFIG_FILE', 'w') as f: json.dump(data, f, indent=2)
"
            VJ="{\"v\":\"2\",\"ps\":\"${vname}-VMESS-WS\",\"add\":\"$DOMAIN\",\"port\":\"80\",\"id\":\"$UUID\",\"aid\":\"0\",\"scy\":\"auto\",\"net\":\"ws\",\"type\":\"none\",\"host\":\"$DOMAIN\",\"path\":\"/\"}"
            LINK="vmess://$(echo -n "$VJ" | base64 -w 0)"
            echo -e "${C_GRN}--- VMess WebSocket Created Successfully ---${C_NC}"
            echo -e "${C_YLW}User:${C_NC} $vname | ${C_YLW}Days:${C_NC} $vdays ($EXP) | ${C_YLW}GB:${C_NC} $vgb"
            echo -e "${C_CYN}$LINK${C_NC}"
            read -p "Press Enter..."
            ;;
        5)
            echo -e "${C_GRN}--- Services Control Menu ---${C_NC}"
            echo -e "1. Install & Start Nginx"
            echo -e "2. Install & Start HAProxy"
            echo -e "3. Restart All Services"
            read -p "Select action [1-3]: " sact
            if [ "$sact" = "1" ]; then
                apt update && apt install nginx -y
                systemctl enable nginx && systemctl restart nginx
            elif [ "$sact" = "2" ]; then
                apt update && apt install haproxy -y
                systemctl enable haproxy && systemctl restart haproxy
            elif [ "$sact" = "3" ]; then
                systemctl restart nginx haproxy stunnel4 xray 2>/dev/null
            fi
            echo -e "${C_GRN}Done!${C_NC}"
            read -p "Press Enter..."
            ;;
        6)
            cat "$CONFIG_FILE"
            read -p "Press Enter..."
            ;;
        7)
            read -p "Enter new Domain: " nd
            [ -n "$nd" ] && echo "$nd" > "$DOMAIN_FILE" && echo -e "${C_GRN}Domain Updated!${C_NC}"
            read -p "Press Enter..."
            ;;
        0)
            break
            ;;
    esac
done
