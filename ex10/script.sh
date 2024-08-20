#!/bin/bash

# Проверка на выполнение от имени администратора
if [[ $EUID -ne 0 ]]; then
   echo "Этот скрипт должен быть выполнен от имени администратора." 
   exit 1
fi

# Установка необходимых пакетов
yum install -y wget rpmdevtools rpm-build createrepo \
 yum-utils cmake gcc git nano

# Создание директории для RPM
mkdir -p ~/rpm && cd ~/rpm

# Загрузка исходных RPM для nginx
yumdownloader --source nginx

# Установка зависимостей для сборки nginx
rpm -Uvh nginx*.src.rpm
yum-builddep -y nginx

# Клонирование репозитория ngx_brotli
cd /root
git clone --recurse-submodules -j8 https://github.com/google/ngx_brotli

# Сборка Brotli
cd ngx_brotli/deps/brotli
mkdir out && cd out

cmake -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_SHARED_LIBS=OFF \
      -DCMAKE_C_FLAGS="-Ofast -m64 -march=native -mtune=native -flto -funroll-loops -ffunction-sections -fdata-sections -Wl,--gc-sections" \
      -DCMAKE_CXX_FLAGS="-Ofast -m64 -march=native -mtune=native -flto -funroll-loops -ffunction-sections -fdata-sections -Wl,--gc-sections" \
      -DCMAKE_INSTALL_PREFIX=./installed ..

cmake --build . --config Release -j 2 --target brotlienc

# Копирование спецификации RPM
cd ../../../..
cp /home/vagrant/xnginx.spec /root/rpmbuild/SPECS/xnginx.spec

# Сборка RPM пакетов
cd ~/rpmbuild/SPECS/
rpmbuild -ba xnginx.spec -D 'debug_package %{nil}'

# Копирование RPM в нужную директорию
cp ~/rpmbuild/RPMS/noarch/* ~/rpmbuild/RPMS/x86_64/

# Установка собранных RPM пакетов
cd ~/rpmbuild/RPMS/x86_64
yum localinstall -y *.rpm

# Запуск nginx
systemctl start nginx
