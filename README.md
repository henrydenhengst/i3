# Opdracht WM voor DevOps / SysAmin

Maak een (modulair) Ansible playbook dat:
- Werkt op 2 primaire distro families: Debian-based RedHat-based
- Optioneel support biedt voor: Arch (best effort) Alpine (CLI-only fallback)
- i3 en dmlight installeert op een minimale installatie (geen full desktop)
- GUI apps optioneel maakt: Kitty (verplicht) Falkon (feature flag) of Firefox als plan B
- Nord theme toepast op: i3 terminal cli tools. dmlight en i3wm in dezelfde style met dezelfde Nord wallpaper.
- DevOps stack installeert via: officiële bronnen (niet distro packages waar mogelijk)
- Werkt met feature flags: enable_gui enable_vagrant enable_docker enable_browser
- Documentatie: verplicht
- Extra: Een snelle, stabiele en eenvoudig setup is een pre.