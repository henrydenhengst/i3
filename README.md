Installeer vanuit Ansible 

```bash
ansible-playbook setup_i3.yml --ask-become-pass
```

[Bekijk de sneltoetsen](sneltoetsen.md)


# ❄️ Nordic Omni-Protocol i3wm DevOps sysadmin workstation 

Dit project bevat de volledige configuratie voor een krachtig, Nordic-styled DevOps-workstation, geoptimaliseerd voor oudere hardware. Het maakt gebruik van een vederlichte i3wm-interface gecombineerd met een diepe technische toolset.

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