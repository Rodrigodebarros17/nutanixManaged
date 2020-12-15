<div align="justify">
 
# nutanixManaged

Este playbook tem como objetivo automatizar tarefas no paravirtualizador Nutanix. Todas as tarefas podem ser executadas a partir de suas respectivas tags. Segue abaixo uma imagem ilustrativa com todas as tarefas e suas respectivas tags:

![Alt text](img/1-tasks.png?raw=true "List Tasks")
##### Obs:. A mesma saída ilustrada na imagem acima, pode ser obtida através do comando:

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
* Script em lote (.bat)
* Powershell
* Nutanix API REST v2
</div>
<div align="justify">
 
## Guia de Utilização

Neste guia de utilização está descrito detalhadamente todos os processos necessários para a exucação de cada task e suas respectivas tags. Logo abaixo você pode visualizar todas as tasks organizadas em uma estrutura de tópico, contendo os detalhes para a sua utilização.
</div>

<a name="ancora"></a>
## Tópicos
- [Criar uma VM Linux](#ancora1)
- [Criar uma VM Windows](#ancora2)
- [Criar Snapshots por grupo de VMs](#ancora3)
- [Deletar Snapshots que foram criados por grupo de VMs ](#ancora4)
- [Deletar todos os snapshots](#ancora5)
- [Montar CD-ROM por grupo de VMs](#ancora6)
- [Desmontar CD-ROM por grupo de VMs](#ancora7)
- [Habilitar o NGT por grupo de VMs](#ancora8)
- [Desabilitar o NGT por grupo de VMs](#ancora9)
- [Atualizar NGT em VMs Linux](#ancora10)
- [Atualizar NGT em VMs Windows](#ancora11)

<div align="justify">

<a id="ancora1"></a>

### 1. Criar uma nova VM linux CentOS7:

>

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

    Irá realizar a instalação do Nutanix Guest Tools - NGT na sua última versão.

* **TASK: Create Users Linux Homologação | TAG: createUsersLinuxHomologacao:**

    Irá criar os usuários do cliente para VMs disponibilizadas no ambiente de homologação, bem como o usuário de acesso da Agility.

* **TASK: Create Users Linux Produção | TAG: createUsersLinuxProducao:**
 
    Irá criar os usuários do cliente para VMs disponibilizadas no ambiente de produção, bem como o usuário de acesso da Agility.
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

### 1.3. Primeira etapa de execução das tasks:

Nesta primeira etapa, será executada as tasks responsáveis por cirar a VM, Montar o dirve de CD-ROM, e realizar o resize do disco da VM a partir do Nutanix.

##### Exemplo de execução das tasks:

```
ansible-playbook -i hosts playbook.yml --ask-vault-pass --tags "createVmLinuxTemplateCentos, attachCdromNGTSpecificVms, resizeDiskNutanixLinux" -vvv

```
##### Obs:. Após a execução dessas tasks, já saberemos qual o IP da VM criada, e iremos adicioná-la ao inventário do ansible para dar continuidade na execução das demais tasks.

</div>
<div align="justify">

### 1.4. Segunda etapa de execução das tasks:
Nesta segunda etapa, será executada as tasks responsáveis por realizar o resize da partição LVM, update do OS, instalação no NGT e criar os usuários da VM, dependendo do ambiente ao qual a VM será disponibilizada (Homologação ou Produção). Dando continuidade, agora podemos acessar a WEB-GUI do Nutanix, e no menu, na opção VMs, iremos filtrar a busca com o nome da VM que acabamos de criar. Assim podemos visualizar o endereço IP atribuído a essa VM, e adicioná-la ao inventário do ansible, no arquivo **hosts**, no grupo **[newLinuxVMsCreated]** para executar as demais tasks. Conforme as imagens a seguir.

![Alt text](img/4-newVM.png?raw=true "New VM - List IP")

![Alt text](img/5-hostsFile.png?raw=true "New VM - Hosts File Ansible")

##### Exemplo de execução das tasks:

```
ansible-playbook -i hosts playbook.yml --ask-vault-pass --tags "resizePartitionVMLinux, updateOSLinux, installNGTLinux, createUsersLinuxHomologacao" -vvv

```
[Topo](#ancora1)

</div>

<div align="justify">

<a id="ancora2"></a>

### 2. Criar uma nova VM Windows 2012R2:

>

Para criar uma nova VM Windows 2012R2, apenas uma task será executada no processo de automação, pois logo após a criação da VM, a mesma não ficará disponível na rede, impossibilitando a continuidade da automação. Ela é:

* **TASK: Create VM Windows2012R2 | TAG: createVmWindowsTemplate2012R2:**

    Irá criar uma nova VM Windows 2012R2 com a definição do nome da VM que será mostrada na WEB-GUI do nutanix, bem como todas as definições de requisitos de hardware, como; CPU, Memória, Disco e Rede.

### 2.1. Configuração do arquivo de variáveis para a criação da VM:

Dentro do diretório vars/ no arquivo main.yml você irá atribuir os valores das variáveis de configuração da nova VM a ser criada. Conforme a imagem ilustrativa abaixo:

![Alt text](img/6-configVarsNewVM2.png?raw=true "Config Vars - New VM")

</div>
<div align="justify">
 
##### Obs:. Por padrão, a imagem utilizada para essa VM, irá criar um disco com 35GB de capacidade de armazenamento.

##### Exemplo:

```
vm_name_nutanix_display: "VM-WINDOWS-TEST"
num_vcpus: "1"
num_cores_per_vcpu: "1"
memory: "4"                            # Value in GB
network: "LAN_K8S_10.50.4.0/24"
resize_partition: "50"                 # New value in GB
hostname_vm_windows: "WinSQL-Server"
```
##### Exemplo de execução da task:

```
ansible-playbook -i hosts playbook.yml --ask-vault-pass --tags createVmWindowsTemplate2012R2 -vvv

```

### 2.2. Configuração do arquivo vmsListName.txt para realizar a montagem do drive de CD-ROM:

Dentro do diretório files/ no arquivo vmsListName.txt você irá adicionar o nome da VM previamente configurada no vars/main.yml, na variável "vm_name_nutanix_display". Conforme o exemplo da figura abaixo.

![Alt text](img/14-vmsListName.png?raw=true "Config vmsListName.txt - Mount CD-ROM")

</div>

<div align="justify">
 
### 2.3. Adicionando o IP da VM ao inventário do ansible:

Acesse a WEB-GUI do Nutanix, e no menu, na opção VMs, iremos filtrar a busca com o nome da VM que acabamos de criar. Assim podemos visualizar o endereço IP atribuído a essa VM, e adicioná-la ao inventário do ansible, no arquivo **hosts**, no grupo **[newWindowsVMsCreated]** para executar as demais tasks, conforme as imagens a seguir.

![Alt text](img/13-vmWindowsDisplayNutanix.png?raw=true "Display Nutanix - New VM Win")

![Alt text](img/12-addNewVmWindowsIventory.png?raw=true "Add Inventory - New VM Win")
 
</div>


[Topo](#ancora2)

</div>

<div align="justify">

<a id="ancora3"></a>

### 3. Criar Snapshots por grupo de VMs:

>

Para criar spanapshots de um grupo de VMs, apenas uma task será executada no processo de automação. Ela é:

* **TASK: Create Snapshot VMs Group | TAG: createSnapshotVmsGroup:**

    Irá criar snapshots de todas as VMs pertecentes a um mesmo grupo.
    
### 3.1. Configuração do arquivo de variáveis para criar os snapshots por grupo de VMs:

Dentro do diretório vars/ no arquivo main.yml você irá atribuir os valores das variáveis **"vms_group_prefix"** e **"snapshot_name"**, onde para a primeira variável você irá atribuir o nome do grupo de VMs que deseja criar os snapshots, na segunda, o nome do snapshot, que será comum para todas as VMs pertecentes ao grupo atribuído como valor na variável anterior. Segue imagem ilustrativa abaixo:

![Alt text](img/7-snapshotGroup.png?raw=true "Snapshot - VM Group")

</div>
<div align="justify">
 
##### Exemplo de configuração das variáveis:

```
vms_group_prefix: "SRM-HOMOLOGACAO-LINUX"
snapshot_name: "updateOS"

```
Após realizar a atribuição dos valores para as variáveis, já podemos executar a task.

##### Exemplo de execução da task:

```
ansible-playbook -i hosts playbook.yml --ask-vault-pass --tags createSnapshotVmsGroup -vvv

```

</div>

[Topo](#ancora3)

</div>
<div align="justify">

<a id="ancora4"></a>

### 4. Deletar Snapshots que foram criados por grupo de VMs:

>

Para deletar os spanapshots que foram criados por grupo de VMs, apenas uma task será executada no processo de automação. Ela é:

* **TASK: Delete Snapshot VMs Group | TAG: deleteSnapshotVmsGroup:**

    Irá deletar os snapshots de todas as VMs pertecentes a um mesmo grupo a partir do nome do snapshot definido durante a sua criação.
    
### 4.1. Configuração do arquivo de variáveis para deletar os snapshots criados por grupo de VMs:

Dentro do diretório vars/ no arquivo main.yml você irá atribuir o valor da variável **"snapshot_name"**, onde esse valor deve ser correspondente ao nome do snapshot definido durante a criação dos mesmos. Segue imagem ilustrativa abaixo:

![Alt text](img/8-deleteSnapshotGroup.png?raw=true "Delete Snapshot - VM Group")

</div>
<div align="justify">
 
##### Exemplo de configuração da variável:

```
snapshot_name: "updateOS"

```
Após realizar a atribuição do valor da variável, já podemos executar a task.

##### Exemplo de execução da task:

```
ansible-playbook -i hosts playbook.yml --ask-vault-pass --tags deleteSnapshotVmsGroup -vvv

```

</div>

[Topo](#ancora4)

</div>

<div align="justify">

<a id="ancora5"></a>

### 5. Deletar todos os Snapshots existentes no Nutanix:

>

Para deletar todos os snapshots existentes no Nutanix, apenas uma task será executada no processo de automação. Ela é:

* **Delete All Snapshot VMs | TAG: deleteAllSnapshotVms:**

    Irá deletar todos os snapshots de todas as VMs existentes no Nutanix. **Obs.** Para executar essa task, não é necessário configuração de variáveis.
    
<div align="justify">
 

##### Exemplo de execução da task:

```
ansible-playbook -i hosts playbook.yml --ask-vault-pass --tags deleteAllSnapshotVms -vvv

```

</div>

[Topo](#ancora5)

</div>

<div align="justify">

<a id="ancora6"></a>

### 6. Montar CD-ROM por grupo de VMs:

>

Para montar o drive de CD-ROM por grupo de VMs, apenas uma task será executada no processo de automação. Ela é:

* **Attach CDROM NGT VMs Group | TAG: attachCdromNGTVmsGroup:**

    Irá montar o drive de CD-ROM para todo um grupo de VMs.

### 6.1. Configuração do arquivo de variáveis para montar o drive de CD-ROM por grupo de VMs:

Dentro do diretório vars/ no arquivo main.yml você irá atribuir o valor da variável **"vms_group_prefix"**, onde esse valor deve ser o nome do grupo de VMs que você deseja realizar a montagem. Segue imagem ilustrativa abaixo:

![Alt text](img/9-mountCDROMGroups.png?raw=true "Mount CD-ROM - VM Group")

<div align="justify">
 
##### Exemplo de configuração da variável:

```
vms_group_prefix: "SRM-HOMOLOGACAO-LINUX"

```
Após realizar a atribuição do valor da variável, já podemos executar a task.

##### Exemplo de execução da task:

```
ansible-playbook -i hosts playbook.yml --ask-vault-pass --tags attachCdromNGTVmsGroup -vvv

```

</div>

[Topo](#ancora6)

</div>

<div align="justify">

<a id="ancora7"></a>

### 7. Desmontar CD-ROM por grupo de VMs:

>

Para desmontar o drive de CD-ROM por grupo de VMs, apenas uma task será executada no processo de automação. Ela é:

* **Dettached CDROM NGT VMs Group | TAG: dettachedCdromNGTVmsGroup:**

    Irá desmontar o drive de CD-ROM para todo um grupo de VMs.

### 7.1. Configuração do arquivo de variáveis para desmontar o drive de CD-ROM por grupo de VMs:

Dentro do diretório vars/ no arquivo main.yml você irá atribuir o valor da variável **"vms_group_prefix"**, onde esse valor deve ser o nome do grupo de VMs que você deseja realizar a desmontagem. Segue imagem ilustrativa abaixo:

![Alt text](img/9-mountCDROMGroups.png?raw=true "Unmount CD-ROM - VM Group")

<div align="justify">
 
##### Exemplo de configuração da variável:

```
vms_group_prefix: "SRM-HOMOLOGACAO-LINUX"

```
Após realizar a atribuição do valor da variável, já podemos executar a task.

##### Exemplo de execução da task:

```
ansible-playbook -i hosts playbook.yml --ask-vault-pass --tags dettachedCdromNGTVmsGroup -vvv

```

</div>

[Topo](#ancora7)

</div>

<div align="justify">

<a id="ancora8"></a>

### 8. Habilitar NGT por grupo de VMs:

>

Para habilitar o NGT por grupo de VMs, apenas uma task será executada no processo de automação. Ela é:

* **Enable NGT VMs Group | TAG: enableNGT:**

    Irá habilitar o NGT para todo um grupo de VMs.

### 8.1. Configuração do arquivo de variáveis para habilitar o NGT por grupo de VMs:

Dentro do diretório vars/ no arquivo main.yml você irá atribuir o valor da variável **"vms_group_prefix"**, onde esse valor deve ser o nome do grupo de VMs que você deseja que o NGT seja habilitado. Segue imagem ilustrativa abaixo:

![Alt text](img/9-mountCDROMGroups.png?raw=true "NGT true - VM Group")

<div align="justify">
 
##### Exemplo de configuração da variável:

```
vms_group_prefix: "SRM-HOMOLOGACAO-LINUX"

```
Após realizar a atribuição do valor da variável, já podemos executar a task.

##### Exemplo de execução da task:

```
ansible-playbook -i hosts playbook.yml --ask-vault-pass --tags enableNGT -vvv

```

</div>

[Topo](#ancora8)

</div>

<div align="justify">

<a id="ancora9"></a>

### 9. Desabilitar NGT por grupo de VMs:

>

Para desabilitar o NGT por grupo de VMs, apenas uma task será executada no processo de automação. Ela é:

* **Disable NGT VMs Group | TAG: disableNGT:**

    Irá desabilitar o NGT para todo um grupo de VMs.

### 9.1. Configuração do arquivo de variáveis para desabilitar o NGT por grupo de VMs:

Dentro do diretório vars/ no arquivo main.yml você irá atribuir o valor da variável **"vms_group_prefix"**, onde esse valor deve ser o nome do grupo de VMs que você deseja que o NGT seja desabilitado. Segue imagem ilustrativa abaixo:

![Alt text](img/9-mountCDROMGroups.png?raw=true "NGT false - VM Group")

<div align="justify">
 
##### Exemplo de configuração da variável:

```
vms_group_prefix: "SRM-HOMOLOGACAO-LINUX"

```
Após realizar a atribuição do valor da variável, já podemos executar a task.

##### Exemplo de execução da task:

```
ansible-playbook -i hosts playbook.yml --ask-vault-pass --tags disableNGT -vvv

```

</div>

[Topo](#ancora9)

</div>

<div align="justify">

<a id="ancora10"></a>

### 10. Atualizar NGT em VMs Linux:

>

Para atualizar o NGT em uma VM Linux, apenas uma task será executada no processo de automação. Ela é:

* **Install/Update NGT Linux | TAG: updateNGTLinux:**

    Irá atualizar o NGT para a última versão disponível.

### 10.1. Adicionar o IP da VM no iventário do ansible.

No arquivo hosts, no grupo "vmsInstallUpdateNGTLinux", você irá inserir o IP da VM que deseja fazer a atualização do NGT, conforme a figura a seguir.

![Alt text](img/10-updateNGTLinux.png?raw=true "Update NGT - Linux")

</div>

##### Exemplo de execução da task:

```
ansible-playbook -i hosts playbook.yml --ask-vault-pass --tags updateNGTLinux -vvv

```

[Topo](#ancora10)

</div>

<div align="justify">

<a id="ancora11"></a>

### 11. Atualizar NGT em VMs Windows:

>

Para atualizar o NGT em uma VM Windows, apenas uma task será executada no processo de automação. Ela é:

* **Install/Update NGT Windows | TAG: updateNGTWindows:**

    Irá atualizar o NGT para a última versão disponível.

### 11.1. Adicionar o IP da VM no iventário do ansible.

No arquivo hosts, no grupo "vmsInstallUpdateNGTWindows", você irá inserir o IP da VM que deseja fazer a atualização do NGT, conforme a figura a seguir.

![Alt text](img/11-updateNGTWindows.png?raw=true "Update NGT - Windows")

</div>

##### Exemplo de execução da task:

```
ansible-playbook -i hosts playbook.yml --ask-vault-pass --tags updateNGTWindows -vvv

```

[Topo](#ancora11)

</div>










