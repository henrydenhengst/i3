mkdir -p ansible-nord-setup/roles/{common,gui,nord_theme}/tasks && cd ansible-nord-setup

# 1. Inventory & Vars
cat <<EOF > inventory.ini
[workstation]
localhost ansible_connection=local
EOF

cat <<EOF > group_vars/all.yml
---
enable_gui: true
enable_browser: true
enable_docker: true
browser_choice: "falkon"
nord_wallpaper: "https://raw.githubusercontent.com/linuxdotexe/nordic-wallpapers/master/wallpapers/ign_nord.png"
EOF

# 2. Hoofdplaybook
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

# 3. Role: Common (DevOps & Tools)
cat <<EOF > roles/common/tasks/main.yml
- name: Install Base Tools
  package:
    name: [curl, git, vim, unzip, wget]
    state: present

- name: Install Docker via Official Script
  shell: curl -fsSL https://get.docker.com | sh
  when: enable_docker
  args: { creates: /usr/bin/docker }
EOF

# 4. Role: GUI (i3, LightDM & Browser)
cat <<EOF > roles/gui/tasks/main.yml
- name: Install i3, LightDM and Kitty
  package:
    name: [i3-wm, lightdm, lightdm-gtk-greeter, kitty, feh]
    state: present

- name: Enable LightDM Service
  service:
    name: lightdm
    enabled: yes

- name: Ensure Falkon or Firefox
  block:
    - package: { name: falkon, state: present }
      when: browser_choice == "falkon"
  rescue:
    - package: { name: firefox, state: present }
  when: enable_browser
EOF

# 5. Role: Nord Theme (Styling & Configs)
cat <<EOF > roles/nord_theme/tasks/main.yml
- name: Create Config Dirs
  file:
    path: "{{ item }}"
    state: directory
  loop:
    - ~/.config/i3
    - ~/.config/kitty

- name: Configure i3 with Nord Theme
  copy:
    dest: ~/.config/i3/config
    content: |
      set \$bg #2e3440
      set \$fg #d8dee9
      client.focused #88c0d0 #81a1c1 #2e3440 #88c0d0
      exec --no-startup-id feh --bg-fill {{ nord_wallpaper }}
      bindsym Mod4+Return exec kitty
      bindsym Mod4+Shift+q kill
      bar { colors { background #2e3440 } }

- name: Configure Kitty with Nord
  copy:
    dest: ~/.config/kitty/kitty.conf
    content: |
      background #2e3440
      foreground #d8dee9
      font_family family="Fira Code"
EOF

echo "Klaar! Start de installatie met: ansible-playbook -i inventory.ini playbook.yml -K"
