cat << 'EOF' > /tmp/create-nord-i3-ultimate.sh
#!/bin/bash
# === ULTIMATE Nord i3 Setup 2026 - Alles geïntegreerd (look & feel + gemak) ===
set -e

DIR="nord-i3-ultimate"
echo "🚀 Aanmaken van de ULTIMATE Nord i3 setup (alles-in-één) in: $DIR"

rm -rf $DIR 2>/dev/null || true
mkdir -p $DIR/{group_vars,roles/{common,gui,theme,cli}/tasks,roles/{gui,theme}/templates}

cd $DIR

# === group_vars/all.yml - Centrale configuratie ===
cat << 'VARS' > group_vars/all.yml
---
# Feature flags
enable_gui: true
enable_browser: true
enable_docker: true
enable_rofi: true
enable_zsh_starship: true

username: "{{ ansible_user_id | default(ansible_user) }}"
wallpaper_url: "https://raw.githubusercontent.com/linuxdotexe/nordic-wallpapers/master/wallpapers/ign_unsplash4.png"
wallpaper_dest: "/usr/share/backgrounds/nord-wallpaper.png"

# Look & Feel
font: "DejaVu Sans Mono 10"
gap_size: 10
terminal: "kitty"
VARS

# === playbook.yml ===
cat << 'PLAY' > playbook.yml
---
- name: Nord i3 Ultimate - Geïntegreerde mooie setup
  hosts: all
  become: true
  vars_files:
    - group_vars/all.yml

  roles:
    - common
    - { role: gui, when: enable_gui | bool }
    - { role: theme, when: enable_gui | bool }
    - cli
PLAY

# === common ===
cat << 'COMMON' > roles/common/tasks/main.yml
---
- name: OS detectie
  set_fact:
    is_alpine: "{{ ansible_distribution == 'Alpine' }}"
    os_family: "{{ ansible_os_family }}"
COMMON

# === gui (LightDM + Rofi) ===
cat << 'GUI' > roles/gui/tasks/main.yml
---
- name: GUI + Rofi pakketten
  package:
    name:
      - i3
      - lightdm
      - lightdm-gtk-greeter
      - kitty
      - rofi
      - feh
      - xorg
    state: present
  when: not is_alpine

- name: Browser
  package:
    name: "{{ 'falkon' if ansible_distribution != 'Alpine' else 'firefox' }}"
    state: present
  when: enable_browser | bool

- name: LightDM configuratie
  template:
    src: lightdm.conf.j2
    dest: /etc/lightdm/lightdm.conf
    mode: '0644'

- name: LightDM greeter met wallpaper
  template:
    src: lightdm-gtk-greeter.conf.j2
    dest: /etc/lightdm/lightdm-gtk-greeter.conf
    mode: '0644'

- name: LightDM starten
  systemd:
    name: lightdm
    enabled: true
    state: restarted
  when: not is_alpine
GUI

cat << 'LIGHTDM' > roles/gui/templates/lightdm.conf.j2
[Seat:*]
greeter-session=lightdm-gtk-greeter
user-session=i3
LIGHTDM

cat << 'GREETER' > roles/gui/templates/lightdm-gtk-greeter.conf.j2
[greeter]
background={{ wallpaper_dest }}
theme-name=Adwaita-dark
icon-theme-name=Adwaita
font-name={{ font }}
xft-antialias=true
GREETER

# === theme (i3 + Kitty + Rofi Nord) ===
cat << 'THEME' > roles/theme/tasks/main.yml
---
- name: Nord wallpaper
  get_url:
    url: "{{ wallpaper_url }}"
    dest: "{{ wallpaper_dest }}"
    mode: '0644'

- name: i3 config (mooie look)
  template:
    src: i3-config.j2
    dest: "/home/{{ username }}/.config/i3/config"
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: '0644'

- name: Kitty config + Nord
  copy:
    content: |
      include nord.conf
      background_opacity 0.92
      font_family DejaVuSansMono
      font_size 11
    dest: "/home/{{ username }}/.config/kitty/kitty.conf"
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: '0644'

- name: Kitty Nord colors
  copy:
    content: |
      foreground #D8DEE9
      background #2E3440
      cursor #81A1C1
      selection_background #5E81AC
      color0 #3B4252
      color1 #BF616A
      color2 #A3BE8C
      color3 #EBCB8B
      color4 #81A1C1
      color5 #B48EAD
      color6 #88C0D0
      color7 #E5E9F0
      color8 #4C566A
      color9 #BF616A
      color10 #A3BE8C
      color11 #EBCB8B
      color12 #81A1C1
      color13 #B48EAD
      color14 #8FBCBB
      color15 #ECEFF4
    dest: "/home/{{ username }}/.config/kitty/nord.conf"
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: '0644'

- name: Rofi Nord theme
  copy:
    content: |
      * { background-color: #2E3440; color: #D8DEE9; }
      window { border: 3px solid #5E81AC; border-radius: 8px; }
      inputbar { padding: 12px; }
      element { padding: 8px; }
      element selected { background-color: #5E81AC; color: #2E3440; }
    dest: "/home/{{ username }}/.config/rofi/config.rasi"
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: '0644'
  when: enable_rofi | bool
THEME

cat << 'I3' > roles/theme/templates/i3-config.j2
set $mod Mod4
exec --no-startup-id feh --bg-scale {{ wallpaper_dest }}

gaps inner {{ gap_size }}
gaps outer 5

client.focused          #5E81AC #5E81AC #ECEFF4 #8FBCBB   #5E81AC
client.focused_inactive #3B4252 #3B4252 #D8DEE9 #3B4252   #3B4252
client.unfocused        #3B4252 #3B4252 #D8DEE9 #3B4252   #3B4252

bindsym $mod+Return exec {{ terminal }}
bindsym $mod+Shift+q kill
bindsym $mod+d exec rofi -show drun
bindsym $mod+1 workspace 1
bindsym $mod+2 workspace 2
bindsym $mod+3 workspace 3
bindsym $mod+4 workspace 4
bindsym $mod+5 workspace 5
I3

# === cli (DevOps tools + Zsh/Starship) ===
cat << 'CLI' > roles/cli/tasks/main.yml
---
- name: Basis + moderne CLI tools
  package:
    name:
      - git
      - curl
      - jq
      - yq
      - bat
      - fzf
      - ripgrep
      - zoxide
      - neovim
      - tmux
      - htop
    state: present

- name: Docker (indien enabled)
  block:
    - package:
        name:
          - docker-ce
          - docker-ce-cli
          - containerd.io
        state: present
    - systemd:
        name: docker
        enabled: true
        state: started
  when: enable_docker | bool

- name: Zsh + Starship
  package:
    name: 
      - zsh
      - starship
    state: present
  when: enable_zsh_starship | bool

- name: Starship config
  copy:
    content: |
      format = """$directory$git_branch$git_status$line_break$character"""
      [directory]
      style = "bold #88C0D0"
    dest: "/home/{{ username }}/.config/starship.toml"
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: '0644'
  when: enable_zsh_starship | bool

- name: .zshrc met aliases en Starship
  copy:
    content: |
      eval "$(starship init zsh)"
      alias ll='ls -lah'
      alias cat='bat'
      alias update='sudo apt update && sudo apt upgrade -y || sudo dnf upgrade -y'
    dest: "/home/{{ username }}/.zshrc"
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: '0644'
  when: enable_zsh_starship | bool
CLI

# === README ===
cat << 'README' > README.md
# Nord i3 Ultimate (alles geïntegreerd)

Mooie Nord look & feel + handig dagelijks gebruik.

**Key features**:
- Nord wallpaper op desktop + login
- i3 met gaps en mooie borders
- Kitty met transparantie + Nord colors
- Rofi launcher (Super + d)
- Zsh + Starship prompt
- Moderne CLI tools + Docker

**Uitvoeren**:
cd nord-i3-ultimate
ansible-playbook -i localhost, playbook.yml --become

Na afloop: log uit en weer in.  
Druk **Super + d** voor het menu.

Geniet van je setup!
README

echo "✅ ULTIMATE geïntegreerde Nord i3 setup aangemaakt in: $DIR"
echo ""
echo "Volgende stappen:"
echo "   cd $DIR"
echo "   ansible-playbook -i localhost, playbook.yml --become"
echo ""
echo "Dit is nu écht alles in één playbook."
EOF

chmod +x /tmp/create-nord-i3-ultimate.sh
/tmp/create-nord-i3-ultimate.sh