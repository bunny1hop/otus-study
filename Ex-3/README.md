# Автоматизация администрирования. Ansible-1

### Домашнее задание
Подготовить стенд на Vagrant как минимум с одним сервером. На этом сервере, используя Ansible, необходимо развернуть nginx со следующими условиями:
- необходимо использовать модуль yum/apt
- конфигурационные файлы должны быть взяты из шаблона jinja2 с переменными
- после установки nginx должен быть в режиме enabled в systemd
- должен быть использован notify длā старта nginx после установки
- сайт должен слушать на нестандартном порту - 8080, для этого использовать переменные в Ansible

### Прокатываем плейбук
```
bunny@bun:~/study/ex3ansible$ ansible-playbook nginx.yml

PLAY [NGINX | Install and configure NGINX] *****************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [nginx]

TASK [NGINX | Install EPEL Repo package from standart repo] ************************************************************************************************************
ok: [nginx]

TASK [NGINX | Install NGINX package from EPEL Repo] ********************************************************************************************************************
changed: [nginx]

TASK [NGINX | Create NGINX config file from template] ******************************************************************************************************************
changed: [nginx]

RUNNING HANDLER [restart nginx] ****************************************************************************************************************************************
changed: [nginx]

RUNNING HANDLER [reload nginx] *****************************************************************************************************************************************
changed: [nginx]

PLAY RECAP *************************************************************************************************************************************************************
nginx                      : ok=6    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
````
### Проверяем статус сервиса и отдачу через нжинкс
```
[vagrant@nginx ~]$ service nginx status
Redirecting to /bin/systemctl status nginx.service
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
   Active: active (running) since Mon 2024-01-22 05:11:36 UTC; 13min ago
  Process: 32541 ExecReload=/usr/sbin/nginx -s reload (code=exited, status=0/SUCCESS)
  Process: 32464 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 32461 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 32460 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 32466 (nginx)
   CGroup: /system.slice/nginx.service
           ├─32466 nginx: master process /usr/sbin/nginx
           └─32542 nginx: worker process


[vagrant@nginx ~]$ curl http://192.168.56.56:8080 -I
HTTP/1.1 200 OK
Server: nginx/1.20.1
Date: Mon, 22 Jan 2024 05:24:58 GMT
Content-Type: text/html
Content-Length: 4833
Last-Modified: Fri, 16 May 2014 15:12:48 GMT
Connection: keep-alive
ETag: "53762af0-12e1"
Accept-Ranges: bytes
```



