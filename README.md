# kubernetes-playground

## Installation
```bash
cd terraform
```

```bash
terraform apply
```

```bash
ssh -A ansible_user@$(terraform output ansible_controller_external_ip) -i ~/.ssh/id_rsa_ansible_user

cd ansible

ansible-playbook playbooks/prepare.yml
```