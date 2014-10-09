#!/bin/bash
# CREATE DB

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

echo "=> Creating MySQL database 'quincydb'"

if [ $(mysql -uroot -e "SHOW DATABASES"| grep -c quincydb) = 0 ]; then
  mysql -uroot -e "CREATE DATABASE quincydb;"
  mysql -uroot quincydb < /app/database_schema.sql
fi

echo "=> Done!"

mysqladmin -uroot shutdown
