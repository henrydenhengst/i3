cat << 'EOF' > /tmp/create-devops-cli-playbook.sh
#!/bin/bash
# === Apart CLI DevOps & SysAdmin tools playbook (2026) ===
# Snel, modulair, cross-distro (Debian/RedHat/Arch/Alpine)
set -e

DIR="devops-cli-tools"
echo "🚀 Aanmaken van apart DevOps CLI playbook in map: $DIR"

rm -rf $DIR 2>/dev/null || true
mkdir -p $DIR/{group_vars,roles/cli_tools/tasks}

cd $DIR

# === group_vars/all.yml (feature flags) ===
cat << 'VARS' > group_vars/all.yml
---
# Feature flags – zet uit wat je niet nodig hebt
enable_core: true          # basis sysadmin tools
enable_modern_cli: true    # bat, eza, fzf, ripgrep, zoxide, etc.
enable_docker: true        # officiële Docker CE
enable_terraform: true     # officiële HashiCorp
enable_kubernetes: true    # kubectl + helm + k9s
enable_gh_cli: true        # GitHub CLI
enable_zsh_starship: true  # zsh + Starship prompt

# Extra vars
username: "{{ ansible_user_id | default(ansible_user) }}"
k8s_version: "v1.32"       # pas aan als je een specifieke versie wilt
VARS

# === playbook.yml ===
cat << 'PLAY' > playbook.yml
---
- name: DevOps & SysAdmin CLI tools (apart playbook)
  hosts: all
  become: true
  vars_files:
    - group_vars/all.yml

  roles:
    - cli_tools
PLAY

# === roles/cli_tools/tasks/main.yml (alles in één rol voor snelheid) ===
cat << 'CLI' > roles/cli_tools/tasks/main.yml
---
- name: OS detectie
  set_fact:
    is_alpine: "{{ ansible_distribution == 'Alpine' }}"
    is_arch: "{{ ansible_distribution == 'Archlinux' }}"
    os_family: "{{ ansible_os_family }}"

- name: Update package cache
  package:
    update_cache: true
  when: not is_alpine

- name: EPEL repo voor RedHat (voor extra pakketten)
  package:
    name: epel-release
    state: present
  when: os_family == 'RedHat'

# === CORE CLI tools ===
- name: Core SysAdmin CLI tools
  package:
    name:
      - git
      - curl
      - wget
      - vim
      - neovim
      - htop
      - tmux
      - rsync
      - unzip
      - zip
      - tree
      - jq
      - yq
    state: present
  when: enable_core | bool

# === MODERN CLI tools ===
- name: Moderne CLI tools (bat, eza, fzf, ripgrep, etc.)
  package:
    name:
      - bat
      - eza
      - fzf
      - ripgrep
      - zoxide
      - "{{ 'fd-find' if os_family == 'Debian' else 'fd' }}"
    state: present
  when: enable_modern_cli | bool

# === DOCKER officiële repo + install ===
- name: Docker GPG key + repo (Debian-based)
  block:
    - get_url:
        url: https://download.docker.com/linux/{{ ansible_distribution | lower }}/gpg
        dest: /etc/apt/keyrings/docker.asc
        mode: '0644'
      when: os_family == 'Debian'
    - apt_repository:
        repo: "deb [arch={{ ansible_architecture | replace('x86_64','amd64') }} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/{{ ansible_distribution | lower }} {{ ansible_distribution_release }} stable"
        state: present
      when: os_family == 'Debian'
  when: enable_docker | bool and os_family == 'Debian'

- name: Docker repo (RedHat/Fedora)
  yum_repository:
    name: docker-ce
    description: Docker CE Official
    baseurl: https://download.docker.com/linux/fedora/$releasever/$basearch/stable
    gpgkey: https://download.docker.com/linux/fedora/gpg
    gpgcheck: true
    state: present
  when: enable_docker | bool and os_family == 'RedHat'

- name: Docker pakketten installeren
  package:
    name:
      - docker-ce
      - docker-ce-cli
      - containerd.io
      - docker-buildx-plugin
    state: present
  when: enable_docker | bool

- name: Docker service starten
  systemd:
    name: docker
    enabled: true
    state: started
  when: enable_docker | bool

# === TERRAFORM officiële HashiCorp repo ===
- name: HashiCorp GPG key + repo (Debian)
  block:
    - get_url:
        url: https://apt.releases.hashicorp.com/gpg
        dest: /usr/share/keyrings/hashicorp-archive-keyring.gpg
        mode: '0644'
      when: os_family == 'Debian'
    - apt_repository:
        repo: "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com {{ ansible_distribution_release }} main"
        state: present
      when: os_family == 'Debian'
  when: enable_terraform | bool and os_family == 'Debian'

- name: HashiCorp repo (RedHat)
  yum_repository:
    name: hashicorp
    description: HashiCorp Official
    baseurl: https://rpm.releases.hashicorp.com/RHEL/$releasever/$basearch/stable
    gpgkey: https://rpm.releases.hashicorp.com/gpg
    gpgcheck: true
    state: present
  when: enable_terraform | bool and os_family == 'RedHat'

- name: Terraform installeren
  package:
    name: terraform
    state: present
  when: enable_terraform | bool

# === KUBERNETES tools (kubectl, helm, k9s) ===
- name: Kubernetes CLI tools
  package:
    name:
      - kubectl
      - helm
      - k9s
    state: present
  when: enable_kubernetes | bool

# === GitHub CLI ===
- name: GitHub CLI (gh)
  package:
    name: gh
    state: present
  when: enable_gh_cli | bool

# === ZSH + Starship prompt ===
- name: Zsh + Starship
  package:
    name:
      - zsh
      - starship
    state: present
  when: enable_zsh_starship | bool

- name: Starship config voor gebruiker
  copy:
    content: |
      # Starship prompt (Nord compatible)
      [character]
      success_symbol = "[➜](bold green)"
      error_symbol = "[✗](bold red)"
    dest: "/home/{{ username }}/.config/starship.toml"
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: '0644'
  when: enable_zsh_starship | bool

- name: Zsh als default shell (optioneel – uncomment als gewenst)
  # user:
  #   name: "{{ username }}"
  #   shell: /usr/bin/zsh
  debug:
    msg: "Zsh is geïnstalleerd. Gebruik 'chsh -s $(which zsh)' om het als default in te stellen."
  when: enable_zsh_starship | bool

- name: Alpine / Arch / RedHat info
  debug:
    msg: "Playbook voltooid. Alle CLI tools zijn beschikbaar."
CLI

# === README.md ===
cat << 'README' > README.md
# DevOps & SysAdmin CLI Tools Playbook (apart)

**Doel**: Alle belangrijke CLI tools voor DevOps en SysAdmins op een minimale installatie.

**Ondersteund**:
- Debian / Ubuntu
- RedHat / Fedora / Rocky
- Arch Linux (best effort)
- Alpine (CLI-only)

**Feature flags** in `group_vars/all.yml`

**Gebruik** (één commando):
```bash
cd devops-cli-tools
ansible-playbook -i localhost, playbook.yml --become