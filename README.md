Installeer vanuit Ansible 

```bash
ansible-playbook setup_i3.yml --ask-become-pass
```

[Bekijk de sneltoetsen](sneltoetsen.md)


# Functionele Beschrijving: 

## Nordic Omni-Protocol Workstation i3wm

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


