Installeer vanuit Ansible 

```bash
ansible-playbook setup_i3.yml --ask-become-pass
```

[Bekijk de sneltoetsen](sneltoetsen.md)


# Functionele Beschrijving: 

## Nordic Omni-Protocol Workstation i3wm

![Ansible](https://img.shields.io/badge/Ansible-2.16+-black?style=for-the-badge&logo=ansible&logoColor=white&color=5e81ac)
![OS](https://img.shields.io/badge/OS-Debian/Ubuntu-black?style=for-the-badge&logo=linux&logoColor=white&color=88c0d0)
![Shell](https://img.shields.io/badge/Shell-Zsh_&_Starship-black?style=for-the-badge&logo=zsh&logoColor=white&color=81a1c1)
![Theme](https://img.shields.io/badge/Theme-Nordic-black?style=for-the-badge&color=4c566a)
![DevOps](https://img.shields.io/badge/DevOps-Ready-black?style=for-the-badge&logo=kubernetes&logoColor=white&color=5e81ac)
![Ansible](https://img.shields.io/badge/Ansible-2.16+-5e81ac?style=for-the-badge&logo=ansible)
![Virtualization](https://img.shields.io/badge/Vagrant-KVM/Libvirt-88c0d0?style=for-the-badge&logo=vagrant)
![Podman](https://img.shields.io/badge/Podman-Daemonless-88c0d0?style=for-the-badge&logo=podman)
![Distrobox](https://img.shields.io/badge/Distrobox-Ready-5e81ac?style=for-the-badge)

Dit Ansible playbook bouwt een volledig functioneel DevOps-station met een focus op Sysadmin-workflow en esthetiek.

* **GUI:** i3wm (Nord Focus), Polybar status, Rofi launcher, Picom compositing.
* **Beeld:** Gebruikt jouw `/usr/share/backgrounds/` voor een random wallpaper bij elke start.
* **Terminal:** Kitty (GPU-accelerated) met Tmux (Prefix C-a, sync-mode, auto-logging).
* **Shell:** Zsh met Starship-prompt, Autosuggestions en Syntax-Highlighting.
* **Migratie:** Jouw bestaande `.bashrc` en `.vimrc` worden automatisch geïntegreerd in Zsh en Neovim.
* **DevOps:** Inclusief K9s (Nord), Lazydocker, Terraform, Kubectl/ctx/ns, Ansible-lint, Stern en 100+ CLI tools.
* **Editing:** Neovim met YAML/Ansible LSP, Telescope (file-search) en Indent-blanklines.
* **File Management:** nnn met preview-tui (afbeeldingen/PDF's direct in terminal).
* **Browser:** Falkon (privacy-tuned) op Workspace 1.
* **Automatisering:** SSH-Agent auto-start en auto-key-load.
* **Virtualisatie:** Configureert Vagrant met de vederlichte Libvirt/KVM provider (ideaal voor oudere hardware).
* **Highlights:**
1. **Podman:** Vervangt Docker. Het gebruikt 0 MB RAM als er geen containers draaien.
2. **Alias:** Ik heb `alias docker=podman` toegevoegd. Al je oude commando's werken nog steeds.
3. **Distrobox:** Gebruik `distrobox create -n test --image fedora:latest` om binnen seconden een andere distro te draaien zonder de overhead van een VM.
4. **Vagrant KVM:** Nog steeds aanwezig voor de taken die echt een eigen kernel nodig hebben.

