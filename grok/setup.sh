cat << 'EOF' > /tmp/create-nord-i3-playbook-improved.sh
#!/bin/bash
# === Verbeterde Nord i3 + LightDM Ansible setup (2026) ===
set -e

DIR="nord-i3-ansible"
echo "🚀 Aanmaken van verbeterde playbook met betere LightDM support in map: $DIR"

rm -rf $DIR 2>/dev/null || true
mkdir -p $DIR/{group_vars,roles/{common,gui,theme,devops}/tasks,roles/{gui,theme}/templates}

cd $DIR

# === group_vars/all.yml ===
cat << 'VARS' > group_vars/all.yml
---
enable_gui: true
enable_browser: true
enable_docker: true
enable_vagrant: false

username: "{{ ansible_user_id | default(ansible_user) }}"
wallpaper_url: "https://raw.githubusercontent.com/linuxdotexe/nordic-wallpapers/master/wallpapers/ign_unsplash4.png"
wallpaper_dest: "/usr/share/backgrounds/nord-wallpaper.png"

nord:
  bg: "#2E3440"
  fg: "#D8DEE9"
  accent: "#5E81AC"
VARS

# === playbook.yml ===
cat << 'PLAY' > playbook.yml
---
- name: Nord i3 + LightDM + DevOps setup (verbeterd)
  hosts: all
  become: true
  vars_files:
    - group_vars/all.yml

  roles:
    - common
    - { role: gui, when: enable_gui | bool }
    - { role: theme, when: enable_gui | bool }
    - { role: devops, when: enable_docker | bool or enable_vagrant | bool }
PLAY

# === roles/common/tasks/main.yml ===
cat << 'COMMON' > roles/common/tasks/main.yml
---
- name: Detecteer OS
  set_fact:
    is_alpine: "{{ ansible_distribution == 'Alpine' }}"
    is_arch: "{{ ansible_distribution == 'Archlinux' }}"
    os_family: "{{ ansible_os_family }}"

- name: Update package cache
  package:
    update_cache: true
  when: not is_alpine

- name: Basis pakketten
  package:
    name:
      - git
      - curl
      - wget
      - htop
      - vim
    state: present
COMMON

# === roles/gui/tasks/main.yml (verbeterd LightDM) ===
cat << 'GUI' > roles/gui/tasks/main.yml
---
- name: GUI pakketten inclusief LightDM en greeter
  package:
    name:
      - i3
      - lightdm
      - lightdm-gtk-greeter
      - kitty
      - xorg
      - feh
    state: present
  when: not is_alpine

- name: Browser installeren
  package:
    name: "{{ 'falkon' if (ansible_distribution != 'Alpine' and ansible_pkg_mgr != 'apk') else 'firefox' }}"
    state: present
  when: enable_browser | bool

- name: LightDM hoofdconfiguratie (user-session=i3)
  template:
    src: lightdm.conf.j2
    dest: /etc/lightdm/lightdm.conf
    mode: '0644'

- name: LightDM GTK greeter configuratie met Nord wallpaper
  template:
    src: lightdm-gtk-greeter.conf.j2
    dest: /etc/lightdm/lightdm-gtk-greeter.conf
    mode: '0644'

- name: LightDM service inschakelen en starten
  systemd:
    name: lightdm
    enabled: true
    state: restarted
  when: not is_alpine

- name: Alpine fallback (geen GUI)
  debug:
    msg: "Alpine Linux → GUI en LightDM uitgeschakeld (CLI-only modus)"
  when: is_alpine
GUI

# === roles/gui/templates/lightdm.conf.j2 ===
cat << 'LIGHTDM' > roles/gui/templates/lightdm.conf.j2
[Seat:*]
greeter-session=lightdm-gtk-greeter
user-session=i3
LIGHTDM

# === roles/gui/templates/lightdm-gtk-greeter.conf.j2 ===
cat << 'GREETER' > roles/gui/templates/lightdm-gtk-greeter.conf.j2
[greeter]
background={{ wallpaper_dest }}
theme-name=Nordic
icon-theme-name=Nordic
font-name=Sans 10
xft-antialias=true
xft-hintstyle=hintslight
GREETER

# === roles/theme/tasks/main.yml (zelfde Nord wallpaper voor login + i3) ===
cat << 'THEME' > roles/theme/tasks/main.yml
---
- name: Nord wallpaper downloaden
  get_url:
    url: "{{ wallpaper_url }}"
    dest: "{{ wallpaper_dest }}"
    mode: '0644'

- name: i3 Nord config met wallpaper
  template:
    src: i3-config.j2
    dest: "/home/{{ username }}/.config/i3/config"
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: '0644'

- name: Kitty Nord theme
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

- name: Kitty config include Nord
  lineinfile:
    path: "/home/{{ username }}/.config/kitty/kitty.conf"
    line: "include ./nord.conf"
    create: true
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: '0644'
THEME

# === roles/theme/templates/i3-config.j2 ===
cat << 'I3' > roles/theme/templates/i3-config.j2
# Nord i3 config - eenvoudig en stabiel

set $mod Mod4
exec --no-startup-id feh --bg-scale {{ wallpaper_dest }}

# Nord kleuren
client.focused          #5E81AC #5E81AC #ECEFF4 #8FBCBB   #5E81AC
client.focused_inactive #3B4252 #3B4252 #D8DEE9 #3B4252   #3B4252
client.unfocused        #3B4252 #3B4252 #D8DEE9 #3B4252   #3B4252
client.urgent           #BF616A #BF616A #ECEFF4 #BF616A   #BF616A

bindsym $mod+Return exec kitty
bindsym $mod+Shift+q kill
bindsym $mod+d exec rofi -show drun   # voeg rofi later toe als gewenst
I3

# === roles/devops/tasks/main.yml (ongewijzigd, eenvoudig) ===
cat << 'DEVOPS' > roles/devops/tasks/main.yml
---
- name: Docker installeren (officieel)
  block:
    - apt_key:
        url: https://download.docker.com/linux/{{ ansible_distribution | lower }}/gpg
        state: present
      when: ansible_os_family == 'Debian'
    - apt_repository:
        repo: deb https://download.docker.com/linux/{{ ansible_distribution | lower }} {{ ansible_distribution_release }} stable
        state: present
      when: ansible_os_family == 'Debian'
  when: enable_docker | bool and ansible_os_family == 'Debian'

- name: Docker pakketten
  package:
    name:
      - docker-ce
      - docker-ce-cli
      - containerd.io
    state: present
  when: enable_docker | bool

- name: Vagrant (optioneel)
  package:
    name: vagrant
    state: present
  when: enable_vagrant | bool
DEVOPS

# === README.md ===
cat << 'README' > README.md
# Nord i3 + LightDM Minimal Setup (verbeterd)

LightDM is nu correct geconfigureerd met:
- user-session=i3
- lightdm-gtk-greeter
- Nord wallpaper op zowel login-scherm als i3 desktop

Gebruik:
cd nord-i3-ansible
ansible-playbook -i localhost, playbook.yml --become

Na afloop: log uit en in (of reboot). Je krijgt direct de LightDM login met Nord wallpaper en i3.
README

echo "✅ Verbeterde structuur aangemaakt in: $DIR"
echo ""
echo "Volgende stappen:"
echo "   cd $DIR"
echo "   ansible-playbook -i localhost, playbook.yml --become"
echo ""
echo "LightDM zou nu betrouwbaarder moeten werken met i3."
EOF

chmod +x /tmp/create-nord-i3-playbook-improved.sh
/tmp/create-nord-i3-playbook-improved.sh