#!/bin/bash

###############################################################################
# Script para instalação de o Postgresql 9.5, Postgis e PGPointCloud no       #
# Ubuntu 14.04.4.                                                             #
# Testado no Ubuntu 16.04                                                     #
#                                                                             #
# Author: Vitor Gomes <vconrado@gmail.com>                                    #
# Last Update: 2016-08-08                                                     #
###############################################################################

# PASSWORD para o usuário postgres
export PGUSERPASSWORD=masterkey
export TMP_PATH=/tmp/pgpointcloud_install

# 0. Preparando Ambiente
# 0.1 Verificando se é root
if [ "$(id -u)" != "0" ]; then
   echo "Você precisa de superpoderes ! " 1>&2
   echo "Use: sudo $0  " 1>&2
   exit 1
fi

# 0.2 Criando pasta temporáRemovida
mkdir -p $TMP_PATH

# 0.3 Ferramentas para compilação/instalação
sudo apt-get install -y git cmake build-essential

# 1. Instalando o Postgresql 9.5
# 1.1 Adicionando Repositório para a versão 9.5
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update

# 1.2 Postgresql 9.5 core
sudo apt-get install -y postgresql-9.5

# 1.3 Alterando password
sudo -u postgres -H -- psql -c "ALTER USER postgres WITH PASSWORD '$PGUSERPASSWORD'"

# 1.4 Postgis 2.2
sudo apt-get install -y postgresql-9.5-postgis-2.2 postgresql-9.5-postgis-2.2-scripts

# 2. PGPointCloud

# 2.1 Dependências
# 2.1.1 Postgresql dev
sudo apt-get install -y postgresql-server-dev-9.5

# 2.1.2 LibXML2
sudo apt-get install -y libxml2-dev

# 2.1.2 CUnit
sudo apt-get install -y libcunit1 libcunit1-dev

# 2.1.3 GHT
cd $TMP_PATH
git clone https://github.com/pramsey/libght.git
cd libght
mkdir libght-build
cd libght-build
cmake ../
make
sudo make install

# 2.1.3.1 Configurando LDCONFIG GHT
sudo echo "/usr/local/lib/" > /etc/ld.so.conf.d/libght.conf
sudo ldconfig

# 2.1.3 LAZ-perf
cd $TMP_PATH
git clone https://github.com/hobu/laz-perf.git
cd  laz-perf
mkdir laz-perf-build
cd laz-perf-build
cmake ../
make
sudo make install

# 2.1.4 PDAL
# 2.1.4.1 Dependências do PDAL
# 2.1.4.2 GDAL
sudo apt-get install -y gdal-bin libgdal-dev
if [ $(lsb_release -cs) = 'xenial' ]; then
   sudo apt-get install -y libgdal1i
else
   sudo apt-get install -y libgdal1h
fi
# 2.1.4.2 GDAL
sudo apt-get install -y geotiff-bin libgeotiff-dev libgeotiff2
# 2.1.4.2 LASZip
cd $TMP_PATH
git clone https://github.com/LASzip/LASzip.git
cd LASzip
mkdir LASzip-build
cd LASzip-build
cmake ../
make
sudo make install

# 2.1.4 PDAL core
cd $TMP_PATH
wget http://download.osgeo.org/pdal/PDAL-1.2.0-src.tar.gz
tar xvzf PDAL-1.2.0-src.tar.gz
cd PDAL-1.2.0-src
mkdir pdal-build
cd pdal-build
cmake ../
make
sudo make install

# 2.2 PointCloud core
cd $TMP_PATH
git clone https://github.com/pgpointcloud/pointcloud.git
cd pointcloud
mkdir pointcloud-build
cd pointcloud-build
cmake ../
make
sudo make install

###############################################################################

echo
echo "A pasta $TMP_PATH pode ser removida"
echo
echo "Para criar o banco"
echo "psql"
echo "CREATE DATABASE my_database;"
echo "\connect my_database"
echo "CREATE EXTENSION postgis;"
echo "CREATE EXTENSION pointcloud;"
echo "CREATE EXTENSION pointcloud_postgis;"
