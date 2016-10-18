#!/bin/bash

scriptPos=${0%/*}

if [ $# -eq 0 ]; then 
        echo -en "\033[1;33mThe name of the sub directory for the new container is as parameter needed, cancel\033[0m\n"
        exit 1
fi
destDir=$scriptPos/../container/$1

if [ -d $destDir ]; then
        echo -en "\033[1;31mDestination directory already exists: $destDir \nCancel.\033[0m\n"
        exit 1
fi

echo -en "\033[1;34mPrepare directory: $destDir \033[0m\n"

mkdir -p  $destDir/bin
cp $scriptPos/container/example_conf.sh $destDir/bin/conf.sh
pushd $destDir/bin > /dev/null
ln -s ../../../bin/container/del_server.sh
ln -s ../../../bin/container/start_bash.sh
ln -s ../../../bin/container/start_psql.sh
ln -s ../../../bin/container/start_server.sh
ln -s ../../../bin/container/stop_server.sh
popd

mkdir -p  $destDir/data

mkdir -p  $destDir/import
cat << README > $destDir/import/README.md
The 00_prepare_db.sql script is needed to activate postgis for the osm
database.

1. edit 00_prepare_db.sql.todo and replace the name of the osm_database
2. mv 00_prepare_db.sql.todo 00_prepare_db.sql

Shell scripts or SQL files in this directory are used to initialize database

Allowed file types:
*.sh, *.sql, *.sql.gz, *.sql.bz2
README

cat << README_X > $destDir/import/00_prepare_db.sql.todo
\connect osm_berlin


SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;
README_X


mkdir -p  $destDir/tmp
cat << README2 > $destDir/tmp/README.md
This directory is mounted to /opt/tmp of the container
README2

mkdir -p  $destDir/osm
cat << README3 > $destDir/osm/README.md
this is the place where you can put the osm data to import for instance form 
http://download.geofabrik.de/

Data for Berlin are here: http://download.geofabrik.de/europe/germany/berlin-latest.osm.pbf


This directory is mounted to /osm of the container
README3

mkdir -p  $destDir/flatnodes
cat << README4 > $destDir/flatnodes/README.md
if this directory exists than it is used to save the flat-nodes of osm2pgsql import. To save lifetime of a SSD
it's maybe a good idea to replace it with a link
README4


