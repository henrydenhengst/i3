#!/usr/bin/env bash
set -e

# -----------------------------
# CONFIG
# -----------------------------
ENABLE_GUI=true
ENABLE_BROWSER=false
ENABLE_DEV_TOOLS=false   # lichte dev tools (git, nvim etc.)
ENABLE_EXTRA=false       # optionele extras (fzf, bat etc.)

for arg in "$@"; do
  case $arg in
    --no-gui) ENABLE_GUI=false ;;
    --browser) ENABLE_BROWSER=true ;;
    --dev) ENABLE_DEV_TOOLS=true ;;
    --extra) ENABLE_EXTRA=true ;;
  esac
done

USER_NAME="${SUDO_USER:-$USER}"
HOME_DIR=$(eval echo "~$USER_NAME")

step() { echo -e "\n\033[1;34m==>\033[0m $1"; }
ok()   { echo -e "\033[1;32m✔\033[0m $1"; }

# -----------------------------
# ROOT CHECK
# -----------------------------
if [ "$EUID" -ne 0 ]; then
  echo "Run with sudo:"
  echo "sudo ./bootstrap-lite.sh"
  exit 1
fi

# -----------------------------
# BASE (ultra minimal)
# -----------------------------
step "Installing minimal base..."

if [ -f /etc/debian_version ]; then
  apt update
  apt install -y curl wget
elif [ -f /etc/redhat-release ]; then
  dnf install -y curl wget
elif [ -f /etc/arch-release ]; then
  pacman -Sy --noconfirm curl wget
elif [ -f /etc/alpine-release ]; then
  apk add curl wget
fi

ok "Base ready"

# -----------------------------
# OPTIONAL DEV TOOLS
# -----------------------------
if [ "$ENABLE_DEV_TOOLS" = true ]; then
step "Installing dev tools..."

if [ -f /etc/debian_version ]; then
  apt install -y git neovim ripgrep fd-find htop
elif [ -f /etc/redhat-release ]; then
  dnf install -y git neovim ripgrep fd htop
elif [ -f /etc/arch-release ]; then
  pacman -Sy --noconfirm git neovim ripgrep fd htop
fi

ok "Dev tools ready"
fi

# -----------------------------
# GUI (lightweight i3)
# -----------------------------
if [ "$ENABLE_GUI" = true ]; then
step "Installing lightweight i3..."

if [ -f /etc/debian_version ]; then
  apt install -y i3 xorg lightdm lightdm-gtk-greeter dmenu feh kitty
elif [ -f /etc/redhat-release ]; then
  dnf install -y i3 xorg-x11-server-Xorg lightdm lightdm-gtk dmenu feh kitty
elif [ -f /etc/arch-release ]; then
  pacman -Sy --noconfirm i3 xorg-server lightdm lightdm-gtk-greeter dmenu feh kitty
fi

# wallpaper (lichtgewicht alternatief mogelijk)
mkdir -p /usr/share/backgrounds
curl -L -o /usr/share/backgrounds/nord.png \
https://raw.githubusercontent.com/arcticicestudio/nord-wallpapers/master/wallpapers/ign_astronaut.png

# lightdm config
cat > /etc/lightdm/lightdm.conf <<EOF
[Seat:*]
user-session=i3
greeter-session=lightdm-gtk-greeter
EOF

cat > /etc/lightdm/lightdm-gtk-greeter.conf <<EOF
[greeter]
theme-name=Adwaita-dark
background=/usr/share/backgrounds/nord.png
EOF

systemctl enable lightdm
systemctl start lightdm

# i3 config (extra minimal)
sudo -u "$USER_NAME" mkdir -p "$HOME_DIR/.config/i3" "$HOME_DIR/.config/kitty"

cat > "$HOME_DIR/.config/i3/config" <<EOF
set \$mod Mod4
exec_always feh --bg-scale /usr/share/backgrounds/nord.png
bindsym \$mod+Return exec kitty
bindsym \$mod+d exec dmenu_run
EOF

cat > "$HOME_DIR/.config/kitty/kitty.conf" <<EOF
background #2E3440
foreground #D8DEE9
EOF

chown -R "$USER_NAME":"$USER_NAME" "$HOME_DIR/.config"

ok "GUI ready"
fi

# -----------------------------
# BROWSER (optioneel)
# -----------------------------
if [ "$ENABLE_BROWSER" = true ]; then
step "Installing lightweight browser..."

if [ -f /etc/debian_version ]; then
  apt install -y falkon || apt install -y firefox-esr
elif [ -f /etc/redhat-release ]; then
  dnf install -y falkon || dnf install -y firefox
fi

ok "Browser ready"
fi

# -----------------------------
# EXTRA CLI GOODIES
# -----------------------------
if [ "$ENABLE_EXTRA" = true ]; then
step "Installing extras..."

if [ -f /etc/debian_version ]; then
  apt install -y fzf bat
elif [ -f /etc/redhat-release ]; then
  dnf install -y fzf bat
elif [ -f /etc/arch-release ]; then
  pacman -Sy --noconfirm fzf bat
fi

ok "Extras ready"
fi

# -----------------------------
# DONE
# -----------------------------
echo ""
ok "LIGHTWEIGHT SETUP DONE ⚡"
echo ""
echo "Tips:"
echo "- Reboot: sudo reboot"
echo "- Super+Enter = terminal"
echo "- Super+D = launcher"