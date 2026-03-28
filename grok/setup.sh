cat << 'EOF' > /tmp/create-nord-i3-ultimate-final.sh
#!/bin/bash
# === ULTIMATE Nord i3 Setup - Finale versie (beste look & feel + gemak) ===
set -e

DIR="nord-i3-ultimate"
echo "🚀 Aanmaken van de ULTIMATE Nord i3 setup (alles-in-één, verbeterde look & feel)"

rm -rf $DIR 2>/dev/null || true
mkdir -p $DIR/{group_vars,roles/{common,gui,theme,cli}/tasks,roles/{gui,theme}/templates}

cd $DIR

# === group_vars/all.yml ===
cat << 'VARS' > group_vars/all.yml
---
enable_gui: true
enable_browser: true
enable_docker: true
enable_rofi: true
enable_zsh_starship: true

username: "{{ ansible_user_id | default(ansible_user) }}"
wallpaper_url: "https://raw.githubusercontent.com/linuxdotexe/nordic-wallpapers/master/wallpapers/ign_unsplash4.png"
wallpaper_dest: "/usr/share/backgrounds/nord-wallpaper.png"

# Look & Feel settings
font: "DejaVu Sans Mono 10"
gap_inner: 12
gap_outer: 6
terminal: "kitty"
VARS

# === playbook.yml ===
cat << 'PLAY' > playbook.yml
---
- name: Nord i3 Ultimate - Beste look & feel + gebruikersgemak
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

# === gui ===
cat << 'GUI' > roles/gui/tasks/main.yml
---
- name: GUI pakketten inclusief Rofi
  package:
    name:
      - i3
      - lightdm
      - lightdm-gtk-greeter
      - kitty
      - rofi
      - feh
      - xorg
      - scrot          # voor screenshots
    state: present
  when: not is_alpine

- name: Browser installeren
  package:
    name: "{{ 'falkon' if ansible_distribution != 'Alpine' else 'firefox' }}"
    state: present
  when: enable_browser | bool

- name: LightDM configuratie
  template:
    src: lightdm.conf.j2
    dest: /etc/lightdm/lightdm.conf
    mode: '0644'

- name: LightDM greeter met Nord wallpaper
  template:
    src: lightdm-gtk-greeter.conf.j2
    dest: /etc/lightdm/lightdm-gtk-greeter.conf
    mode: '0644'

- name: LightDM herstarten
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
xft-hintstyle=hintslight
GREETER

# === theme (verbeterde i3 + Kitty + Rofi) ===
cat << 'THEME' > roles/theme/tasks/main.yml
---
- name: Nord wallpaper downloaden
  get_url:
    url: "{{ wallpaper_url }}"
    dest: "{{ wallpaper_dest }}"
    mode: '0644'

- name: i3 config met verbeterde look
  template:
    src: i3-config.j2
    dest: "/home/{{ username }}/.config/i3/config"
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: '0644'

- name: Kitty config (transparantie + Nord)
  copy:
    content: |
      include nord.conf
      background_opacity 0.90
      font_family DejaVuSansMono
      font_size 11
    dest: "/home/{{ username }}/.config/kitty/kitty.conf"
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: '0644'

- name: Kitty Nord kleuren
  copy:
    content: |
      foreground #D8DEE9
      background #2E3440
      cursor #81A1C1
      selection_background #5E81AC
      color0  #3B4252
      color1  #BF616A
      color2  #A3BE8C
      color3  #EBCB8B
      color4  #81A1C1
      color5  #B48EAD
      color6  #88C0D0
      color7  #E5E9F0
      color8  #4C566A
      color9  #BF616A
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

- name: Rofi Nord theme (schoon & elegant)
  copy:
    content: |
      * {
        background-color: #2E3440;
        text-color: #D8DEE9;
        border-color: #5E81AC;
      }
      window {
        border: 3px;
        border-radius: 8px;
      }
      inputbar {
        padding: 12px;
      }
      element {
        padding: 8px;
      }
      element selected {
        background-color: #5E81AC;
        text-color: #2E3440;
      }
    dest: "/home/{{ username }}/.config/rofi/config.rasi"
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: '0644'
  when: enable_rofi | bool
THEME

cat << 'I3' > roles/theme/templates/i3-config.j2
set $mod Mod4
exec --no-startup-id feh --bg-scale {{ wallpaper_dest }}

# Verbeterde gaps & look
gaps inner {{ gap_inner }}
gaps outer {{ gap_outer }}
smart_gaps on

for_window [class=".*"] border pixel 2

# Nord kleuren
client.focused          #5E81AC #5E81AC #ECEFF4 #8FBCBB   #5E81AC
client.focused_inactive #3B4252 #3B4252 #D8DEE9 #3B4252   #3B4252
client.unfocused        #3B4252 #3B4252 #D8DEE9 #3B4252   #3B4252
client.urgent           #BF616A #BF616A #ECEFF4 #BF616A   #BF616A

# Handige keybinds
bindsym $mod+Return exec {{ terminal }}
bindsym $mod+Shift+q kill
bindsym $mod+d exec rofi -show drun
bindsym $mod+Shift+s exec scrot -s -e 'xclip -selection clipboard -t image/png -i $f'
bindsym $mod+1 workspace 1
bindsym $mod+2 workspace 2
bindsym $mod+3 workspace 3
bindsym $mod+4 workspace 4
bindsym $mod+5 workspace 5
I3

# === cli (DevOps + gemak) ===
cat << 'CLI' > roles/cli/tasks/main.yml
---
- name: Moderne CLI tools
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

- name: Docker
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

- name: Starship config (Nord accent)
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

- name: .zshrc met handige aliases
  copy:
    content: |
      eval "$(starship init zsh)"
      alias ll='ls -lah --color=auto'
      alias cat='bat'
      alias update='sudo apt update && sudo apt upgrade -y || sudo dnf upgrade -y || sudo pacman -Syu'
      alias vim='nvim'
    dest: "/home/{{ username }}/.zshrc"
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: '0644'
  when: enable_zsh_starship | bool
CLI

# === README.md ===
cat << 'README' > README.md
# Nord i3 Ultimate - Finale versie

**Verbeterde look & feel**:
- Mooie gaps + smart gaps in i3
- Elegante Nord Rofi launcher (Super + d)
- Kitty met transparantie
- Nord wallpaper op zowel desktop als LightDM login

**Gebruikersgemak**:
- Handige shortcuts (screenshot met Super+Shift+s)
- Zsh + Starship prompt
- Praktische aliases (cat → bat, update, etc.)

**Uitvoeren**:
```bash
cd nord-i3-ultimate
ansible-playbook -i localhost, playbook.yml --become