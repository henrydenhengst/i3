mkdir -p ansible-nord-setup/roles/{common,gui,nord_theme}/tasks && cd ansible-nord-setup

# 1. Maak de Inventory
cat <<EOF > inventory.ini
[workstation]
localhost ansible_connection=local
EOF

# 2. Maak de Variabelen (Feature Flags & Config)
cat <<EOF > group_vars/all.yml
---
enable_gui: true
enable_browser: true
enable_vagrant: true
enable_docker: true
browser_choice: "falkon"
nord_wallpaper: "https://raw.githubusercontent.com/linuxdotexe/nordic-wallpapers/master/wallpapers/ign_nord.png"
EOF

# 3. Maak het Hoofdplaybook
cat <<EOF > playbook.yml
---
- name: Modular Nord Setup
  hosts: workstation
  become: true
  roles:
    - common
    - { role: gui, when: enable_gui }
    - { role: nord_theme, when: enable_gui }
EOF

# 4. Maak de Rollen (Common, GUI, Theme)
cat <<EOF > roles/common/tasks/main.yml
- name: Install Base DevOps Tools
  package:
    name: [curl, git, vim, unzip]
    state: present

- name: Docker Setup (Official Repo)
  shell: curl -fsSL https://get.docker.com | sh
  when: enable_docker
  args: { creates: /usr/bin/docker }
EOF

cat <<EOF > roles/gui/tasks/main.yml
- name: Install i3 and LightDM
  package:
    name: [i3-wm, lightdm, kitty]
    state: present

- name: Install Browser (Falkon with Firefox fallback)
  block:
    - package: { name: falkon, state: present }
      when: browser_choice == "falkon"
  rescue:
    - package: { name: firefox, state: present }
  when: enable_browser
EOF

cat <<EOF > roles/nord_theme/tasks/main.yml
- name: Apply Nord Colors to Kitty
  copy:
    dest: ~/.config/kitty/kitty.conf
    content: |
      background #2e3440
      foreground #d8dee9
      selection_background #4c566a
      color0 #3b4252
EOF

echo "Klaar! Je mappenstructuur staat in $(pwd)"
