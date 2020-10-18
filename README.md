<div align="justify">
 
# nutanixManaged

Este playbook tem como objetivo automatizar tarefas no paravirtualizador Nutanix. Todas as tarefas podem ser executadas a partir de suas respectivas tags. Segue abaixo uma imagem ilustrativa com todas as tarefas e suas respectivas tags:

![Alt text](img/1-tasks.png?raw=true "List Tasks")
 mesma saída ilustrada na imagem acima, pode ser obtida através do comando:

```
ansible-playbook -i hosts playbook.yml --ask-vault-pass --list-task -vvv

```
</div>
<div align="justify">
 
## Pré Requisitos

* ansible 2.9.7 ou superior
* ansible-vault 2.9.7 ou superior
* Uma VM com um compartilhamento CIFS na rede, contendo os arquivos de instalação do Nutanix Guest Tools - NGT
</div>
<div align="justify">
 
## Tecnologias Utilizadas

* VScode
* Ansible
* Ansible Vault
* Ansible Galaxy
* CLI nutanix: acli e ncli
* Shell Script
* Nutanix API REST v2
* Script em lote (.bat)
</div>
<div align="justify">
 
## Guia de Utilização

Neste guia de utilização está descrito detalhadamente todos os processos necessários para a exucação de cada task e suas respectivas tags. Logo abaixo você pode visualizar todas as tasks organizadas em uma estrutura de lista, contendo os detalhes para a sua utilização.
</div>
<div align="justify">
 
### 1. Criar uma nova VM linux CentOS7:

Para criar uma nova VM linux, as tasks a serem executadas para disponibilizar a mesma para o cliente são:
</div>
<div align="justify">
 
* **TASK: Create VM Linux Centos7  | TAG: createVmLinuxTemplateCentos:**

    Irá criar uma nova VM Linux CentOS7 com a definição do nome da VM que será mostrada na WEB-GUI do nutanix, bem como todas as definições de requisitos de hardware, como; CPU, Memória, Disco e Rede.

* **TASK: Attach CDROM NGT Specific VMs | TAG: attachCdromNGTSpecificVms:**

    Irá montar o Drive de CD-ROM na VM a ser criada. **Obs.** Pré requisito para posteriormente realizar a instalação do Nutanix Guest Tools - NGT.

* **TASK: Resize Disk Nutanix VM Linux Centos7 | TAGS: resizeDiskNutanixLinux:**

    Irá redimensionar o disco da VM a partir do Nutanix.

* **TASK: Resize Partition VM Linux Centos7 | TAGS: resizePartitionVMLinux:**

    Irá redimencionar a partição lógica LVM na VM, de acordo com o valor redimensionado pelo Nutanix.

* **TASK: Update OS VM Linux Centos7 | TAG: updateOSLinux:**

    Irá realizar o update da release da distro, kernel, removendo o kernel antigo e atualizando os pacotes do repositório Base.

* **TASK: Install/Update NGT Linux | TAG: installNGTLinux:**

    Irá realizar a instalação no Nutanix Guest Tools - NGT na sua última versão.

* **TASK: Create Users Linux Homologação | TAG: createUsersLinuxHomologacao:**

    Irá criar os usuários do cliente para VMs disponibilizadas no ambiente de homologação, bem como o usuário de acesso da agility.

* **TASK: Create Users Linux Produção | TAG: createUsersLinuxProducao:**
 
    Irá criar os usuários do cliente para VMs disponibilizadas no ambiente de produção, bem como o usuário de acesso da agility.
</div>
<div align="justify">

### 1.1. Configuração do arquivo de variáveis para a criação da VM:

Dentro do diretório vars/ no arquivo main.yml você irá atribuir os valores das variáveis de configuração da nova VM a ser criada. Conforme a imagem ilustrativa abaixo:

![Alt text](img/2-configVarsNewVM.png?raw=true "Config Vars - New VM")

</div>
<div align="justify">
 
##### Obs:. Por padrão, a imagem utilizada para essa VM, irá criar um disco com 10GB de capacidade de armazenamento. Caso o cliente deseje uma VM com maior capacidade de armazenamento, você poderá configurar a variável "resize_partition" para definir um novo valor, de acordo com a demanda especificada pelo cliente.

##### Exemplo:

```
vm_name_nutanix_display: "VM-LINUX-TEST"
num_vcpus: "2"
num_cores_per_vcpu: "1"
memory: "4"                             # Valor em GB
network: "LAN_K8S_10.50.4.0/24"
resize_partition: "30"                  # Valor em GB

```
</div>
<div align="justify">
 
### 1.2. Configuração do arquivo vmsListName.txt para realizar a montagem do drive de CD-ROM:

Dentro do diretório files/ no arquivo vmsListName.txt você irá adicionar o nome da VM previamente configurada no vars/main.yml, na variável **"vm_name_nutanix_display"**. Conforme o exemplo da figura abaixo.

![Alt text](img/3-vmsListName.png?raw=true "Config vmsListName.txt - Mount CD-ROM")

</div>
<div align="justify">

### 1.2. Primeira etapa de execução das tasks:

Nesta primeira etapa, será executada as tasks responsáveis por cirar a VM, Montar o dirve de CD-ROM, e realizar o resize do disco da VM a partir do Nutanix.

##### Exemplo:

```
ansible-playbook -i hosts playbook.yml --ask-vault-pass --tags "createVmLinuxTemplateCentos, attachCdromNGTSpecificVms, resizeDiskNutanixLinux" -vvv

```
##### Obs:. Após a execução dessas tasks, já saberemos qual o IP da VM criada, e iremos adicioná-la ao inventário do ansible para dar continuidade na execução das demais tasks.

</div>
<div align="justify">

### 1.2. Segunda etapa de execução das tasks:

Agora iremos acessar a WEB-GUI do Nutanix, e no menu, na opção VMs, iremos filtrar a busca com o nome da VM que acabamos de criar. Assim podemos visualizar o endereço IP atribuído a essa VM, e adicioná-la ao inventário do ansible para executar as demais tasks. Conforme as imagens a seguir.



</div>

