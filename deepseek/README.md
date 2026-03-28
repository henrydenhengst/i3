```bash
ansible-playbook setup.yml -K
```

```
# Installeer alle tools
ansible-playbook devops-cli-tools.yml -K

# Installeer alleen specifieke tools (via vars aanpassen of --extra-vars)
ansible-playbook devops-cli-tools.yml -K -e "install_kubectl=true install_helm=true install_terraform=true"

# Voor snelle installatie van kern tools
ansible-playbook devops-cli-tools.yml -K -e "install_kubectl=true install_helm=true install_terraform=true install_ansible=true install_jq=true install_ripgrep=true"
```