#!/bin/bash
# 'Lightweight Nord Laptop' Installer

PROJECT_DIR="nord-laptop-setup"
mkdir -p $PROJECT_DIR/roles/{system,gui,nord_style,cli_tools}/tasks
cd $PROJECT_DIR

# 1. Configuratie (Laptop-specifiek)
cat <<EOF > group_vars/all.yml
---
enable_gui: true
enable_browser: true
browser_choice: "falkon"  # Falkon is lichter dan Firefox
nord_wallpaper: "https://raw.githubusercontent.com/linuxdotexe/nordic-wallpapers/master/wallpapers/ign_nord.png"
EOF

# 2. Master Playbook
cat <<EOF > site.yml
---
- name: Lightweight Nord Laptop Setup
  hosts: localhost
  become: true
  roles:
    - system
    - { role: gui, when: enable_gui }
    - { role: nord_style, when: enable_gui }
    - cli_tools
EOF

# 3. Role: System (Performance & Shell)
cat <<EOF > roles/system/tasks/main.yml
- name: Minimal System Packages
  package:
    name: [curl, git, vim, zsh, unzip, htop, tlp]
    state: present

- name: Enable TLP (Batterij optimalisatie)
  service:
    name: tlp
    enabled: yes
    state: started
  ignore_errors: yes

- name: Zsh Setup
  user:
    name: "{{ ansible_user_id }}"
    shell: /bin/zsh
EOF

# 4. Role: GUI (Minimal i3 & LightDM)
cat <<EOF > roles/gui/tasks/main.yml
- name: Install Minimal GUI Stack
  package:
    name: [i3-wm, lightdm, lightdm-gtk-greeter, kitty, rofi, feh]
    state: present

- name: Browser Installation (Lightweight focus)
  block:
    - package: { name: falkon, state: present }
      when: browser_choice == "falkon"
  rescue:
    - package: { name: firefox, state: present }
  when: enable_browser
EOF

# 5. Role: Nord Style (UI & Terminal)
cat <<EOF > roles/nord_style/tasks/main.yml
- name: Create Config Folders
  file:
    path: "{{ item }}"
    state: directory
  loop: [~/.config/i3, ~/.config/kitty]

- name: i3 Laptop Config (Nord)
  copy:
    dest: ~/.config/i3/config
    content: |
      set \$nord_bg #2e3440
      set \$nord_fg #d8dee9
      font pango:Monospace 10
      exec_always --no-startup-id feh --bg-fill {{ nord_wallpaper }}
      bindsym Mod4+Return exec kitty
      bindsym Mod4+d exec rofi -show drun
      bindsym Mod4+Shift+q kill
      bar {
        colors {
          background \$nord_bg
          statusline \$nord_fg
        }
      }

- name: Kitty Minimal Nord
  copy:
    dest: ~/.config/kitty/kitty.conf
    content: |
      background #2e3440
      foreground #d8dee9
      font_size 11.0
EOF

# 6. Role: CLI Tools (SysAdmin Essentials - No Heavy Daemons)
cat <<EOF > roles/cli_tools/tasks/main.yml
- name: Install SysAdmin Toolkit
  package:
    name: [ncdu, tldr, jq, sshpass, rsync]
    state: present

- name: Install Kubectl (Standalone Binary)
  get_url:
    url: "https://dl.k8s.io/release/stable.txt"
    dest: /tmp/k8s_version
  register: k8s_ver

- name: Binary Download Kubectl
  get_url:
    url: "https://dl.k8s.io/release/{{ lookup('file', '/tmp/k8s_version') }}/bin/linux/amd64/kubectl"
    dest: /usr/local/bin/kubectl
    mode: '0755'
EOF

# 7. Inventory & Run
echo "localhost ansible_connection=local" > inventory.ini
ansible-playbook -i inventory.ini site.yml -K
