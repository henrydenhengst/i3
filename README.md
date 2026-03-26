Installeer vanuit Ansible 

```bash
ansible-playbook setup_i3.yml --ask-become-pass
```

[Bekijk de sneltoetsen](sneltoetsen.md)


# ❄️ Nordic Omni-Protocol i3wm DevOps sysadmin workstation 

Dit project bevat de volledige configuratie voor een krachtig, Nordic-styled DevOps-workstation, geoptimaliseerd voor oudere hardware. Het maakt gebruik van een vederlichte i3wm-interface gecombineerd met een diepe technische toolset.

![Ansible](https://img.shields.io/badge/Ansible-2.16+-5e81ac?style=for-the-badge&logo=ansible&logoColor=white)
![OS](https://img.shields.io/badge/OS-Debian%20%2F%20Ubuntu-88c0d0?style=for-the-badge&logo=linux&logoColor=white)
![WM](https://img.shields.io/badge/WM-i3wm-81a1c1?style=for-the-badge&logo=i3&logoColor=white)
![Shell](https://img.shields.io/badge/Shell-Zsh%20%26%20Starship-4c566a?style=for-the-badge&logo=zsh&logoColor=white)
![Container](https://img.shields.io/badge/Container-Docker%20%26%20Podman-5e81ac?style=for-the-badge&logo=podman&logoColor=white)
![Virtualization](https://img.shields.io/badge/Virt-Vagrant%20%2F%20KVM-88c0d0?style=for-the-badge&logo=vagrant&logoColor=white)
![Editor](https://img.shields.io/badge/Editor-Neovim%20%26%20Vim-81a1c1?style=for-the-badge&logo=neovim&logoColor=white)
![Status](https://img.shields.io/badge/Status-God--Mode%20Enabled-a3be8c?style=for-the-badge)

---

## 🛠️ Belangrijkste Kenmerken

### 🖥️ Interface & Desktop (GUI)
* Tiling Window Manager: i3wm in het Nord-thema met Polybar en Rofi.
* Visuals: Picom voor transparantie en feh voor een willekeurige Nord-wallpaper uit /usr/share/backgrounds/.
* Browser: Falkon; een ultra-lichtgewicht browser met AdBlock, ideaal voor documentatie zonder geheugenverlies.

### 📟 Terminal & Shell (Kitty + Tmux + Zsh)
* Kitty: GPU-accelerated terminal met Nerd Fonts en image previews via nnn.
* Tmux (Sysadmin Mode): Pane Sync om in alle panelen tegelijk te typen (Prefix + y). Session Logging om je terminal-output op te slaan (Prefix + P). K8s Context direct zichtbaar in de statusbalk.
* Zsh: Voorzien van Starship-prompt, Autosuggesties en Syntax Highlighting.

### ☁️ DevOps & Containers
* Hybrid Container Engine: Ondersteunt je bestaande Docker-installatie én de vederlichte Podman (daemonless).
* Virtualisatie: Vagrant met Libvirt/KVM (sneller en lichter op de kernel dan VirtualBox).
* Toolbox: K9s, Helm, Terraform, Kubectl, Azure/AWS CLI en 100+ moderne CLI-utilities zoals bat, eza en btop.

---

## 🚀 Installatie

1. Clone de repository:
   git clone https://github.com/henrydenhengst/i3.git
   cd i3

2. Draai het Playbook:
   ansible-playbook setup_i3.yml --ask-become-pass

3. Herstart je systeem: Log uit en selecteer i3 als sessie in je login-manager.

---

## ⌨️ Sneltoetsen Cheat Sheet (Basis)

i3wm Desktop:
* $mod + Enter: Open Kitty Terminal (start direct in Tmux)
* $mod + w: Open Falkon Browser (Workspace 1)
* $mod + d: Open Rofi Programmazoeker
* $mod + Shift + q: Sluit actief venster
* $mod + Shift + r: Herstart i3 (nieuwe wallpaper + config)

Tmux (Prefix = Ctrl + a):
* Prefix + | : Split verticaal
* Prefix + - : Split horizontaal
* Prefix + y : Sync Mode Aan/Uit (typ in alle vensters)
* Prefix + P : Start/Stop Logging naar bestand

DevOps & Shell:
* k : kubectl
* ldo : lazydocker (werkt voor Docker & Podman)
* n : nnn (File manager met previews)
* p : podman
* ctx / ns : Switch K8s Context of Namespace

---

## 📂 Belangrijke Bestanden
* Playbook: setup_i3.yml
* Zsh Config: ~/.zshrc
* Neovim IDE: ~/.config/nvim/init.lua
* Sneltoetsen: [Bekijk de volledige lijst](sneltoetsen.md)

---
Copyleft henrydenhengst/i3 (2026).