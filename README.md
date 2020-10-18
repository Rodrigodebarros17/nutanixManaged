# nutanixManaged
Este playbook tem como objetivo automatizar tarefas no paravirtualizador nutanix. Todas as tarefas podem ser executadas a partir de suas respectivas tags. Segue abaixo uma imagem ilustrtiva com todas as tarefas e suas respectivas tags:

![Alt text](img/1-tasks.png?raw=true "List Tasks")

A mesma saída ilustrada na imagem acima, pode ser obtida através do comando:

```
ansible-playbook -i hosts playbook.yml --ask-vault-pass --list-task -vvv

```

## Pré Requisitos

* ansible 2.9.7 ou superior
* ansible-vault 2.9.7 ou superior
* Uma VM com um compartilhamento CIFS na rede, contendo os arquivos de instalação do Nutanix Guest Tools - NGT

## Tecnologias Utilizadas

* Ansible
* Ansible Vault
* CLI nuatanix: acli e ncli
* Shell Script
* Nutanix API REST v2
* Script em lote (.bat)

## Guia de Utilização

Neste guia de utilização está descrito detalhadamente todos os processos necessários para a exucação de cada task e suas respectivas tags. Logo abaixo você pode visualizar todas as tasks organizadas em uma estrutura de lista, contendo os detalhes para a sua utilização.

#### 1. Criar uma nova VM linux CentOS 7:

Dentro do diretório vars/ no arquivo main.yml você irá atribuir os valores das variáveis de configuração da nova VM a ser criada. Conforme a imagem ilustrativa abaixo:

![Alt text](img/2-configVarsNewVM.png?raw=true "Config Vars - New VM")
