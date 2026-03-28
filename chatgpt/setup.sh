#!/usr/bin/env bash
set -e

echo "[*] Installing Ansible if missing..."

if ! command -v ansible >/dev/null; then
  if [ -f /etc/debian_version ]; then
    sudo apt update && sudo apt install -y ansible
  elif [ -f /etc/redhat-release ]; then
    sudo dnf install -y ansible
  elif [ -f /etc/arch-release ]; then
    sudo pacman -Sy --noconfirm ansible
  else
    echo "Install Ansible manually"
    exit 1
  fi
fi

echo "[*] Creating minimal playbook..."

cat > site.yml <<'EOF'
- hosts: localhost
  become: true

  vars:
    enable_gui: true
    enable_browser: false
    enable_docker: true
    enable_vagrant: false
    preferred_browser: "falkon"

  tasks:

    - name: Install base packages
      package:
        name:
          - curl
          - git
          - unzip
        state: present

    - name: Install i3 stack
      package:
        name:
          - i3
          - xorg
          - lightdm
          - dmenu
          - feh
        state: present
      when: enable_gui

    - name: Enable lightdm
      systemd:
        name: lightdm
        enabled: true
      when: enable_gui

    - name: Install kitty
      package:
        name: kitty
        state: present
      when: enable_gui

    - name: Install browser
      package:
        name: "{{ 'falkon' if preferred_browser == 'falkon' else 'firefox' }}"
        state: present
      when: enable_gui and enable_browser

    - name: Nord wallpaper
      get_url:
        url: https://raw.githubusercontent.com/arcticicestudio/nord-wallpapers/master/wallpapers/ign_astronaut.png
        dest: /usr/share/backgrounds/nord.png
      when: enable_gui

    - name: i3 config
      copy:
        dest: ~/.config/i3/config
        content: |
          exec_always feh --bg-scale /usr/share/backgrounds/nord.png
      when: enable_gui

    - name: Kitty Nord theme
      copy:
        dest: ~/.config/kitty/kitty.conf
        content: |
          background #2E3440
          foreground #D8DEE9
      when: enable_gui

    - name: Install Docker (official)
      shell: curl -fsSL https://get.docker.com | sh
      when: enable_docker

    - name: Enable Docker
      systemd:
        name: docker
        state: started
        enabled: true
      when: enable_docker

    - name: Install Vagrant
      unarchive:
        src: https://releases.hashicorp.com/vagrant/2.4.0/vagrant_2.4.0_linux_amd64.zip
        dest: /usr/local/bin/
        remote_src: yes
      when: enable_vagrant

EOF

echo "[*] Running playbook..."
ansible-playbook site.yml -K

echo "[✓] Done"