#!/usr/bin/env bash
set -e

# -----------------------------
# CONFIG (CLI overridable)
# -----------------------------
ENABLE_GUI=true
ENABLE_BROWSER=false
ENABLE_DOCKER=true
ENABLE_K8S=true
ENABLE_TERRAFORM=true
ENABLE_VAGRANT=false

for arg in "$@"; do
  case $arg in
    --no-gui) ENABLE_GUI=false ;;
    --browser) ENABLE_BROWSER=true ;;
    --no-docker) ENABLE_DOCKER=false ;;
    --no-k8s) ENABLE_K8S=false ;;
    --no-terraform) ENABLE_TERRAFORM=false ;;
    --vagrant) ENABLE_VAGRANT=true ;;
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
  echo "sudo ./bootstrap.sh"
  exit 1
fi

# -----------------------------
# INSTALL BASE PACKAGES
# -----------------------------
step "Installing base packages..."

if [ -f /etc/debian_version ]; then
  apt update
  apt install -y curl wget git unzip tar jq ripgrep fd-find neovim htop
elif [ -f /etc/redhat-release ]; then
  dnf install -y curl wget git unzip tar jq ripgrep fd neovim htop
elif [ -f /etc/arch-release ]; then
  pacman -Sy --noconfirm curl wget git unzip tar jq ripgrep fd neovim htop
elif [ -f /etc/alpine-release ]; then
  apk add curl wget git unzip tar jq neovim htop
else
  echo "Unsupported distro"
  exit 1
fi

ok "Base ready"

# -----------------------------
# GUI (i3 + LightDM)
# -----------------------------
if [ "$ENABLE_GUI" = true ]; then
step "Installing i3 + LightDM..."

if [ -f /etc/debian_version ]; then
  apt install -y i3 xorg lightdm lightdm-gtk-greeter dmenu feh fonts-dejavu kitty
elif [ -f /etc/redhat-release ]; then
  dnf install -y i3 xorg-x11-server-Xorg lightdm lightdm-gtk dmenu feh kitty
elif [ -f /etc/arch-release ]; then
  pacman -Sy --noconfirm i3 xorg-server lightdm lightdm-gtk-greeter dmenu feh kitty
fi

# wallpaper
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

# user config
sudo -u "$USER_NAME" mkdir -p "$HOME_DIR/.config/i3" "$HOME_DIR/.config/kitty"

cat > "$HOME_DIR/.config/i3/config" <<EOF
exec_always feh --bg-scale /usr/share/backgrounds/nord.png
EOF

cat > "$HOME_DIR/.config/kitty/kitty.conf" <<EOF
background #2E3440
foreground #D8DEE9
EOF

chown -R "$USER_NAME":"$USER_NAME" "$HOME_DIR/.config"

ok "GUI ready"
fi

# -----------------------------
# BROWSER
# -----------------------------
if [ "$ENABLE_BROWSER" = true ]; then
step "Installing browser..."
if [ -f /etc/debian_version ]; then
  apt install -y falkon || apt install -y firefox
elif [ -f /etc/redhat-release ]; then
  dnf install -y falkon || dnf install -y firefox
fi
ok "Browser ready"
fi

# -----------------------------
# DOCKER
# -----------------------------
if [ "$ENABLE_DOCKER" = true ]; then
step "Installing Docker..."
curl -fsSL https://get.docker.com | sh
systemctl enable docker
systemctl start docker
usermod -aG docker "$USER_NAME"
ok "Docker ready"
fi

# -----------------------------
# KUBERNETES TOOLS
# -----------------------------
if [ "$ENABLE_K8S" = true ]; then
step "Installing Kubernetes tools..."

curl -LO https://dl.k8s.io/release/v1.29.0/bin/linux/amd64/kubectl
install -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

curl -L https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz \
| tar xz -C /usr/local/bin

ok "Kubernetes tools ready"
fi

# -----------------------------
# TERRAFORM
# -----------------------------
if [ "$ENABLE_TERRAFORM" = true ]; then
step "Installing Terraform..."

curl -LO https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip
unzip terraform_*.zip
mv terraform /usr/local/bin/
rm terraform_*.zip

ok "Terraform ready"
fi

# -----------------------------
# VAGRANT
# -----------------------------
if [ "$ENABLE_VAGRANT" = true ]; then
step "Installing Vagrant..."

curl -LO https://releases.hashicorp.com/vagrant/2.4.0/vagrant_2.4.0_linux_amd64.zip
unzip vagrant_*.zip
mv vagrant /usr/local/bin/
rm vagrant_*.zip

ok "Vagrant ready"
fi

# -----------------------------
# DONE
# -----------------------------
echo ""
ok "ALL DONE 🎉"
echo ""
echo "Next:"
echo "- Reboot: sudo reboot"
echo "- Select i3 in LightDM"
echo "- Re-login for Docker group"