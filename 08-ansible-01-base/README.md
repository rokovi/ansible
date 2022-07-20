# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
```bash
new0ne@new0ne-dp:~/hw/ansible/8.1/playbook$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] ******************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************
ok: [localhost]

TASK [Print OS] ************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP *****************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
```bash
new0ne@new0ne-dp:~/hw/ansible/8.1/playbook$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] ******************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************
ok: [localhost]

TASK [Print OS] ************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *****************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
```bash
new0ne@new0ne-dp:~/hw/ansible/8.1/playbook$ docker run -it --name=centos7 -d centos /bin/bash
new0ne@new0ne-dp:~/hw/ansible/8.1/playbook$ docker run -it --name=ubuntu -d fnndsc/ubuntu-python3
```
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
```bash
new0ne@new0ne-dp:~/hw/ansible/8.1/playbook$ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] ******************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP *****************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
6. Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
```bash
new0ne@new0ne-dp:~/hw/ansible/8.1/playbook$ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] ******************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *****************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
```bash
new0ne@new0ne-dp:~/hw/ansible/8.1/playbook$ ansible-vault encrypt group_vars/deb/examp.yml
new0ne@new0ne-dp:~/hw/ansible/8.1/playbook$ ansible-vault encrypt group_vars/el/examp.yml
```
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
```bash
new0ne@new0ne-dp:~/hw/ansible/8.1/playbook$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] ******************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *****************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
```bash
new0ne@new0ne-dp:~/hw/ansible/8.1/playbook$ ansible-doc -t connection -l
buildah      Interact with an existing buildah container
chroot       Interact with local chroot
docker       Run tasks in docker containers
funcd        Use funcd to connect to target
httpapi      Use httpapi to run command on network appliances
iocage       Run tasks in iocage jails
jail         Run tasks in jails
kubectl      Execute tasks in pods running on Kubernetes
libvirt_lxc  Run tasks in lxc containers via libvirt
local        execute on controller
lxc          Run tasks in lxc containers via lxc python library
lxd          Run tasks in lxc containers via lxc CLI
napalm       Provides persistent connection using NAPALM
netconf      Provides a persistent connection using the netconf protocol
network_cli  Use network_cli to run command on network appliances
oc           Execute tasks in pods running on OpenShift
paramiko_ssh Run tasks via python ssh (paramiko)
persistent   Use a persistent unix socket for connection
podman       Interact with an existing podman container
psrp         Run tasks over Microsoft PowerShell Remoting Protocol
qubes        Interact with an existing QubesOS AppVM
saltstack    Allow ansible to piggyback on salt minions
ssh          connect via ssh client binary
vmware_tools Execute tasks inside a VM via VMware Tools
winrm        Run tasks over Microsoft's WinRM
zone         Run tasks in a zone instance
```
`local` - для работы на `control node`
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
```bash
new0ne@new0ne-dp:~/hw/ansible/8.1/playbook$ cat inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  lhost:
    hosts:
      local:
        ansible_connection: local
```
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
```bash
new0ne@new0ne-dp:~/hw/ansible/8.1/playbook$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] ******************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************
ok: [local]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ************************************************************************************************************************************
ok: [local] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************************************
ok: [local] => {
    "msg": "all default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *****************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
local                      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
```bash
new0ne@new0ne-dp:~/hw/ansible/8.1/playbook$ ansible-vault decrypt group_vars/deb/examp.yml group_vars/el/examp.yml
```
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
```bash
new0ne@new0ne-dp:~/hw/ansible/8.1/playbook$ ansible-vault encrypt_string 'PaSSw0rd' --name 'some_fact'
New Vault password:
Confirm New Vault password:
some_fact: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          34383931343166313531356264396235356566653063373830346331396137343533333064613439
          3164383530623538346233366132613539613963613766650a333364376566646165366235356330
          37353962663163386237633737636239336339626535353863366663313163623865346162633264
          3164346261363862320a636135323463633633306462623837386562636434383039343763313737
          6164
Encryption successful
```
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
```bash
new0ne@new0ne-dp:~/hw/ansible/8.1/playbook$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] ******************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************
ok: [local]
ok: [centos7]
ok: [ubuntu]

TASK [Print OS] ************************************************************************************************************************************
ok: [local] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************************************
ok: [local] => {
    "msg": "PaSSw0rd"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *****************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
local                      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).
```bash
new0ne@new0ne-dp:~/hw/ansible/8.1/playbook$ docker run -it --name=fedora -d pycontribs/fedora /bin/bash
new0ne@new0ne-dp:~/hw/ansible/8.1/playbook$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] ******************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************
ok: [local]
ok: [ubuntu]
ok: [fedora]
ok: [centos7]

TASK [Print OS] ************************************************************************************************************************************
ok: [local] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print fact] **********************************************************************************************************************************
ok: [local] => {
    "msg": "PaSSw0rd"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [fedora] => {
    "msg": "Fedora"
}

PLAY RECAP *****************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
local                      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
```bash
#!/usr/bin/env bash

# Run ness containers
docker run -it --name=centos7 -d centos /bin/bash > /dev/null
echo "centos7 started successfully"
docker run -it --name=ubuntu -d fnndsc/ubuntu-python3 > /dev/null
echo "ubuntu started successfully"
docker run -it --name=fedora -d pycontribs/fedora /bin/bash > /dev/null
echo "fedora started successfully"

# run ans playbook
ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass

# stop and remove containers
docker stop fedora ubuntu centos7 > /dev/null
docker rm fedora ubuntu centos7 > /dev/null
echo "all containers has been removed"
```
6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

---

