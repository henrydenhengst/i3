# Opdracht WM voor DevOps / SysAmin

## Context

*5 verschillende AI hebben 27 maart 2026 de volgende opdracht gekregen:*

Maak een (modulair) Ansible playbook dat:
- Werkt op 2 primaire distro families: Debian-based RedHat-based
- Optioneel support biedt voor: Arch (best effort) Alpine (CLI-only fallback)
- i3 en lightdm installeert op een minimale installatie (geen full desktop)
- GUI apps optioneel maakt: Kitty (verplicht) Falkon (feature flag) of Firefox als plan B
- Nord theme toepast op: i3 terminal cli tools. dmlight en i3wm in dezelfde style met dezelfde Nord wallpaper.
- DevOps stack installeert via: officiële bronnen (niet distro packages waar mogelijk)
- Werkt met feature flags: enable_gui enable_vagrant enable_docker enable_browser
- Documentatie: verplicht
- Extra: Een snelle, stabiele en eenvoudig setup is een pre.

*Het resultaat was dat ze alle 5 niet voldeden omdat het niet snel en eenvoudig kon worden uitgevoerd, dus hebben ze alle 5 de volgende herkansing gekregen:*

Wat me opvalt is dat de code zo wordt aangeboden, dat ik nog een dag aan het plakken en knippen ben voor ik uberhaupt kan beginnen.

Dat is niet wat ik bedoel met snel noch eenvoudig.

Zou je je hierin willen verbeteren?

*De resultaten zijn te vinden in hun respectievelijke directory.*