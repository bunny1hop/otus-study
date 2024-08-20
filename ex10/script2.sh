mkdir /usr/share/nginx/html/repo

cp ~/rpmbuild/RPMS/x86_64/*.rpm /usr/share/nginx/html/repo/

createrepo /usr/share/nginx/html/repo/

mv /home/vagrant/nginx.conf /etc/nginx/nginx.conf

nginx -s reload

cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF

yum repolist enabled

cd /usr/share/nginx/html/repo/

wget https://repo.percona.com/yum/percona-release-latest.noarch.rpm

createrepo /usr/share/nginx/html/repo/

yum makecache

yum install -y percona-release.noarch
