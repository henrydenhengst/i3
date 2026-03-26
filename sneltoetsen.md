# ❄️ Nordic Sysadmin Cheat Sheet (2026 Edition)

Dit is de gecombineerde lijst voor i3wm, Tmux, Podman en Vagrant.

## 🚀 Desktop (i3wm)
* `$mod + Enter` : Open Kitty (Start direct in Tmux)
* `$mod + w`     : Open Falkon Browser (Workspace 1)
* `$mod + d`     : Open Rofi (Programma's zoeken)
* `$mod + Shift + q` : Sluit actief venster
* `$mod + Shift + r` : Herstart i3 (Nieuwe wallpaper + Config reload)
* `$mod + minus (-)` : Toon/verberg Scratchpad (Zwevend venster)

## 📟 Terminal & Multiplexer (Tmux)
*Let op: Prefix is nu Ctrl + a*

* `Prefix + y`   : **Sync Mode** (Typ in alle panelen tegelijk) - *Nieuw!*
* `Prefix + P`   : **Sessie Loggen** naar bestand - *Nieuw!*
* `Prefix + |`   : Split scherm verticaal
* `Prefix + -`   : Split scherm horizontaal
* `Prefix + z`   : Zoom paneel (Fullscreen in terminal)
* `Prefix + h/j/k/l` : Navigeer tussen panelen (Vim-stijl)

## ☁️ Containers & VM (Docker/Podman/Vagrant)
* `p`            : Alias voor `podman` (Lichte Docker vervanger) - *Nieuw!*
* `ldo`          : Open `lazydocker` (Werkt voor Docker én Podman)
* `k`            : Alias voor `kubectl`
* `ctx` / `ns`   : Wissel K8s Context of Namespace
* `v up`         : `vagrant up --provider=libvirt` (Snelste VM start) - *Nieuw!*

## 📝 Editing & Files
* `n`            : Open `nnn` File Manager (Druk `;p` voor previews)
* `Ctrl + p`     : In Neovim: Zoek naar bestanden (Telescope)
* `bat <file>`   : Bekijk bestanden met Nord-syntax highlighting

---
Locatie configs: ~/.config/i3/ | ~/.zshrc | ~/.config/nvim/

Repo: henrydenhengst/i3
