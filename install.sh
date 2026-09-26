
---

## 📄 2. `install.sh`

```bash
#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# BHHK API CRASHER — Termux Installer
# ============================================================

clear

# Colors
CYAN='\033[0;36m'
PINK='\033[0;35m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
WHITE='\033[1;37m'
DIM='\033[2m'
NC='\033[0m'

# ============================================================
# BOOT ANIMATION
# ============================================================
show_boot() {
    clear
    echo ""
    echo -e "${CYAN}    ╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}    ║${NC}  ${PINK}⚡  B H H K   A P I   C R A S H E R  ⚡${NC}  ${CYAN}║${NC}"
    echo -e "${CYAN}    ║${NC}      ${DIM}Cyber Funk Stress Engine v1.0${NC}      ${CYAN}║${NC}"
    echo -e "${CYAN}    ╚══════════════════════════════════════════╝${NC}"
    echo ""

    sleep 0.3
    local steps=(
        "Initializing core modules"
        "Loading network engine"
        "Calibrating worker threads"
        "Preparing log terminal"
        "Finalizing environment"
    )

    for i in "${!steps[@]}"; do
        local progress=$(( (i + 1) * 100 / ${#steps[@]} ))
        local bar=""
        local filled=$(( progress / 5 ))
        for ((j=0; j<20; j++)); do
            if [ $j -lt $filled ]; then
                bar="${bar}█"
            else
                bar="${bar}░"
            fi
        done
        printf "\r  ${CYAN}▸${NC} ${WHITE}%-30s${NC} ${PINK}[${bar}]${NC} ${GREEN}%3d%%${NC}" \
            "${steps[$i]}" "$progress"
        sleep 0.35
    done
    echo ""
    echo ""
}

show_boot

# ============================================================
# INSTALL DEPENDENCIES
# ============================================================
echo -e "${CYAN}▸${NC} ${WHITE}Updating packages...${NC}"
pkg update -y > /dev/null 2>&1

echo -e "${CYAN}▸${NC} ${WHITE}Installing dependencies...${NC}"
for pkg_name in bash curl jq figlet toilet; do
    if ! command -v $pkg_name > /dev/null 2>&1; then
        echo -e "${DIM}  installing $pkg_name...${NC}"
        pkg install -y $pkg_name > /dev/null 2>&1
    fi
done

echo -e "${GREEN}✓${NC} ${WHITE}All dependencies ready${NC}"
echo ""

# ============================================================
# SETUP BIN
# ============================================================
BIN_DIR="$PREFIX/bin"
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/crasher.sh"

chmod +x "$SCRIPT_PATH"

cat > "$BIN_DIR/bhhk" << EOF
#!/data/data/com.termux/files/usr/bin/bash
bash "$SCRIPT_PATH" "\$@"
EOF

chmod +x "$BIN_DIR/bhhk"

echo -e "${GREEN}✓${NC} ${WHITE}Command registered:${NC} ${PINK}bhhk${NC}"
echo ""

# ============================================================
# DONE
# ============================================================
echo -e "${CYAN}    ╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}    ║${NC}  ${GREEN}✓ INSTALLATION COMPLETE${NC}                ${CYAN}║${NC}"
echo -e "${CYAN}    ║${NC}                                          ${CYAN}║${NC}"
echo -e "${CYAN}    ║${NC}  ${WHITE}Run:${NC} ${PINK}bhhk${NC}                            ${CYAN}║${NC}"
echo -e "${CYAN}    ╚══════════════════════════════════════════╝${NC}"
echo ""

read -p "  Press ENTER to launch BHHK API CRASHER..."
bash "$SCRIPT_PATH"