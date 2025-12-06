#!/bin/zsh
# ══════════════════════════════════════════════════════════════════════════════════════
#
#  ╔═══════════════════════════════════════════════════════════════════════════════════╗
#  ║                                                                                   ║
#  ║   ██╗   ██╗███╗   ██╗██╗██╗   ██╗███████╗██████╗ ███████╗ █████╗ ██╗             ║
#  ║   ██║   ██║████╗  ██║██║██║   ██║██╔════╝██╔══██╗██╔════╝██╔══██╗██║             ║
#  ║   ██║   ██║██╔██╗ ██║██║██║   ██║█████╗  ██████╔╝███████╗███████║██║             ║
#  ║   ██║   ██║██║╚██╗██║██║╚██╗ ██╔╝██╔══╝  ██╔══██╗╚════██║██╔══██║██║             ║
#  ║   ╚██████╔╝██║ ╚████║██║ ╚████╔╝ ███████╗██║  ██║███████║██║  ██║███████╗        ║
#  ║    ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝        ║
#  ║                                                                                   ║
#  ║   ███████╗ █████╗ ███╗   ███╗███████╗ ██████╗ ███████╗████████╗                  ║
#  ║   ██╔════╝██╔══██╗████╗ ████║██╔════╝██╔═══██╗██╔════╝╚══██╔══╝                  ║
#  ║   ███████╗███████║██╔████╔██║███████╗██║   ██║█████╗     ██║                     ║
#  ║   ╚════██║██╔══██║██║╚██╔╝██║╚════██║██║   ██║██╔══╝     ██║                     ║
#  ║   ███████║██║  ██║██║ ╚═╝ ██║███████║╚██████╔╝██║        ██║                     ║
#  ║   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═╝        ╚═╝                     ║
#  ║                                                                                   ║
#  ║        🐱 CAT 'N' CO SDK for Macintosh's 🐱                                      ║
#  ║                                                                                   ║
#  ║   ════════════════════════════════════════════════════════════════════════════   ║
#  ║                                                                                   ║
#  ║       The Ultimate Retro & Modern Compiler Collection                            ║
#  ║       1930s Turing Machines  ───────────────────►  2025 WebAssembly              ║
#  ║                                                                                   ║
#  ║              /\_/\                                                                ║
#  ║             ( o.o )   "Purrfectly compiled, every time."                         ║
#  ║              > ^ <                                                                ║
#  ║                                                                                   ║
#  ║   ════════════════════════════════════════════════════════════════════════════   ║
#  ║                                                                                   ║
#  ║   [C] 2000-2025 SAMSOFT / Team Flames / Flames Co.                               ║
#  ║   All Rights Reserved. Made with 🐱 in California.                               ║
#  ║                                                                                   ║
#  ╚═══════════════════════════════════════════════════════════════════════════════════╝
#
# ══════════════════════════════════════════════════════════════════════════════════════
#
#  UNIVERSAL SAMSOFT CAT 'N' CO [C]2000-2025 SDK for Macintosh's
#  Version 1.0.0 | Codename "Whiskers"
#
#  Supports: macOS Tahoe (15.x / 26.x+) | Apple Silicon & Intel
#
#  Usage: ./CatNCo_SDK.sh [-y] [-q] [-n64-only]
#    -y         Auto-yes to all prompts
#    -q         Quiet mode (minimal output)
#    -n64-only  Only install N64 toolchain
#
# ══════════════════════════════════════════════════════════════════════════════════════

set -euo pipefail

# ═══════════════════════════════════════════════════════════════════════
# SDK INFO
# ═══════════════════════════════════════════════════════════════════════
SDK_NAME="UNIVERSAL SAMSOFT CAT 'N' CO SDK"
SDK_VERSION="1.0.0"
SDK_CODENAME="Whiskers"
SDK_COPYRIGHT="[C] 2000-2025 SAMSOFT / Team Flames / Flames Co."
SDK_TAGLINE="Purrfectly compiled, every time."

ARCH=$(uname -m)
JOBS=$(sysctl -n hw.ncpu)
AUTO_YES=false; QUIET=false; N64_ONLY=false

for arg in "$@"; do
  case $arg in
    -y|--yes) AUTO_YES=true ;;
    -q|--quiet) QUIET=true ;;
    -n64-only|--n64-only) N64_ONLY=true ;;
  esac
done

# Colors
if $QUIET; then
  R=''; G=''; Y=''; B=''; C=''; M=''; W=''; N=''
else
  R='\033[0;31m'; G='\033[0;32m'; Y='\033[1;33m'; B='\033[0;34m'
  C='\033[0;36m'; M='\033[0;35m'; W='\033[1;37m'; N='\033[0m'
fi

# ═══════════════════════════════════════════════════════════════════════
# HELPERS
# ═══════════════════════════════════════════════════════════════════════
log()  { $QUIET || echo "${G}[✓]${N} $1"; }
info() { $QUIET || echo "${B}  🐾${N} $1"; }
warn() { echo "${Y}[!]${N} $1"; }
err()  { echo "${R}[✗]${N} $1"; }
meow() { $QUIET || echo "${M}[=^.^=]${N} $1"; }

confirm() {
  $AUTO_YES && return 0
  read -q "?    $1 [y/N]: " && echo && return 0
  echo; return 1
}

brew_batch() {
  local missing=()
  for p in "$@"; do brew list "$p" &>/dev/null || missing+=("$p"); done
  [[ ${#missing[@]} -eq 0 ]] && return 0
  info "Installing: ${missing[*]}"
  brew install --quiet "${missing[@]}" 2>/dev/null || true
}

brew_cask_batch() {
  local missing=()
  for p in "$@"; do brew list --cask "$p" &>/dev/null || missing+=("$p"); done
  [[ ${#missing[@]} -eq 0 ]] && return 0
  brew install --quiet --cask "${missing[@]}" 2>/dev/null || true
}

# ═══════════════════════════════════════════════════════════════════════
# BANNER
# ═══════════════════════════════════════════════════════════════════════
$QUIET || cat << 'BANNER'

  ╔══════════════════════════════════════════════════════════════════════════╗
  ║                                                                          ║
  ║   ╦ ╦╔╗╔╦╦  ╦╔═╗╦═╗╔═╗╔═╗╦    ╔═╗╔═╗╔╦╗╔═╗╔═╗╔═╗╔╦╗                      ║
  ║   ║ ║║║║║╚╗╔╝║╣ ╠╦╝╚═╗╠═╣║    ╚═╗╠═╣║║║╚═╗║ ║╠╣  ║                       ║
  ║   ╚═╝╝╚╝╩ ╚╝ ╚═╝╩╚═╚═╝╩ ╩╩═╝  ╚═╝╩ ╩╩ ╩╚═╝╚═╝╚   ╩                       ║
  ║                                                                          ║
  ║            🐱  CAT 'N' CO SDK for Macintosh's  🐱                        ║
  ║                                                                          ║
  ║   ══════════════════════════════════════════════════════════════════    ║
  ║                                                                          ║
  ║        The Ultimate Retro & Modern Compiler Collection                   ║
  ║        1930s Turing Machines  ─────────►  2025 WebAssembly               ║
  ║                                                                          ║
  ║                     /\_/\                                                ║
  ║                    ( o.o )  "Purrfectly compiled, every time."           ║
  ║                     > ^ <                                                ║
  ║                                                                          ║
  ║   ══════════════════════════════════════════════════════════════════    ║
  ║                                                                          ║
  ║        [C] 2000-2025 SAMSOFT / Team Flames / Flames Co.                  ║
  ║        All Rights Reserved. Made with 🐱 in California.                  ║
  ║                                                                          ║
  ╚══════════════════════════════════════════════════════════════════════════╝

BANNER

# ═══════════════════════════════════════════════════════════════════════
# SYSTEM CHECK
# ═══════════════════════════════════════════════════════════════════════
MACOS_VER=$(sw_vers -productVersion)
log "Macintosh System: macOS $MACOS_VER | $ARCH | $JOBS cores"

[[ "$ARCH" == "arm64" ]] && meow "Apple Silicon detected! Maximum purrformance! 🍎" \
                         || info "Intel Macintosh detected"

# Xcode CLT
xcode-select -p &>/dev/null || { warn "Installing Xcode CLT..."; xcode-select --install; exit 1; }

# Homebrew
if ! command -v brew &>/dev/null; then
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  [[ "$ARCH" == "arm64" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi
BREW_PREFIX=$(brew --prefix)

# ═══════════════════════════════════════════════════════════════════════
# N64 TOOLCHAIN
# ═══════════════════════════════════════════════════════════════════════
install_n64() {
  log "Installing N64 libdragon toolchain..."
  
  local LD=/opt/libdragon
  local BASE_URL="https://github.com/DragonMinded/libdragon/releases/download/toolchain-continuous"
  [[ "$ARCH" == "arm64" ]] && local URL="$BASE_URL/gcc-toolchain-mips64-aarch64-apple-darwin.tar.gz" \
                           || local URL="$BASE_URL/gcc-toolchain-mips64-x86_64-apple-darwin.tar.gz"
  
  # Already installed?
  [[ -x "$LD/bin/mips64-elf-gcc" ]] && {
    log "libdragon already installed"
    info "$($LD/bin/mips64-elf-gcc --version | head -1)"
    return 0
  }
  
  # Cleanup failed attempts
  [[ -d "$LD" ]] && sudo rm -rf "$LD"
  rm -rf ~/n64-toolchain-build 2>/dev/null || true
  
  # Download
  log "Downloading prebuilt toolchain..."
  cd /tmp && rm -f ld.tar.gz
  curl -fSL --progress-bar -o ld.tar.gz "$URL" || { err "Download failed"; return 1; }
  
  # Extract
  log "Extracting..."
  sudo mkdir -p "$LD"
  sudo tar -xzf ld.tar.gz -C "$LD" --strip-components=1 2>/dev/null \
    || sudo tar -xzf ld.tar.gz -C "$LD"
  rm -f /tmp/ld.tar.gz
  
  # Verify
  [[ -x "$LD/bin/mips64-elf-gcc" ]] || { err "Install failed"; return 1; }
  log "Installed: $($LD/bin/mips64-elf-gcc --version | head -1)"
  
  # n64-build helper
  sudo tee /usr/local/bin/n64-build >/dev/null << 'SCRIPT'
#!/bin/zsh
# ══════════════════════════════════════════════════════════════════
# 🐱 UNIVERSAL SAMSOFT CAT 'N' CO - N64 Quick Builder
# [C] 2000-2025 SAMSOFT / Team Flames / Flames Co.
# ══════════════════════════════════════════════════════════════════
[[ -z "$1" || -z "$2" ]] && { 
  echo "🎮 n64-build - CAT 'N' CO SDK for Macintosh's"
  echo "   [C] 2000-2025 SAMSOFT"
  echo ""
  echo "Usage: n64-build source.c output.z64"
  exit 1
}
export PATH="/opt/libdragon/bin:$PATH"
mips64-elf-gcc -march=vr4300 -mtune=vr4300 -O2 -G0 \
  -I/opt/libdragon/mips64-elf/include -L/opt/libdragon/mips64-elf/lib \
  "$1" -ldragon -lc -ldragonsys -o /tmp/n64.elf || exit 1
command -v n64tool &>/dev/null && n64tool -l 2M -o "$2" /tmp/n64.elf \
  || mv /tmp/n64.elf "${2%.z64}.elf"
rm -f /tmp/n64.elf
echo "✅ Built: $2"
echo "   [C] 2000-2025 SAMSOFT CAT 'N' CO"
SCRIPT
  sudo chmod +x /usr/local/bin/n64-build
  
  # Sample project
  [[ -d ~/n64-catco-sample ]] || {
    mkdir -p ~/n64-catco-sample
    cat > ~/n64-catco-sample/main.c << 'SRC'
/*
 * ══════════════════════════════════════════════════════════════════
 * 🐱 UNIVERSAL SAMSOFT CAT 'N' CO SDK - N64 Sample
 * [C] 2000-2025 SAMSOFT / Team Flames / Flames Co.
 * ══════════════════════════════════════════════════════════════════
 */
#include <stdio.h>
#include <libdragon.h>

int main(void) {
    display_init(RESOLUTION_320x240, DEPTH_16_BPP, 2, GAMMA_NONE, FILTERS_RESAMPLE);
    console_init();
    console_set_render_mode(RENDER_MANUAL);
    controller_init();
    
    printf("\n");
    printf("  ╔═══════════════════════════════════════════╗\n");
    printf("  ║                                           ║\n");
    printf("  ║   UNIVERSAL SAMSOFT CAT 'N' CO SDK       ║\n");
    printf("  ║   [C] 2000-2025 SAMSOFT                  ║\n");
    printf("  ║                                           ║\n");
    printf("  ║      /\\_/\\   Hello Nintendo 64!         ║\n");
    printf("  ║     ( o.o )                              ║\n");
    printf("  ║      > ^ <   Press START to exit        ║\n");
    printf("  ║                                           ║\n");
    printf("  ╚═══════════════════════════════════════════╝\n");
    printf("\n");
    printf("  \"Purrfectly compiled, every time.\"\n");
    
    while(1) {
        console_render();
        controller_scan();
        if(get_keys_down().c[0].start) break;
    }
    return 0;
}
SRC
    cat > ~/n64-catco-sample/Makefile << 'MK'
# ══════════════════════════════════════════════════════════════════
# 🐱 UNIVERSAL SAMSOFT CAT 'N' CO SDK - N64 Makefile
# [C] 2000-2025 SAMSOFT / Team Flames / Flames Co.
# ══════════════════════════════════════════════════════════════════
N64_INST ?= /opt/libdragon
include $(N64_INST)/include/n64.mk

all: main.z64

main.z64: main.c
	@echo "══════════════════════════════════════════════════════════"
	@echo "🐱 UNIVERSAL SAMSOFT CAT 'N' CO SDK - Building N64 ROM..."
	@echo "══════════════════════════════════════════════════════════"
	@$(N64_CC) $(N64_CFLAGS) -o main.elf $<
	@$(N64_OBJCOPY) -O binary main.elf main.bin
	@$(N64_TOOL) -l 2M -t "CAT N CO" -o $@ main.bin
	@rm -f main.elf main.bin
	@echo "✅ Built: $@"
	@echo "[C] 2000-2025 SAMSOFT / Team Flames"

clean:
	@rm -f *.z64 *.elf *.bin

.PHONY: all clean
MK
    info "Sample project: ~/n64-catco-sample"
  }
  meow "N64 ready! Let's-a go! 🐲"
}

$N64_ONLY && { install_n64; exit 0; }

# ═══════════════════════════════════════════════════════════════════════
# FULL INSTALL
# ═══════════════════════════════════════════════════════════════════════

log "Updating Homebrew..."
brew update -q 2>/dev/null || true

# ── BUILD ESSENTIALS ──
log "Installing build essentials..."
brew_batch wget curl cmake make autoconf automake bison flex \
           gmp mpfr libmpc texinfo xz pkg-config libtool coreutils

# ── HISTORICAL (1930s-1970s) ──
log "Installing historical simulators..."
brew_batch open-simh hercules spim haskell-stack
pip3 install -q --break-system-packages turing-machine 2>/dev/null || true
meow "Mainframes online! 🖥️"

# ── RETRO 8-BIT (1970s-1980s) ──
log "Installing 8-bit toolchains..."
brew_batch cc65 rgbds acme dasm xa
brew install z88dk 2>/dev/null || true
brew install wla-dx 2>/dev/null || true
meow "8-bit dreams loaded! 💾"

# ── DEVKITPRO (GBA → Switch) ──
log "Installing devkitPro..."
if ! command -v dkp-pacman &>/dev/null; then
  cd /tmp
  curl -fsSLO "https://github.com/devkitPro/pacman/releases/latest/download/devkitpro-pacman-installer.pkg" && {
    sudo installer -pkg devkitpro-pacman-installer.pkg -target / 2>/dev/null
    rm -f devkitpro-pacman-installer.pkg
  } || warn "devkitPro download failed"
fi

command -v dkp-pacman &>/dev/null && {
  sudo dkp-pacman -Syu --noconfirm 2>/dev/null || true
  for pkg in gba-dev nds-dev 3ds-dev switch-dev wii-dev gamecube-dev; do
    sudo dkp-pacman -S --noconfirm --needed $pkg 2>/dev/null || true
  done
}
meow "Nintendo conquered! 👑"

# ── N64 ──
install_n64

# ── MODERN COMPILERS ──
log "Installing modern compilers..."
brew_batch gcc llvm rust go zig nasm yasm node python@3.12 openjdk
brew_batch emscripten wasm-pack binaryen
brew install fpc mono dotnet 2>/dev/null || true
sudo ln -sfn "$BREW_PREFIX/opt/openjdk/libexec/openjdk.jdk" \
  /Library/Java/JavaVirtualMachines/openjdk.jdk 2>/dev/null || true
meow "Modern compilers ready! 🚀"

# ── EMULATORS (OPTIONAL) ──
confirm "Install emulators (OpenEmu, RetroArch, MAME)?" && {
  log "Installing emulators..."
  brew_cask_batch openemu retroarch
  brew_batch mame mednafen
}

# ── SHELL CONFIG ──
log "Configuring shell..."
RC="$HOME/.zshrc"
grep -v -E "(CATSDK|CAT.*CO|SAMSOFT|libdragon|DEVKITPRO|N64_INST)" "$RC" > "$RC.tmp" 2>/dev/null && mv "$RC.tmp" "$RC"

cat >> "$RC" << 'ENV'

# ══════════════════════════════════════════════════════════════════════════════
# 🐱 UNIVERSAL SAMSOFT CAT 'N' CO SDK for Macintosh's
# [C] 2000-2025 SAMSOFT / Team Flames / Flames Co.
# ══════════════════════════════════════════════════════════════════════════════
export DEVKITPRO=/opt/devkitpro DEVKITARM=$DEVKITPRO/devkitARM
export DEVKITPPC=$DEVKITPRO/devkitPPC DEVKITA64=$DEVKITPRO/devkitA64
export N64_INST=/opt/libdragon LIBDRAGON=/opt/libdragon
export PS2DEV=/usr/local/ps2dev PS2SDK=$PS2DEV/ps2sdk
[ -d "$DEVKITPRO" ] && PATH=$DEVKITPRO/tools/bin:$PATH
[ -d "$LIBDRAGON/bin" ] && PATH=$LIBDRAGON/bin:$PATH
[ -d "/opt/gbdk/bin" ] && PATH=/opt/gbdk/bin:$PATH
# ══════════════════════════════════════════════════════════════════════════════
ENV

# ── VERIFY ──
log "Verifying installation..."
echo ""
for cmd in cc65 rgbasm mips64-elf-gcc rustc go zig nasm node; do
  command -v $cmd &>/dev/null && echo "${G}✓${N} $cmd" || echo "${Y}○${N} $cmd"
done
[[ -d /opt/devkitpro/devkitARM ]] && echo "${G}✓${N} devkitARM"
[[ -x /opt/libdragon/bin/mips64-elf-gcc ]] && echo "${G}✓${N} libdragon"

# ═══════════════════════════════════════════════════════════════════════
# COMPLETE
# ═══════════════════════════════════════════════════════════════════════
$QUIET || cat << EOF

${G}══════════════════════════════════════════════════════════════════════════${N}

   ${W}╦ ╦╔╗╔╦╦  ╦╔═╗╦═╗╔═╗╔═╗╦    ╔═╗╔═╗╔╦╗╔═╗╔═╗╔═╗╔╦╗${N}
   ${W}║ ║║║║║╚╗╔╝║╣ ╠╦╝╚═╗╠═╣║    ╚═╗╠═╣║║║╚═╗║ ║╠╣  ║${N}
   ${W}╚═╝╝╚╝╩ ╚╝ ╚═╝╩╚═╚═╝╩ ╩╩═╝  ╚═╝╩ ╩╩ ╩╚═╝╚═╝╚   ╩${N}

           ${M}/\\_/\\${N}   ${Y}🐱 CAT 'N' CO SDK for Macintosh's${N}
           ${M}( o.o )${N}  ${C}Version ${SDK_VERSION} - Codename "${SDK_CODENAME}"${N}
           ${M} > ^ <${N}   ${W}Installation Complete!${N}

${G}══════════════════════════════════════════════════════════════════════════${N}

   ${W}Next steps:${N}
   ${G}1.${N} source ~/.zshrc
   ${G}2.${N} cd ~/n64-catco-sample && make
   ${G}3.${N} Test your ROM in an emulator!

   ${C}Quick commands:${N}
   • ${G}n64-build${N} src.c out.z64  - Build N64 ROM
   • ${G}cc65${N} -t nes game.c       - Build NES ROM  
   • ${G}rgbasm${N} game.asm          - Build Game Boy ROM

${G}══════════════════════════════════════════════════════════════════════════${N}

   ${M}"${SDK_TAGLINE}"${N}

   ${B}${SDK_COPYRIGHT}${N}
   ${B}All Rights Reserved. Made with 🐱 in California.${N}

${G}══════════════════════════════════════════════════════════════════════════${N}

EOF
