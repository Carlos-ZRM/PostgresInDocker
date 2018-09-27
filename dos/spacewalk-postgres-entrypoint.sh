#!/usr/bin/env bash
#DB_NAME DB_USER DB_PASS PG_CONFDIR

set -u 
trap "docker_stop" SIGINT SIGTERM
DB_NAME=${DB_NAME:-}
DB_USER=${DB_USER:-}
DB_PASS=${DB_PASS:-}

echo \"${DB_USER}\"
echo \"${DB_NAME}\"

PG_CONFDIR="/var/lib/pgsql/data"

__start_sql()
{
	if  [ -n $DB_USER ]; then
		echo ifi
		chown -R postgres /var/lib/pgsql/data/*
		#su postgres - -c "/usr/bin/pg_ctl initdb  -D /var/lib/pgsql/data/"
		su postgres - -c "/usr/bin/pg_ctl start -D /var/lib/pgsql/data/  -w -t 300"
		
 		sed -i "s%#listen_addr.*%listen_addresses = '*'%g" /var/lib/pgsql/data/postgresql.conf
        	sed -i "s%#max_conne.*%max_connections = 600%g" /var/lib/pgsql/data/postgresql.conf
		echo "host all  all    0.0.0.0/0  md5" >> /var/lib/pgsql/data/pg_hba.con
		echo "local "${DB_USER}" spaceuser md5" >> /var/lib/pgsql/data/pg_hba.con
		echo "host  "${DB_USER}" spaceuser 127.0.0.1/8 md5">> /var/lib/pgsql/data/pg_hba.con
		echo "host  "${DB_USER}" spaceuser ::1/128 md5">> /var/lib/pgsql/data/pg_hba.con
		echo "local "${DB_USER}" postgres  ident">> /var/lib/pgsql/data/pg_hba.con
		su - postgres -c "/usr/bin/pg_ctl restart -D /var/lib/pgsql/data/  -w -t 300"
	fi	
		
}
__create_db() 
{
	# al usuario postgres lo agrega al grupo wheel	
       	usermod -G wheel postgres

	# si DB_user NONEMPTYSTRING
	if [ -n "${DB_USER}" ]; then
		# si DB_pass es EMPTYSTRING
  		if [ -z "${DB_PASS}" ]; then
    			echo ""
    			echo "WARNING: "
    			echo "No se especifico el password para \"${DB_USER}\". Se generara una"
    			echo ""
    			DB_PASS=$(pwgen -c -n -1 12)
    			echo "Password para \"${DB_USER}\" es: \"${DB_PASS}\""
  		fi
   		echo "Creating user \"${DB_USER}\"..."
    #	    echo "CREATE ROLE ${DB_USER} with CREATEROLE login superuser PASSWORD '${DB_PASS}';" |
      		#sudo -u postgres -H postgres --single \
       		#-c config_file=${PG_CONFDIR}/postgresql.conf -D ${PG_CONFDIR}
    		su postgres - -c "PGPASSWORD=$DB_PASS;"
		su postgres - -c "yes $PGPASSWORD | createuser -P -sDR \"${DB_USER}\";"
		echo "Usuario creado "

	fi
	# si DB_NAME NONEMPTYSTRING
	if [ -n "${DB_NAME}" ]; then
  		echo "Creando la base de datos\"${DB_NAME}\"..."
    		#sudo -u postgres -H postgres --single \
     		#-c config_file=${PG_CONFDIR}/postgresql.conf -D ${PG_CONFDIR}
		su postgres - -c "createdb \"${DB_NAME}\" ;"

  		if [ -n "${DB_USER}" ]; then
    			echo "Granting access to database \"${DB_NAME}\" for user \"${DB_USER}\"..."
    			echo "GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} to ${DB_USER};"
			
      			#sudo -u postgres -H postgres --single \
      			#-c config_file=${PG_CONFDIR}/postgresql.conf -D ${PG_CONFDIR}
  		fi
	fi
}

#while [1]; do
#done 

#su postgres - -c "/usr/bin/pg_ctl initdb  -D /var/lib/pgsql/data/"
#su postgres - -c "/usr/bin/pg_ctl start -D /var/lib/pgsql/data/  -w -t 300"

#sed -i "s%#listen_addr.*%listen_addresses = '*'%g" /var/lib/pgsql/data/postgresql.conf &&\
#sed -i "s%#max_conne.*%max_connections = 600%g" /var/lib/pgsql/data/postgresql.conf &&\
#echo "host all  all    0.0.0.0/0  md5" >> /var/lib/pgsql/data/pg_hba.conf

#su postgres - -c "/usr/bin/pg_ctl restart -D /var/lib/pgsql/data/  -w -t 300"
#su postgres - -c 'createdb "${DB_USER}" ;'
#su postgres - -c 'yes $PGPASSWORD | createuser -P -sDR spaceuser'
#su postgres - -c 'PGPASSWORD=spacepw psql -a -U spaceuser "${DB_USER}"'
__start_sql
__create_db
echo "hola bb"
