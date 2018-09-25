#!/usr/bin/env bash
su - postgres -c "/usr/bin/pg_ctl restart -D /var/lib/pgsql/data/  -w -t 100"
su - postgres -c 'PGPASSWORD=spacepw;'
su - postgres -c 'createdb spaceschema ;'
su - postgres -c 'yes $PGPASSWORD | createuser -P -sDR spaceuser'
su - postgres -c 'PGPASSWORD=spacepw psql -a -U spaceuser spaceschema'
echo "hola bb"
