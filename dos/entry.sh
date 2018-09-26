#!/usr/bin/env bash
echo -e "\n\n\n 1"
chown -R postgres /var/lib/pgsql/data/*

echo -e "\n\n\n 11"


su postgres - -c "/usr/bin/pg_ctl start -D /var/lib/pgsql/data/  -w -t 300"

echo -e "\n\n\n 3"


 sed -i "s%#listen_addr.*%listen_addresses = '*'%g" /var/lib/pgsql/data/postgresql.conf
        sed -i "s%#max_conne.*%max_connections = 600%g" /var/lib/pgsql/data/postgresql.conf
        echo "host all  all    0.0.0.0/0  md5" >> /var/lib/pgsql/data/pg_hba.conf

echo -e "\n\n\n 22"


su - postgres -c "/usr/bin/pg_ctl restart -D /var/lib/pgsql/data/  -w -t 300"
echo 4
su - postgres -c 'PGPASSWORD=spacepw;'
su - postgres -c 'createdb spaceschema ;'
su - postgres -c 'yes $PGPASSWORD | createuser -P -sDR spaceuser'
su - postgres -c 'PGPASSWORD=spacepw psql -a -U spaceuser spaceschema'
echo "hola bb"
