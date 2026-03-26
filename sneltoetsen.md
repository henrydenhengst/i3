# ❄️ De Volledige Nordic Omni-Protocol Cheat Sheet

## 🖥️ i3 Window Manager (Systeem)
* $mod + Enter       : Open Kitty Terminal (start direct in Tmux)
* $mod + d           : Rofi (Programma's zoeken/starten)
* $mod + Shift + q   : Sluit huidige venster (Kill)
* $mod + Shift + e   : Exit i3 (Uitloggen)
* $mod + Shift + r   : Herstart i3 (Reload config + nieuwe wallpaper)

## 🪟 Venster Beheer (Layout)
* $mod + h           : Split horizontaal (volgende venster komt ernaast)
* $mod + v           : Split verticaal (volgende venster komt eronder)
* $mod + f           : Fullscreen aan/uit
* $mod + s           : Stacking layout (vensters boven elkaar)
* $mod + e           : Default layout (vensters naast elkaar)
* $mod + Shift + Spatie : Maak venster zwevend (Floating)
* $mod + r           : Resize modus (gebruik pijltjestoetsen, Esc om te stoppen)

## 🚀 Navigatie & Workspaces
* $mod + [1-9]       : Wissel naar Workspace 1-9
* $mod + Shift + [1-9] : Verplaats venster naar Workspace 1-9
* $mod + j/k/l/;     : Focus verplaatsen (Vim-stijl: links, onder, boven, rechts)
* $mod + Shift + j/k/l/; : Venster verplaatsen (Vim-stijl)

## 📟 Tmux Multiplexer (Prefix = Ctrl + a)
* Prefix + |         : Split paneel verticaal
* Prefix + -         : Split paneel horizontaal
* Prefix + h/j/k/l   : Wissel tussen panelen
* Prefix + z         : Zoom paneel (Fullscreen in terminal)
* Prefix + y         : SYNC MODE (Typ in alle panelen tegelijk)
* Prefix + P         : LOGGING (Start/Stop opslaan van sessie naar bestand)
* Prefix + d         : Detach (Verlaat Tmux, sessie blijft draaien)
* Prefix + [         : Scroll modus (gebruik pijltjestoetsen om omhoog te kijken)

## ☁️ DevOps & CLI Aliassen
* k                  : kubectl
* ldo                : lazydocker (Beheer Docker & Podman visueel)
* p                  : podman (Lichte Docker vervanger)
* n                  : nnn (File manager. Type ';' dan 'p' voor previews)
* ctx / ns           : Snel wisselen van K8s context of namespace
* v up               : vagrant up --provider=libvirt
* v ssh              : vagrant ssh

## ✍️ Neovim (IDE)
* Ctrl + p           : Telescope (Snel bestanden zoeken in je project)
* :q!                : Sluiten zonder opslaan
* :wq                : Opslaan en sluiten
