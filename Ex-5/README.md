## Дисковая подсистема_Работа с mdam
#### Создание mdadm.conf
```
[root@otuslinux ~]# cat /etc/mdadm/mdadm.conf
DEVICE partitions
ARRAY /dev/md0 level=raid6 num-devices=5 metadata=1.2 name=otuslinux:0 UUID=924d3a8e:74a7eabc:f3728efa:9e2d2518
```

#### Сломать/починить RAID
Ломаем
```
[root@otuslinux ~]# mdadm /dev/md0 --fail /dev/sde
mdadm: set /dev/sde faulty in /dev/md0

[root@otuslinux ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid6 sdf[4] sde[3](F) sdd[2] sdc[1] sdb[0]
      761856 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/4] [UUU_U]
```
Делаем замену
```
[root@otuslinux ~]# mdadm /dev/md0 --remove /dev/sde
mdadm: hot removed /dev/sde from /dev/md0
[root@otuslinux ~]# mdadm /dev/md0 --add /dev/sde
mdadm: added /dev/sde

[root@otuslinux ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid6 sde[5] sdf[4] sdd[2] sdc[1] sdb[0]
      761856 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5] [UUUUU]
      
unused devices: <none>
```
###Создать GPT раздел, пять партиций и смонтировать их на диск
```
[root@otuslinux ~]# lsblk
NAME      MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda         8:0    0    40G  0 disk  
`-sda1      8:1    0    40G  0 part  /
sdb         8:16   0   250M  0 disk  
`-md0       9:0    0   744M  0 raid6 
  |-md0p1 259:0    0   147M  0 md    /raid/part1
  |-md0p2 259:1    0 148.5M  0 md    /raid/part2
  |-md0p3 259:2    0   150M  0 md    /raid/part3
  |-md0p4 259:3    0 148.5M  0 md    /raid/part4
  `-md0p5 259:4    0   147M  0 md    /raid/part5
sdc         8:32   0   250M  0 disk  
`-md0       9:0    0   744M  0 raid6 
  |-md0p1 259:0    0   147M  0 md    /raid/part1
  |-md0p2 259:1    0 148.5M  0 md    /raid/part2
  |-md0p3 259:2    0   150M  0 md    /raid/part3
  |-md0p4 259:3    0 148.5M  0 md    /raid/part4
  `-md0p5 259:4    0   147M  0 md    /raid/part5
sdd         8:48   0   250M  0 disk  
`-md0       9:0    0   744M  0 raid6 
  |-md0p1 259:0    0   147M  0 md    /raid/part1
  |-md0p2 259:1    0 148.5M  0 md    /raid/part2
  |-md0p3 259:2    0   150M  0 md    /raid/part3
  |-md0p4 259:3    0 148.5M  0 md    /raid/part4
  `-md0p5 259:4    0   147M  0 md    /raid/part5
sde         8:64   0   250M  0 disk  
`-md0       9:0    0   744M  0 raid6 
  |-md0p1 259:0    0   147M  0 md    /raid/part1
  |-md0p2 259:1    0 148.5M  0 md    /raid/part2
  |-md0p3 259:2    0   150M  0 md    /raid/part3
  |-md0p4 259:3    0 148.5M  0 md    /raid/part4
  `-md0p5 259:4    0   147M  0 md    /raid/part5
sdf         8:80   0   250M  0 disk  
`-md0       9:0    0   744M  0 raid6 
  |-md0p1 259:0    0   147M  0 md    /raid/part1
  |-md0p2 259:1    0 148.5M  0 md    /raid/part2
  |-md0p3 259:2    0   150M  0 md    /raid/part3
  |-md0p4 259:3    0 148.5M  0 md    /raid/part4
  `-md0p5 259:4    0   147M  0 md    /raid/part5
```

