#!/bin/bash

DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

#init bdd
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Init MariaDb database..."
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
	mysql --user=mysql --bootstrap << EOSQL
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '{MYSQL_USER}'@'%';
FLUS PRIVILEGES;
EOSQL

	echo "Mariadb init succesfully"
fi

#execmariab

exec mysqld --user=mysql --bind-adress=0.0.0.0
