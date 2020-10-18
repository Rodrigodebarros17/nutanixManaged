# nutanixManaged
Este playbook tem como objetivo automatizar tarefas no paravirtualizador nutanix. Todas as tarefas podem ser executadas a partir de suas respectivas tags. Segue abaixo uma imagem ilustrtiva com todas as tarefas e suas respectivas tags:

![Alt text](img/1-tasks.png?raw=true "List Tasks")

A mesma saída, ilustrada na imagem acima pode ser obtida através do comando:

```
ansible-playbook -i hosts playbook.yml --ask-vault-pass --list-task -vvv

```

## Pré Requisitos

* ansible 2.9.7 ou superior
* ansible-vault 2.9.7 ou superior


