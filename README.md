```bash
ansible-playbook setup_i3.yml --ask-become-pass
```

# Functionele Beschrijving: Nordic DevOps & Sysadmin Workstation

Dit Ansible playbook transformeert een standaard Linux-omgeving naar een professioneel "God-Mode" workstation. Het systeem is volledig geoptimaliseerd voor snelheid, visuele rust (Nord-thema) en diepe technische controle.

---

### 1. Interface & Desktop Management (GUI)
* **Tiling Window Manager:** Gebruikt i3-wm voor efficiënt vensterbeheer. De focus ligt op keyboard-driven navigatie met Nord-accenten (#88c0d0).
* **Dynamische Wallpaper:** Gebruikt de bestaande map `/usr/share/backgrounds/` om bij elke start een willekeurige achtergrond in te stellen via feh.
* **Compositor:** Picom zorgt voor vloeiende overgangen en transparantie zonder prestatieverlies.
* **Status & Launchers:** Polybar toont systeemkritieke info (CPU, RAM, Tijd). Rofi dient als de centrale, doorzoekbare applicatie-launcher.
* **Browsing:** Inclusief Falkon, een ultra-lichtgewicht browser geconfigureerd met AdBlock en privacy-instellingen voor snelle toegang tot documentatie.

### 2. De Terminal Cockpit (Kitty & Tmux)
* **GPU-Accelerated Terminal:** Kitty dient als de snelle basis met ondersteuning voor afbeeldingen en Nerd Fonts.
* **Multiplexer:** Tmux start automatisch en is uitgebreid met sysadmin-functies:
    * **Pane Synchronization:** Typ in meerdere vensters tegelijk (ideaal voor cluster-beheer).
    * **Session Logging:** Sla je volledige sessie-output op naar een tekstbestand voor audit-trails.
    * **Vim-Navigatie:** Gebruik h, j, k, l om tussen terminal-vensters te schakelen.
* **Statusinformatie:** De statusbalk toont live je huidige Kubernetes-context (☸).

### 3. Shell Engine & Intelligentie (Zsh)
* **Standaard Shell:** Volledige migratie naar Zsh met de Starship-prompt.
* **Productiviteit:** * **Autosuggestions:** Voorspelt je commando's op basis van historie.
    * **Syntax Highlighting:** Kleurt commando's groen (correct) of rood (fout) tijdens het typen.
    * **Zoxide & FZF:** Slimme navigatie door mappen en "fuzzy" zoeken naar bestanden.
* **Automatisering:** SSH-Agent start zelfstandig op en laadt je keys bij inloggen om constante wachtwoord-prompts te voorkomen.

### 4. DevOps & Cloud Gereedschapskist
* **Kubernetes Suite:** Bevat kubectl, k9s (met Nord-skin), helm, stern (logs) en kubectx/ns voor razendsnel schakelen tussen clusters.
* **Container Beheer:** Lazydocker voor visuele controle over containers en volumes; Dive voor het inspecteren van image-lagen.
* **Infrastructure as Code:** Terraform, Ansible-lint en TFLint voor het valideren van je code.
* **Modern Unix Tools:** Vervangt oude commando's door snellere alternatieven zoals eza (ls), bat (cat), gping (ping) en duf (df).

### 5. File Management & Editing
* **nnn File Manager:** Geconfigureerd met de `preview-tui` plugin voor directe weergave van afbeeldingen (JPG/PNG), PDF's en video-thumbnails in de terminal.
* **Neovim (Sysadmin IDE):** Een krachtige editor met:
    * **LSP Integratie:** Real-time syntax-check voor YAML, Ansible en Terraform.
    * **Telescope:** Zoek binnen milliseconden naar bestanden met Ctrl+P.
    * **Indent Guidelines:** Visuele hulp bij het uitlijnen van complexe YAML-bestanden.

---
**Opmerking:** Na het draaien van het playbook is éénmalig uitloggen en opnieuw inloggen vereist om de overstap naar Zsh en de i3-omgeving te voltooien.

