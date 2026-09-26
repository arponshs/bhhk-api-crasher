#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# BHHK API CRASHER — Installer
# ============================================================

CYAN='\033[0;36m'
PINK='\033[0;35m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
WHITE='\033[1;37m'
DIM='\033[2m'
NC='\033[0m'

clear
echo ""
echo -e "${CYAN}    ╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}    ║${NC}  ${PINK}⚡  B H H K   A P I   C R A S H E R  ⚡${NC}  ${CYAN}║${NC}"
echo -e "${CYAN}    ║${NC}      ${DIM}BHHK TEAMS Stress Engine v2.0${NC}      ${CYAN}║${NC}"
echo -e "${CYAN}    ╚══════════════════════════════════════════╝${NC}"
echo ""

# ------------------------------------------------------------
# 1. Update packages
# ------------------------------------------------------------
echo -e "${CYAN}▸${NC} ${WHITE}Updating package list...${NC}"
pkg update -y > /dev/null 2>&1

# ------------------------------------------------------------
# 2. Install dependencies
# ------------------------------------------------------------
echo -e "${CYAN}▸${NC} ${WHITE}Installing dependencies...${NC}"

for pkg in curl bash; do
    if command -v "$pkg" > /dev/null 2>&1; then
        echo -e "  ${DIM}✓ ${pkg} already installed${NC}"
    else
        echo -e "  ${DIM}▸ installing ${pkg}...${NC}"
        pkg install -y "$pkg" > /dev/null 2>&1
        if command -v "$pkg" > /dev/null 2>&1; then
            echo -e "  ${GREEN}✓${NC} ${WHITE}${pkg} installed${NC}"
        else
            echo -e "  ${RED}✗${NC} ${WHITE}${pkg} failed${NC}"
            exit 1
        fi
    fi
done

echo ""

# ------------------------------------------------------------
# 3. Locate source directory
# ------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MAIN_SCRIPT="$SCRIPT_DIR/bhhk.sh"

if [ ! -f "$MAIN_SCRIPT" ]; then
    echo -e "${RED}✗ bhhk.sh not found in $SCRIPT_DIR${NC}"
    exit 1
fi

chmod +x "$MAIN_SCRIPT"
echo -e "${GREEN}✓${NC} ${WHITE}bhhk.sh ready${NC}"

# ------------------------------------------------------------
# 4. Create global command
# ------------------------------------------------------------
BIN_DIR="$PREFIX/bin"
LAUNCHER="$BIN_DIR/bhhk"

if [ -z "$PREFIX" ]; then
    echo -e "${RED}✗ Termux environment not detected${NC}"
    exit 1
fi

cat > "$LAUNCHER" << EOF
#!/data/data/com.termux/files/usr/bin/bash
exec bash "$MAIN_SCRIPT" "\$@"
EOF

chmod +x "$LAUNCHER"
echo -e "${GREEN}✓${NC} ${WHITE}Command registered:${NC} ${PINK}bhhk${NC}"

# ------------------------------------------------------------
# 5. Done
# ------------------------------------------------------------
echo ""
echo -e "${CYAN}    ╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}    ║${NC}  ${GREEN}✓ INSTALLATION COMPLETE${NC}                ${CYAN}║${NC}"
echo -e "${CYAN}    ║${NC}                                          ${CYAN}║${NC}"
echo -e "${CYAN}    ║${NC}  ${WHITE}Run:${NC} ${PINK}bhhk${NC}                            ${CYAN}║${NC}"
echo -e "${CYAN}    ╚══════════════════════════════════════════╝${NC}"
echo ""

printf "  ${DIM}Launch now? [Y/n]: ${NC}"
read -r ans
case "$ans" in
    n|N) echo -e "\n  ${DIM}Run 'bhhk' to start.${NC}\n" ;;
    *)   bash "$MAIN_SCRIPT" ;;
esac