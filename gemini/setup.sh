#!/bin/bash
# 'The Ultimate Nord DevOps' Setup Script

# 1. Omgeving voorbereiden
PROJECT_DIR="nord-devops-workstation"
mkdir -p $PROJECT_DIR/roles/{base,gui,nord_theme,devops}/tasks
cd $PROJECT_DIR

# 2. Centraal Configuratiebestand
cat <<EOF > group_vars/all.yml
---
# Feature Flags
enable_gui: true
enable_docker: true
enable_browser: true
browser_choice: "falkon"

# Styling
nord_wallpaper: "https://raw.githubusercontent.com/linuxdotexe/nordic-wallpapers/master/wallpapers/ign_nord.png"
font_name: "FiraCode Nerd Font"
EOF

# 3. Het Master Playbook
cat <<EOF > site.yml
---
- name: Ultimate Nord Workstation
  hosts: localhost
  become: true
  roles:
    - base
    - { role: gui, when: enable_gui }
    - { role: nord_theme, when: enable_gui }
    - devops
EOF

# 4. Role: Base (System & Shell)
cat <<EOF > roles/base/tasks/main.yml
- name: Install System Essentials
  package:
    name: [curl, git, vim, zsh, unzip, wget, build-essential]
    state: present

- name: Set ZSH as default shell
  user:
    name: "{{ ansible_user_id }}"
    shell: /bin/zsh
EOF

# 5. Role: GUI (i3, LightDM & Rofi)
cat <<EOF > roles/gui/tasks/main.yml
- name: Install Window Management
  package:
    name: [i3-wm, lightdm, lightdm-gtk-greeter, kitty, rofi, feh, picom]
    state: present

- name: Enable LightDM
  service:
    name: lightdm
    enabled: yes

- name: Browser Strategy
  block:
    - package: { name: falkon, state: present }
      when: browser_choice == "falkon"
  rescue:
    - package: { name: firefox, state: present }
  when: enable_browser
EOF

# 6. Role: Nord Theme (The 'Look & Feel')
cat <<EOF > roles/nord_theme/tasks/main.yml
- name: Create Config Dirs
  file:
    path: "{{ item }}"
    state: directory
  loop:
    - ~/.config/i3
    - ~/.config/kitty
    - ~/.config/rofi

- name: Apply i3 Nord Config
  copy:
    dest: ~/.config/i3/config
    content: |
      # Nord Color Palette
      set \$nord0 #2e3440
      set \$nord6 #d8dee9
      set \$nord8 #88c0d0

      font pango:{{ font_name }} 10
      floating_modifier Mod4
      
      # Compositor voor transparantie (Picom)
      exec_always --no-startup-id picom -f &
      exec_always --no-startup-id feh --bg-fill {{ nord_wallpaper }}
      
      bindsym Mod4+Return exec kitty
      bindsym Mod4+d exec rofi -show drun
      bindsym Mod4+Shift+q kill
      
      # Gestylde Bar
      bar {
        status_command i3status
        colors {
          background \$nord0
          statusline \$nord6
          focused_workspace \$nord8 \$nord8 \$nord0
        }
      }

- name: Kitty Terminal Nord Styling
  copy:
    dest: ~/.config/kitty/kitty.conf
    content: |
      background #2e3440
      foreground #d8dee9
      background_opacity 0.9
      font_family {{ font_name }}
EOF

# 7. Role: DevOps (The Stack)
cat <<EOF > roles/devops/tasks/main.yml
- name: Install Docker
  shell: curl -fsSL https://get.docker.com | sh
  args: { creates: /usr/bin/docker }

- name: Install K8s Tools
  get_url:
    url: "https://dl.k8s.io/release/stable.txt"
    dest: /tmp/k8s_version
  register: k8s_ver

- name: Download Kubectl
  get_url:
    url: "https://dl.k8s.io/release/{{ lookup('file', '/tmp/k8s_version') }}/bin/linux/amd64/kubectl"
    dest: /usr/local/bin/kubectl
    mode: '0755'

- name: Install Helm
  shell: curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  args: { creates: /usr/local/bin/helm }
EOF

# 8. Inventory
echo "localhost ansible_connection=local" > inventory.ini

# RUN!
echo "--- STARTING DEPLOYMENT ---"
ansible-playbook -i inventory.ini site.yml -K
