cat << 'EOF' > /tmp/create-nord-i3-playbook.sh
#!/bin/bash
# === Snel Nord i3 Ansible setup creator ===
set -e

DIR="nord-i3-ansible"
echo "🚀 Aanmaken van complete playbook in map: $DIR"

mkdir -p $DIR/{group_vars,roles/{common,gui,theme,devops}/tasks,roles/{gui,theme}/templates}

cd $DIR

# === group_vars/all.yml ===
cat << 'VARS' > group_vars/all.yml
---
enable_gui: true
enable_browser: true          # Falkon voorkeur, Firefox fallback
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
- name: Nord i3 + lightdm + DevOps setup (snel & modulair)
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

# === roles/gui/tasks/main.yml ===
cat << 'GUI' > roles/gui/tasks/main.yml
---
- name: GUI pakketten installeren (Debian/RedHat/Arch)
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

- name: Browser (Falkon of Firefox)
  package:
    name: "{{ 'falkon' if ansible_distribution != 'Alpine' else 'firefox' }}"
    state: present
  when: enable_browser | bool

- name: lightdm configuratie
  template:
    src: lightdm.conf.j2
    dest: /etc/lightdm/lightdm.conf
    mode: '0644'

- name: lightdm starten
  systemd:
    name: lightdm
    enabled: true
    state: started
  when: not is_alpine
GUI

# === roles/gui/templates/lightdm.conf.j2 ===
cat << 'LIGHTDM' > roles/gui/templates/lightdm.conf.j2
[Seat:*]
session-wrapper=/etc/lightdm/Xsession
greeter-session=lightdm-gtk-greeter
user-session=i3
LIGHTDM

# === roles/theme/tasks/main.yml ===
cat << 'THEME' > roles/theme/tasks/main.yml
---
- name: Nord wallpaper downloaden
  get_url:
    url: "{{ wallpaper_url }}"
    dest: "{{ wallpaper_dest }}"
    mode: '0644'

- name: i3 Nord config
  template:
    src: i3-config.j2
    dest: "/home/{{ username }}/.config/i3/config"
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: '0644'

- name: Kitty Nord theme
  copy:
    content: |
      # Nord Kitty theme (officieel geïnspireerd)
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

- name: kitty.conf aanmaken met Nord include
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
# === Nord i3 config - eenvoudig & stabiel ===

set $mod Mod4
exec --no-startup-id feh --bg-scale {{ wallpaper_dest }}

# Kleuren Nord
client.focused          #5E81AC #5E81AC #ECEFF4 #8FBCBB   #5E81AC
client.focused_inactive #3B4252 #3B4252 #D8DEE9 #3B4252   #3B4252
client.unfocused        #3B4252 #3B4252 #D8DEE9 #3B4252   #3B4252
client.urgent           #BF616A #BF616A #ECEFF4 #BF616A   #BF616A

# Basis shortcuts
bindsym $mod+Return exec kitty
bindsym $mod+Shift+q kill
bindsym $mod+d exec rofi -show drun   # rofi optioneel later

# Workspaces
bindsym $mod+1 workspace 1
bindsym $mod+2 workspace 2
# ... tot 9 (je kunt dit uitbreiden)
I3

# === roles/devops/tasks/main.yml (basis Docker + Vagrant) ===
cat << 'DEVOPS' > roles/devops/tasks/main.yml
---
- name: Docker installeren via officiële methode (Debian-based)
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

- name: Docker installeren (RedHat/Fedora)
  yum_repository:
    name: docker-ce
    baseurl: https://download.docker.com/linux/fedora/$releasever/$basearch/stable
    gpgkey: https://download.docker.com/linux/fedora/gpg
    state: present
  when: enable_docker | bool and ansible_os_family == 'RedHat'

- name: Docker pakketten
  package:
    name:
      - docker-ce
      - docker-ce-cli
      - containerd.io
    state: present
  when: enable_docker | bool

- name: Vagrant (alleen als aangezet)
  package:
    name: vagrant
    state: present
  when: enable_vagrant | bool
DEVOPS

# === README.md ===
cat << 'README' > README.md
# Nord i3 Minimal Setup (Ansible)

Eén commando setup voor Debian, RedHat, Arch (en Alpine CLI-only).

Feature flags staan in group_vars/all.yml

Gebruik:
ansible-playbook -i localhost, playbook.yml --become -e "ansible_user=$(whoami)"

Na afloop: log uit en weer in → je hebt een schone Nord i3 + Kitty + wallpaper.
README

echo "✅ Structuur aangemaakt in map: $DIR"
echo ""
echo "Volgende stappen:"
echo "1. cd $DIR"
echo "2. Pas eventueel group_vars/all.yml aan (username, flags)"
echo "3. ansible-playbook -i localhost, playbook.yml --become"
EOF

chmod +x /tmp/create-nord-i3-playbook.sh
/tmp/create-nord-i3-playbook.sh