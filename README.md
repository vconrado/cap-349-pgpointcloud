Passos

1) Repositório https://github.com/pgpointcloud/pointcloud.git clonado
  git clone https://github.com/pgpointcloud/pointcloud.git
  git show-ref --head
  3929653f51296f5dd5fe5997c8c4c5d46419cb50 HEAD
  3929653f51296f5dd5fe5997c8c4c5d46419cb50 refs/heads/master
  1594c0da1ca145bc569548fed83af11695c7d7cb refs/remotes/origin/1.0.x
  3929653f51296f5dd5fe5997c8c4c5d46419cb50 refs/remotes/origin/HEAD
  3b0cf7cd1ae48681afbef6fb6516a5f1549aa545 refs/remotes/origin/Remi-C-patch-doc-#67
  b1c4aad8df8b5f0311e70b275804600d0ddec623 refs/remotes/origin/cmake
  1d586ee15144e5792e4e5cf32c4458f866135607 refs/remotes/origin/filtershortcut
  addb7e73ff87e2c6c62b73d0854980b0c2565007 refs/remotes/origin/gh-pages
  3929653f51296f5dd5fe5997c8c4c5d46419cb50 refs/remotes/origin/master
  d20f55eaca583a4286e6853bfdc15a47671cb14f refs/tags/v0.1.0
  e032826390f33a6bcba908b17cf1f4cce59ee9bf refs/tags/v1.0.1

1.1) Removida a pasta .git (para poder commitar esse código dentro do meu repositório )

INSTALAÇÃO NO SERVIDOR:

Especificação do servidor:
  VERSION="14.04.4 LTS, Trusty Tahr"
  ID=ubuntu
  ID_LIKE=debian
  PRETTY_NAME="Ubuntu 14.04.4 LTS"
  VERSION_ID="14.04"
  16G Memória
  Intel(R) Core(TM) i7-5820K CPU @ 3.30GHz 6 Processadores 2 threads


1) Postgresql 9.5

1.0) Preparação para o Ubuntu 14.04.4
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update

1.1) Postgresql 9.5 core
  sudo apt-get install postgresql-9.5

1.1.1) Alter user password
  sudo su - postgres
  psql
    ALTER USER "postgres" WITH PASSWORD "my_new_password";

1.2) Postgis 2.2
  sudo apt-get install postgresql-9.5-postgis-2.2 postgresql-9.5-postgis-2.2-scripts

2) Dependências do pgpointcloud
2.1) Postgresql dev
  sudo apt-get install postgresql-server-dev-9.5

2.2) LibXML2
  sudo apt-get install libxml2-dev

2.3) CUnit
  sudo apt-get install libcunit1 libcunit1-dev

2.3) GHT (ajustado o processo, no github está errado)
  git clone https://github.com/pramsey/libght.git
  cd libght
  mkdir libght-build
  cd libght-build
  cmake ../
  make
  make test
  sudo make install
  -- Installing: /usr/local/lib/libght.so.0.1.1
  -- Installing: /usr/local/lib/libght.so.0.1
  -- Installing: /usr/local/lib/libght.so
  -- Set runtime path of "/usr/local/lib/libght.so.0.1.1" to "/usr/local/lib"
  -- Installing: /usr/local/lib/libght.a
  -- Installing: /usr/local/include/ght.h
  -- Installing: /usr/local/include/ght_core.h

  2.3.1) Configurando carga (para evitar ERROR:  could not load library "/usr/lib/postgresql/9.5/lib/pointcloud-1.1.so": libght.so.0.1: cannot open shared object file: No such file or directory)
  sudo vim /etc/ld.so.conf.d/libght.conf
    /usr/local/lib/
  sudo ldconfig

  2.4) LAZ-perf
    git clone https://github.com/hobu/laz-perf.git
    cd  LAZ-perf
    mkdir laz-perf-build
    cd laz-perf-build
    cmake ../
    make
    make test
    sudo make install

    -- Installing: /usr/local/lib/cmake/lazperf/lazperf-config.cmake
    -- Installing: /usr/local/lib/cmake/lazperf/lazperf-configVersion.cmake
    -- Installing: /usr/local/include/laz-perf
    -- Installing: /usr/local/include/laz-perf/model.hpp
    -- Installing: /usr/local/include/laz-perf/detail
    -- Installing: /usr/local/include/laz-perf/detail/field_point10.hpp
    -- Installing: /usr/local/include/laz-perf/detail/field_gpstime.hpp
    -- Installing: /usr/local/include/laz-perf/detail/field_xyz.hpp
    -- Installing: /usr/local/include/laz-perf/detail/field_rgb.hpp
    -- Installing: /usr/local/include/laz-perf/formats.hpp
    -- Installing: /usr/local/include/laz-perf/streams.hpp
    -- Installing: /usr/local/include/laz-perf/io.hpp
    -- Installing: /usr/local/include/laz-perf/decoder.hpp
    -- Installing: /usr/local/include/laz-perf/main.cpp
    -- Installing: /usr/local/include/laz-perf/compressor.hpp
    -- Installing: /usr/local/include/laz-perf/excepts.hpp
    -- Installing: /usr/local/include/laz-perf/portable_endian.hpp
    -- Installing: /usr/local/include/laz-perf/encoder.hpp
    -- Installing: /usr/local/include/laz-perf/las.hpp
    -- Installing: /usr/local/include/laz-perf/util.hpp
    -- Installing: /usr/local/include/laz-perf/factory.hpp
    -- Installing: /usr/local/include/laz-perf/common
    -- Installing: /usr/local/include/laz-perf/common/common.hpp
    -- Installing: /usr/local/include/laz-perf/common/types.hpp
    -- Installing: /usr/local/include/laz-perf/decompressor.hpp


3) pgpointcloud
  git clone https://github.com/pgpointcloud/pointcloud.git
  cd pointcloud
  mkdir pointcloud-build
  cd pointcloud-build
  cmake ../
  make (real    0m6.732s
      user    0m5.880s
      sys     0m0.392s)
  sudo make install

  -- Install configuration: "RelWithDebInfo"
  -- Installing: /usr/lib/postgresql/9.5/lib/pointcloud-1.1.so
  -- Installing: /usr/share/postgresql/9.5/extension/pointcloud--1.1.0.sql
  -- Installing: /usr/share/postgresql/9.5/extension/pointcloud.control
  -- Installing: /usr/share/postgresql/9.5/extension/pointcloud_postgis--1.0.sql
  -- Installing: /usr/share/postgresql/9.5/extension/pointcloud_postgis.control

3.5) PDAL
3.5.1) Dependências
  3.5.1.1) GDAL
    sudo apt-get install gdal-bin libgdal1h libgdal-dev
  3.5.1.2) GeoTiff
    sudo apt-get install geotiff-bin libgeotiff-dev libgeotiff2
  3.5.1.3) LASZip (http://gis.stackexchange.com/a/206862)
    git clone https://github.com/LASzip/LASzip.git
    cd LASzip
    mkdir build
    cd build
    cmake ../
    make
    sudo make install

    -- Install configuration: "Release"
    -- Installing: /usr/local/lib/liblaszip.so.4.0.3
    -- Installing: /usr/local/lib/liblaszip.so
    -- Installing: /usr/local/include/laszip
    -- Installing: /usr/local/include/laszip/lasunzipper.hpp
    -- Installing: /usr/local/include/laszip/laszip.hpp
    -- Installing: /usr/local/include/laszip/laszipper.hpp
    -- Installing: /usr/local/include/laszip/laszipexport.hpp
    -- Installing: /usr/local/bin/laszip-config
    -- Installing: /usr/local/bin/laszippertest
    -- Removed runtime path from "/usr/local/bin/laszippertest"







wget http://download.osgeo.org/pdal/PDAL-1.2.0-src.tar.gz
tar xvzf PDAL-1.2.0-src.tar.gz
mkdir pdal-build
cd pdal-build
cmake ../
make
make install

  4) Usando:

  4.1) Criando o banco
    sudo su - postgres
    psql
      CREATE DATABASE pc_test1;
      \connect pc_test1

      \l+
      pc_test1  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 6984 kB | pg_default |

      CREATE EXTENSION pointcloud;


      \l+

      pc_test1  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 7064 kB | pg_default |



    4.2) Inserindo o schema
    INSERT INTO pointcloud_formats (pcid, srid, schema) VALUES (1, 4326,
        '<?xml version="1.0" encoding="UTF-8"?>
        <pc:PointCloudSchema xmlns:pc="http://pointcloud.org/schemas/PC/1.1"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
          <pc:dimension>
            <pc:position>1</pc:position>
            <pc:size>4</pc:size>
            <pc:description>X coordinate as a long integer. You must use the
                            scale and offset information of the header to
                            determine the double value.</pc:description>
            <pc:name>X</pc:name>
            <pc:interpretation>int32_t</pc:interpretation>
            <pc:scale>0.01</pc:scale>
          </pc:dimension>
          <pc:dimension>
            <pc:position>2</pc:position>
            <pc:size>4</pc:size>
            <pc:description>Y coordinate as a long integer. You must use the
                            scale and offset information of the header to
                            determine the double value.</pc:description>
            <pc:name>Y</pc:name>
            <pc:interpretation>int32_t</pc:interpretation>
            <pc:scale>0.01</pc:scale>
          </pc:dimension>
          <pc:dimension>
            <pc:position>3</pc:position>
            <pc:size>4</pc:size>
            <pc:description>Z coordinate as a long integer. You must use the
                            scale and offset information of the header to
                            determine the double value.</pc:description>
            <pc:name>Z</pc:name>
            <pc:interpretation>int32_t</pc:interpretation>
            <pc:scale>0.01</pc:scale>
          </pc:dimension>
          <pc:dimension>
            <pc:position>4</pc:position>
            <pc:size>2</pc:size>
            <pc:description>The intensity value is the integer representation
                            of the pulse return magnitude. This value is optional
                            and system specific. However, it should always be
                            included if available.</pc:description>
            <pc:name>Intensity</pc:name>
            <pc:interpretation>uint16_t</pc:interpretation>
            <pc:scale>1</pc:scale>
          </pc:dimension>
          <pc:metadata>
            <Metadata name="compression">dimensional</Metadata>
          </pc:metadata>
        </pc:PointCloudSchema>');


        CREATE TABLE points (
            id SERIAL PRIMARY KEY,
            pt PCPOINT(1)
        );

        CREATE TABLE patches (
    id SERIAL PRIMARY KEY,
    pa PCPATCH(1)
);


pc_test1=# select * from pointcloud_columns ;
 schema |  table  | column | pcid | srid |  type
--------+---------+--------+------+------+---------
 public | points  | pt     |    1 | 4326 | pcpoint
 public | patches | pa     |    1 | 4326 | pcpatch
(2 rows)
\l+
pc_test1  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 7168 kB | pg_default |


INSERT INTO patches (pa)
SELECT PC_Patch(pt) FROM points GROUP BY id/10;

pc_test1  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 7208 kB | pg_default |

create extention postgis;

pc_test1  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 13 MB   | pg_default |

SELECT ST_AsText(PC_Envelope(pa)::geometry) FROM patches;

 select ST_AsText(Geometry(pt)) from points limit 1;

 CREATE TABLE envelopes (
     id SERIAL PRIMARY KEY,
     geom geometry(POLYGON, 4326)
 );




 CREATE TABLE HUML6510C8920 (
   id SERIAL PRIMARY KEY,
  pa PCPATCH(1)
);
