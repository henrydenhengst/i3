Installeer vanuit Ansible 

```bash
ansible-playbook setup_i3.yml --ask-become-pass
```

[Bekijk de sneltoetsen](sneltoetsen.md)


# ❄️ Nordic Omni-Protocol i3wm DevOps sysadmin workstation 

![Ansible](https://img.shields.io/badge/Ansible-2.16+-5e81ac?style=for-the-badge&logo=ansible)
![OS](https://img.shields.io/badge/OS-Debian/Ubuntu-88c0d0?style=for-the-badge&logo=linux&logoColor=white)
![Shell](https://img.shields.io/badge/Shell-Zsh_&_Starship-81a1c1?style=for-the-badge&logo=zsh)
![Container](https://img.shields.io/badge/Docker_&_Podman-Hybrid-4c566a?style=for-the-badge&logo=podman)
![Virtualization](https://img.shields.io/badge/Vagrant-KVM/Libvirt-5e81ac?style=for-the-badge&logo=vagrant)

Dit project bevat de volledige configuratie voor een krachtig, Nordic-styled DevOps-workstation, geoptimaliseerd voor oudere hardware. Het maakt gebruik van een vederlichte i3wm-interface gecombineerd met een diepe technische toolset.

---

## 🛠️ Belangrijkste Kenmerken

### 🖥️ Interface & Desktop (GUI)
* **Tiling Window Manager:** i3wm in het Nord-thema met Polybar en Rofi.
* **Visuals:** Picom voor transparantie en `feh` voor een willekeurige Nord-wallpaper uit `/usr/share/backgrounds/`.
* **Browser:** Falkon; een ultra-lichtgewicht browser met AdBlock, ideaal voor documentatie.

### 📟 Terminal & Shell (Kitty + Tmux + Zsh)
* **Kitty:** GPU-accelerated terminal met Nerd Fonts en image previews via `nnn`.
* **Tmux (Sysadmin Mode):** * **Pane Sync:** Typ in alle panelen tegelijk (`Prefix + y`).
    * **Session Logging:** Sla je terminal-output op naar bestand (`Prefix + P`).
    * **K8s Context:** Directe status-uitlezing in de balk.
* **Zsh:** Met Starship-prompt, Autosuggesties en Syntax Highlighting.

### ☁️ DevOps & Containers
* **Hybrid Container Engine:** Ondersteunt je bestaande **Docker**-installatie én de vederlichte **Podman** (daemonless).
* **Virtualisatie:** Vagrant met **Libvirt/KVM** (sneller en lichter dan VirtualBox).
* **Toolbox:** K9s, Helm, Terraform, Kubectl, Azure/AWS CLI en 100+ moderne CLI-utilities.

---

## 🚀 Installatie

1. **Clone de repository:**
   ```bash
   git clone [https://github.com/henrydenhengst/i3.git](https://github.com/henrydenhengst/i3.git)
   cd i3
