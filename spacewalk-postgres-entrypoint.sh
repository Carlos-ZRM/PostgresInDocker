#!/usr/bin/env bash

su - postgres -c 'PGPASSWORD=spacepw; createdb -E UTF8 spaceschema ; createlang plpgsql spaceschema ; createlang pltclu spaceschema ; yes $PGPASSWORD | createuser -P -sDR spaceuser'
	sed -i "s%#listen_addr.*%listen_addresses = '*'%g" /var/lib/pgsql/data/postgresql.conf
sed -i "s%#max_conne.*%max_connections = 600%g" /var/lib/pgsql/data/postgresql.conf
	su - postgres -c "/usr/bin/pg_ctl restart"

