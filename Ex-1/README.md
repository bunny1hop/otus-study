# Занятие 1. Vagrant-стенд для обновления ядра и создания образа системы
Цель домашнего задания
Научиться обновлять ядро в ОС Linux. Получение навыков работы с Vagrant, Packer и публикацией готовых образов в Vagrant Cloud. 
Описание домашнего задания
1) Обновить ядро ОС из репозитория ELRepo
2) Создать Vagrant box c помощью Packer
	
	
	Запуск вм после создания вагрант-файла:

bunny@bun:~/study/vagrant_kernel_update$ vagrant up
Bringing machine 'kernel-update' up with 'virtualbox' provider...
==> kernel-update: Box 'generic/centos8s' could not be found. Attempting to find and install...
    kernel-update: Box Provider: virtualbox
    kernel-update: Box Version: 4.3.4
==> kernel-update: Loading metadata for box 'generic/centos8s'
    kernel-update: URL: https://vagrantcloud.com/api/v2/vagrant/generic/centos8s
==> kernel-update: Adding box 'generic/centos8s' (v4.3.4) for provider: virtualbox (amd64)
    kernel-update: Downloading: https://vagrantcloud.com/generic/boxes/centos8s/versions/4.3.4/providers/virtualbox/amd64/vagrant.box
    kernel-update: Calculating and comparing box checksum...
==> kernel-update: Successfully added box 'generic/centos8s' (v4.3.4) for 'virtualbox (amd64)'!
==> kernel-update: Importing base box 'generic/centos8s'...
...
	Обновление ядра: 

bunny@bun:~/study/vagrant_kernel_update$ vagrant ssh
[vagrant@kernel-update ~]$ uname -r
4.18.0-516.el8.x86_64

[vagrant@kernel-update ~]$ sudo yum install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm 
Failed to set locale, defaulting to C.UTF-8
...

Installed:
  kernel-ml-6.6.10-1.el8.elrepo.x86_64               kernel-ml-core-6.6.10-1.el8.elrepo.x86_64               kernel-ml-modules-6.6.10-1.el8.elrepo.x86_64              

Complete!
[vagrant@kernel-update ~]$ sudo grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
done

	Выбрать загрузку нового ядра по-умолчанию:
[vagrant@kernel-update ~]$ sudo grub2-set-default 0
[vagrant@kernel-update ~]$ sudo reboot
Connection to 127.0.0.1 closed by remote host.
Connection to 127.0.0.1 closed.

bunny@bun:~/study/vagrant_kernel_update$ vagrant ssh
Last login: Tue Jan  9 16:13:02 2024 from 10.0.2.2
[vagrant@kernel-update ~]$ uname -r
6.6.10-1.el8.elrepo.x86_64

---///---

	Создание образа системы
	
Для создания образа системы, нам потребуется программа Packer
Давайте кратко разберем, как Packer будет создавать образ нашей виртуальной машины:
Сначала скачивается ISO-образ и сверяется его контрольная сумма, если контрольная сумма не совпадает, процесс создания образа завершается с ошибкой
Далее идёт процесс установки ОС, его также можно представить в виде файла и Packer сам развернёт нам виртуальную машину, опираясь на инструкцию из этого файла
После развертывания ВМ мы запустим скрипты настройки
После выполнения всех вышеуказанных действий packer снимает образ

bunny@bun:~/study/vagrant_kernel_update/packer$ packer build centos.json
virtualbox-iso.centos-8stream: output will be in this color.

==> virtualbox-iso.centos-8stream: Retrieving Guest additions
==> virtualbox-iso.centos-8stream: Trying /usr/share/virtualbox/VBoxGuestAdditions.iso
==> virtualbox-iso.centos-8stream: Trying /usr/share/virtualbox/VBoxGuestAdditions.iso
==> virtualbox-iso.centos-8stream: /usr/share/virtualbox/VBoxGuestAdditions.iso => /usr/share/virtualbox/VBoxGuestAdditions.iso
==> virtualbox-iso.centos-8stream: Retrieving ISO
==> virtualbox-iso.centos-8stream: Trying ./CentOS-Stream-8-x86_64-latest-boot.iso
==> virtualbox-iso.centos-8stream: Trying ./CentOS-Stream-8-x86_64-latest-boot.iso?checksum=sha256%3A389ddb679e4998bbb3c18efc211b2b5caf37695e709182a60f5b208ee156ed7f
==> virtualbox-iso.centos-8stream: ./CentOS-Stream-8-x86_64-latest-boot.iso?checksum=sha256%3A389ddb679e4998bbb3c18efc211b2b5caf37695e709182a60f5b208ee156ed7f => /home/bunny/study/vagrant_kernel_update/packer/CentOS-Stream-8-x86_64-latest-boot.iso
==> virtualbox-iso.centos-8stream: Starting HTTP server on port 8188
==> virtualbox-iso.centos-8stream: Creating virtual machine...

...

Build 'virtualbox-iso.centos-8stream' finished after 31 minutes 11 seconds.

==> Wait completed after 31 minutes 11 seconds

==> Builds finished. The artifacts of successful builds are:
--> virtualbox-iso.centos-8stream: 'virtualbox' provider box: centos-8-kernel-6-x86_64-Minimal.box

	После создания образа, его рекомендуется проверить. Для проверки  импортируем полученный vagrant box в Vagrant: 
	
bunny@bun:~/study/vagrant_kernel_update/packer$ vagrant box add --name centos8-kernel6 centos-8-kernel-6-x86_64-Minimal.box
==> box: Box file was not detected as metadata. Adding it directly...
==> box: Adding box 'centos8-kernel6' (v0) for provider: 
    box: Unpacking necessary files from: file:///home/bunny/study/vagrant_kernel_update/packer/centos-8-kernel-6-x86_64-Minimal.box

	Проверим, что образ теперь есть в списке имеющихся образов vagrant:
	
bunny@bun:~/study/vagrant_kernel_update/packer$ vagrant box list
centos8-kernel6 (virtualbox, 0)

	Запускаем:
	
bunny@bun:~/study/vagrant_kernel_update/packer$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'centos8-kernel6'...
==> default: Matching MAC address for NAT networking...
==> default: Setting the name of the VM: packer_default_1705151396737_43246
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default: 
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default: 
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!

bunny@bun:~/study/vagrant_kernel_update/packer$ vagrant ssh
Activate the web console with: systemctl enable --now cockpit.socket

Last login: Wed Jan 10 13:14:43 2024 from 10.0.2.2
[vagrant@otus-c8 ~]$ uname -r
6.6.10-1.el8.elrepo.x86_64

