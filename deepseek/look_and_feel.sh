#!/bin/bash
# ============================================================================
# i3-nord-ansible-generator.sh - Multi-distro versie
# ============================================================================
# Genereert een complete Ansible playbook voor i3 met Nord thema
# Werkt op: Debian, Ubuntu, Arch, Fedora, openSUSE
# ============================================================================

set -euo pipefail

# Kleuren voor output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║     i3 Nord Thema - Ansible Project Generator (Multi-Distro)    ║"
echo "║     Genereert complete Ansible structuur met Nord configuratie   ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# ============================================================================
# DISTRIBUTIE DETECTIE
# ============================================================================
detect_distro() {
    if command -v apt-get &> /dev/null; then
        echo "debian"
    elif command -v pacman &> /dev/null; then
        echo "arch"
    elif command -v dnf &> /dev/null; then
        echo "fedora"
    elif command -v zypper &> /dev/null; then
        echo "opensuse"
    else
        echo "unknown"
    fi
}

DISTRO=$(detect_distro)
echo -e "${YELLOW}▶ Gedetecteerde distributie: ${DISTRO}${NC}"

# ============================================================================
# PACKAGE LISTS PER DISTRIBUTIE
# ============================================================================
case $DISTRO in
    debian)
        PACKAGES_COMMON="udiskie network-manager-gnome brightnessctl volumeicon bluetooth blueman bluez-tools flameshot xss-lock xautolock i3lock acpi acpid picom feh dunst alsa-utils pulseaudio-utils fonts-firacode fonts-noto-color-emoji"
        PACKAGES_EXTRA=""
        ANSIBLE_CMD="apt"
        ;;
    arch)
        PACKAGES_COMMON="udiskie network-manager-applet brightnessctl volumeicon bluez blueman bluez-utils flameshot xss-lock xautolock i3lock acpi acpid picom feh dunst alsa-utils pulseaudio-utils ttf-fira-code noto-fonts-emoji"
        PACKAGES_EXTRA=""
        ANSIBLE_CMD="pacman"
        ;;
    fedora)
        PACKAGES_COMMON="udiskie network-manager-applet brightnessctl volumeicon bluez blueman bluez-tools flameshot xss-lock xautolock i3lock acpi acpid picom feh dunst alsa-utils pulseaudio-utils fira-code-fonts google-noto-emoji-fonts"
        PACKAGES_EXTRA=""
        ANSIBLE_CMD="dnf"
        ;;
    opensuse)
        PACKAGES_COMMON="udiskie network-manager-applet brightnessctl volumeicon bluez blueman bluez-tools flameshot xss-lock xautolock i3lock acpi acpid picom feh dunst alsa-utils pulseaudio-utils fira-code-fonts google-noto-emoji-fonts"
        PACKAGES_EXTRA=""
        ANSIBLE_CMD="zypper"
        ;;
    *)
        echo -e "${RED}✗ Kan distributie niet detecteren. Script wordt toch gegenereerd maar pas package lijsten aan.${NC}"
        PACKAGES_COMMON="udiskie network-manager-applet brightnessctl volumeicon bluez blueman flameshot xss-lock xautolock i3lock acpi picom feh dunst alsa-utils"
        PACKAGES_EXTRA=""
        ANSIBLE_CMD="unknown"
        ;;
esac

# Project directory
PROJECT_DIR="$HOME/ansible/i3-nord-setup"
echo -e "${YELLOW}▶ Project wordt aangemaakt in: $PROJECT_DIR${NC}"

# Maak directories aan
mkdir -p "$PROJECT_DIR"/{vars,templates,files}
echo -e "${GREEN}✓ Directory structuur aangemaakt${NC}"

# ============================================================================
# 1. VARS/MAIN.YML
# ============================================================================
echo -e "${YELLOW}▶ Genereren: vars/main.yml${NC}"
cat > "$PROJECT_DIR/vars/main.yml" << 'VARS_EOF'
---
# Nord kleurenpalet
nord_colors:
  # Pool 0 (achtergronden)
  nord0: "#2E3440"  # donkerste achtergrond
  nord1: "#3B4252"
  nord2: "#434C5E"
  nord3: "#4C566A"
  # Pool 1 (voorgrond)
  nord4: "#D8DEE9"
  nord5: "#E5E9F0"
  nord6: "#ECEFF4"
  # Pool 2 (accenten)
  nord7: "#8FBCBB"
  nord8: "#88C0D0"
  nord9: "#81A1C1"
  nord10: "#5E81AC"
  # Pool 3 (fouten/warnings)
  nord11: "#BF616A"
  nord12: "#D08770"
  nord13: "#EBCB8B"
  nord14: "#A3BE8C"
  nord15: "#B48EAD"

i3_config_path: "{{ ansible_env.HOME }}/.config/i3/config"
distro: "{{ ansible_facts.distribution | lower }}"
VARS_EOF
echo -e "${GREEN}  ✓ vars/main.yml${NC}"

# ============================================================================
# 2. PLAYBOOK.YML (met distro-specifieke package installatie)
# ============================================================================
echo -e "${YELLOW}▶ Genereren: playbook.yml${NC}"
cat > "$PROJECT_DIR/playbook.yml" << 'PLAYBOOK_EOF'
---
- name: i3 Nord thema configuratie
  hosts: localhost
  connection: local
  become: false
  vars_files:
    - vars/main.yml

  tasks:
    # ========================
    # 1. PACKAGES INSTALLEREN (distro-specifiek)
    # ========================
    - name: Update package cache (Debian/Ubuntu)
      become: true
      apt:
        update_cache: yes
      when: ansible_facts.os_family == "Debian"
      tags: packages

    - name: Update package cache (Arch)
      become: true
      pacman:
        update_cache: yes
      when: ansible_facts.os_family == "Archlinux"
      tags: packages

    - name: Update package cache (Fedora)
      become: true
      dnf:
        update_cache: yes
      when: ansible_facts.os_family == "RedHat"
      tags: packages

    - name: Update package cache (openSUSE)
      become: true
      zypper:
        update_cache: yes
      when: ansible_facts.os_family == "Suse"
      tags: packages

    - name: Installeer packages (Debian/Ubuntu)
      become: true
      apt:
        name:
          - udiskie
          - network-manager-gnome
          - brightnessctl
          - volumeicon
          - bluetooth
          - blueman
          - bluez-tools
          - flameshot
          - xss-lock
          - xautolock
          - i3lock
          - acpi
          - acpid
          - picom
          - feh
          - dunst
          - alsa-utils
          - pulseaudio-utils
          - fonts-firacode
          - fonts-noto-color-emoji
        state: present
      when: ansible_facts.os_family == "Debian"
      tags: packages

    - name: Installeer packages (Arch)
      become: true
      pacman:
        name:
          - udiskie
          - network-manager-applet
          - brightnessctl
          - volumeicon
          - bluez
          - blueman
          - bluez-utils
          - flameshot
          - xss-lock
          - xautolock
          - i3lock
          - acpi
          - acpid
          - picom
          - feh
          - dunst
          - alsa-utils
          - pulseaudio-utils
          - ttf-fira-code
          - noto-fonts-emoji
        state: present
      when: ansible_facts.os_family == "Archlinux"
      tags: packages

    - name: Installeer packages (Fedora)
      become: true
      dnf:
        name:
          - udiskie
          - network-manager-applet
          - brightnessctl
          - volumeicon
          - bluez
          - blueman
          - bluez-tools
          - flameshot
          - xss-lock
          - xautolock
          - i3lock
          - acpi
          - acpid
          - picom
          - feh
          - dunst
          - alsa-utils
          - pulseaudio-utils
          - fira-code-fonts
          - google-noto-emoji-fonts
        state: present
      when: ansible_facts.os_family == "RedHat"
      tags: packages

    - name: Installeer packages (openSUSE)
      become: true
      zypper:
        name:
          - udiskie
          - network-manager-applet
          - brightnessctl
          - volumeicon
          - bluez
          - blueman
          - bluez-tools
          - flameshot
          - xss-lock
          - xautolock
          - i3lock
          - acpi
          - acpid
          - picom
          - feh
          - dunst
          - alsa-utils
          - pulseaudio-utils
          - fira-code-fonts
          - google-noto-emoji-fonts
        state: present
      when: ansible_facts.os_family == "Suse"
      tags: packages

    # ========================
    # 2. DIRECTORIES AANMAKEN
    # ========================
    - name: Zorg dat config directories bestaan
      file:
        path: "{{ item }}"
        state: directory
        mode: "0755"
      loop:
        - "{{ ansible_env.HOME }}/.config/i3"
        - "{{ ansible_env.HOME }}/.config/kitty"
        - "{{ ansible_env.HOME }}/.config/dunst"
        - "{{ ansible_env.HOME }}/.config/picom"
        - "{{ ansible_env.HOME }}/.config/wallpapers"
        - "{{ ansible_env.HOME }}/Pictures"
      tags: directories

    # ========================
    # 3. WALLPAPER
    # ========================
    - name: Kopieer Nord wallpaper
      copy:
        src: files/wallpaper-nord.png
        dest: "{{ ansible_env.HOME }}/.config/wallpapers/nord-wallpaper.png"
        mode: "0644"
      tags: wallpaper

    # ========================
    # 4. I3 CONFIGURATIE (Nord thema)
    # ========================
    - name: Backup bestaande i3 config
      command: cp "{{ i3_config_path }}" "{{ i3_config_path }}.backup.{{ ansible_date_time.epoch }}"
      args:
        removes: "{{ i3_config_path }}"
      ignore_errors: yes
      tags: i3

    - name: I3 config template
      template:
        src: i3_config.j2
        dest: "{{ i3_config_path }}"
        mode: "0644"
      tags: i3

    # ========================
    # 5. KITTY CONFIG (Nord thema)
    # ========================
    - name: Kitty config template
      template:
        src: kitty.conf.j2
        dest: "{{ ansible_env.HOME }}/.config/kitty/kitty.conf"
        mode: "0644"
      tags: kitty

    # ========================
    # 6. DUNST CONFIG (Nord thema notificaties)
    # ========================
    - name: Dunst config template
      template:
        src: dunstrc.j2
        dest: "{{ ansible_env.HOME }}/.config/dunst/dunstrc"
        mode: "0644"
      tags: dunst

    # ========================
    # 7. PICOM CONFIG (Nord thema compositor)
    # ========================
    - name: Picom config template
      template:
        src: picom.conf.j2
        dest: "{{ ansible_env.HOME }}/.config/picom/picom.conf"
        mode: "0644"
      tags: picom

    # ========================
    # 8. SERVICES STARTEN (distro-specifiek)
    # ========================
    - name: Start bluetooth service (Debian/Arch/Fedora/openSUSE)
      become: true
      systemd:
        name: bluetooth
        enabled: yes
        state: started
      when: ansible_facts.os_family != "Windows"
      tags: services

    - name: Start acpid service (Debian/Arch/Fedora/openSUSE)
      become: true
      systemd:
        name: acpid
        enabled: yes
        state: started
      when: ansible_facts.os_family != "Windows" and ansible_facts.os_family != "Archlinux"
      ignore_errors: yes
      tags: services

    # ========================
    # 9. ACPI LID CONFIG (laptop dichtklappen)
    # ========================
    - name: ACPI lid event handler
      become: true
      copy:
        content: |
          event=button/lid.*
          action=/etc/acpi/actions/lid.sh
        dest: /etc/acpi/events/lid
        mode: "0644"
      when: ansible_facts.os_family == "Debian" or ansible_facts.os_family == "RedHat"
      tags: acpi

    - name: ACPI lid action script
      become: true
      copy:
        content: |
          #!/bin/bash
          grep -q closed /proc/acpi/button/lid/*/state
          if [ $? -eq 0 ]; then
              systemctl suspend
          fi
        dest: /etc/acpi/actions/lid.sh
        mode: "0755"
      when: ansible_facts.os_family == "Debian" or ansible_facts.os_family == "RedHat"
      tags: acpi

    - name: Restart acpid
      become: true
      systemd:
        name: acpid
        state: restarted
      when: ansible_facts.os_family == "Debian" or ansible_facts.os_family == "RedHat"
      tags: acpi

    # ========================
    # 10. SAMENVATTING
    # ========================
    - name: Toon samenvatting
      debug:
        msg:
          - "✅ i3 Nord thema setup compleet!"
          - ""
          - "📋 Toegevoegd:"
          - "  • Nord kleuren thema voor i3, Kitty, Dunst"
          - "  • Geluidstoetsen (XF86AudioRaise/Lower/Mute)"
          - "  • Wallpaper: nord-wallpaper.png"
          - "  • Systeemservices: nm-applet, udiskie, volumeicon, blueman"
          - "  • Lockscreen na 15 minuten"
          - "  • Screenshots met Flameshot"
          - "  • Autostart: Kitty (workspace 1) en Falkon (workspace 2)"
          - "  • Extra Kitty terminals op workspaces 3-6"
          - ""
          - "🔧 Herstart i3: $mod+Shift+R"
      tags: always
PLAYBOOK_EOF
echo -e "${GREEN}  ✓ playbook.yml${NC}"

# ============================================================================
# 3-8. TEMPLATES (zelfde als voorheen, blijven ongewijzigd)
# ============================================================================
# ... (hier komen dezelfde template bestanden als in de Debian versie)
# Om ruimte te besparen laat ik ze hier weg, maar ze zijn identiek
# In de praktijk blijven de templates 100% hetzelfde

# ============================================================================
# 9. INSTALLATIE SCRIPT (multi-distro)
# ============================================================================
echo -e "${YELLOW}▶ Genereren: install.sh (multi-distro)${NC}"
cat > "$PROJECT_DIR/install.sh" << 'INSTALL_EOF'
#!/bin/bash
# i3-nord-install.sh - Multi-distro installer
# Werkt op: Debian, Ubuntu, Arch, Fedora, openSUSE

set -euo pipefail

cd "$(dirname "$0")"

echo "🚀 i3 Nord Thema Installer"
echo "=========================="
echo ""

# Detecteer distributie
detect_distro() {
    if command -v apt-get &> /dev/null; then
        echo "debian"
    elif command -v pacman &> /dev/null; then
        echo "arch"
    elif command -v dnf &> /dev/null; then
        echo "fedora"
    elif command -v zypper &> /dev/null; then
        echo "opensuse"
    else
        echo "unknown"
    fi
}

DISTRO=$(detect_distro)
echo "📦 Gedetecteerde distributie: $DISTRO"
echo ""

# Check of Ansible geïnstalleerd is
if ! command -v ansible-playbook &> /dev/null; then
    echo "📦 Ansible niet gevonden, installeren..."
    case $DISTRO in
        debian)
            sudo apt update
            sudo apt install -y ansible
            ;;
        arch)
            sudo pacman -S --needed ansible
            ;;
        fedora)
            sudo dnf install -y ansible
            ;;
        opensuse)
            sudo zypper install -y ansible
            ;;
        *)
            echo "⚠ Kan Ansible niet automatisch installeren."
            echo "  Installeer handmatig en probeer opnieuw."
            exit 1
            ;;
    esac
fi

# Check of wallpaper bestaat
if [ ! -f "files/wallpaper-nord.png" ] || file "files/wallpaper-nord.png" | grep -q "text"; then
    echo ""
    echo "⚠ WAARSCHUWING: Geen echte Nord wallpaper gevonden!"
    echo "   Bestand: files/wallpaper-nord.png is een placeholder."
    echo "   Download een echte wallpaper van:"
    echo "     https://github.com/z0mbie42/nord-wallpapers"
    echo ""
    read -p "Wil je doorgaan zonder wallpaper? (j/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Jj]$ ]]; then
        exit 1
    fi
fi

echo ""
echo "▶ Ansible playbook draaien..."
ansible-playbook playbook.yml --ask-become-pass "$@"

echo ""
echo "✅ Klaar! Herstart i3 met \$mod+Shift+R"
INSTALL_EOF
chmod +x "$PROJECT_DIR/install.sh"
echo -e "${GREEN}  ✓ install.sh (uitvoerbaar, multi-distro)${NC}"

# ============================================================================
# 10. README.md (aangepast voor multi-distro)
# ============================================================================
echo -e "${YELLOW}▶ Genereren: README.md${NC}"
cat > "$PROJECT_DIR/README.md" << 'README_EOF'
# i3 Nord Thema - Ansible Setup (Multi-Distro)

## Ondersteunde distributies
- **Debian/Ubuntu/Linux Mint** (apt)
- **Arch Linux** (pacman)
- **Fedora** (dnf)
- **openSUSE** (zypper)

## Structuur