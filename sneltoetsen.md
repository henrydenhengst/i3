# ❄️ Nordic DevOps & Sysadmin Cheat Sheet (2026 Edition)
Geoptimaliseerd voor i3wm, Zsh, Tmux en Neovim.

## 🚀 Snelkoppelingen (i3 Desktop)
| Toetsencombinatie | Actie |
| :--- | :--- |
| `$mod + Enter` | Open Kitty (Start direct in **Tmux**) |
| `$mod + w` | Open Falkon (Browser - Workspace 1) |
| `$mod + d` | Open Rofi (Programma's zoeken) |
| `$mod + Shift + q` | Sluit actieve venster |
| `$mod + f` | Wissel tussen Fullscreen / Tegel |
| `$mod + Shift + r` | Herstart i3 (Nieuwe config + Random Wallpaper) |

## 📟 Tmux Cockpit (Binnen de Terminal)
*Let op: Prefix is `Ctrl + a`*

| Toetsencombinatie | Actie |
| :--- | :--- |
| `Prefix + |` | Split scherm verticaal |
| `Prefix + -` | Split scherm horizontaal |
| `Prefix + h/j/k/l` | Navigeer tussen panelen (Vim-stijl) |
| `Prefix + y` | **Sync Mode:** Typ in alle panelen tegelijk (Aan/Uit) |
| `Prefix + Shift + p` | **Audit Log:** Start/Stop loggen van sessie naar bestand |
| `Prefix + z` | Zoom in/uit op één paneel |

## 🛠️ DevOps & Sysadmin Tools
| Commando | Actie |
| :--- | :--- |
| `k` | Afkorting voor `kubectl` |
| `n` | Open `nnn` (Druk op `;p` voor Image Previews) |
| `ldo` | Open `lazydocker` |
| `k9s` | Open het Kubernetes Dashboard (Nord Theme) |
| `ctx` / `ns` | Wissel interactief van K8s Cluster of Namespace |

## 📝 Neovim (Sysadmin IDE)
| Toetsencombinatie | Actie |
| :--- | :--- |
| `Ctrl + p` | **Telescope:** Zoek razendsnel naar bestanden |
| `:LspInfo` | Check of Ansible/Terraform validatie actief is |
| `j / k` | Beweeg door regels (gebruikt relatieve nummers) |

## 🧭 Navigatie & Workspaces
| Toetsencombinatie | Actie |
| :--- | :--- |
| `$mod + 1` | Workspace 1: 󰖟 Web (Falkon) |
| `$mod + 2` | Workspace 2: 󰆍 Term (Kitty/Tmux) |
| `$mod + Shift + [1-4]` | Verplaats venster naar workspace 1, 2, 3 of 4 |

---
**Tip:** Omdat we `ssh-agent` in je `.zshrc` hebben gezet, hoef je bij het openen van je eerste terminal vaak maar één keer je wachtwoord in te vullen voor al je servers!
