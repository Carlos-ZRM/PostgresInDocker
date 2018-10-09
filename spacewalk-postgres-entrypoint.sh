#!/usr/bin/env bash
#DB_NAME DB_USER DB_PASS PG_CONFDIR

set -u
trap "docker_stop" SIGINT SIGTERM
export STOP_PROC=0


function docker_stop {
    export STOP_PROC=1;
}


log() {
  if [[ "$@" ]]; then echo "[ AMX `date +'%Y-%m-%d %T'`] $@";
  else echo; fi
}

__start_sql()
{
        if  [ -n $DB_USER ]; then
                usermod -G wheel postgres
                chown -R postgres /var/lib/pgsql/data/*
                su postgres - -c "/usr/bin/pg_ctl start -D /var/lib/pgsql/data/ -w"
                log "La base de datos se inicio"
        fi

}
__create_db()
{
        # al usuario postgres lo agrega al grupo wheel

        # si DB_user NONEMPTYSTRING
        if [ -n "${DB_USER}" ]; then
                # si DB_pass es EMPTYSTRING
                if [ -z "${DB_PASS}" ]; then
                        log "WARNING: No se especifico el password para \"${DB_USER}\". Se generara una"
                        DB_PASS=$(pwgen -c -n -1 12)
                        log "Password para \"${DB_USER}\" es: \"${DB_PASS}\""
                fi

        fi
        # si DB_NAME NONEMPTYSTRING
        if [ -n "${DB_NAME}" ]; then
                #su postgres - -c "PGPASSWORD="$DB_PASS";"
                #su postgres - -c "yes PGPASSWORD | createuser -sDER  -P "$DB_USER";"
                #log  "Usuario "$DB_USER" creado"
                #su postgres - -c "createdb "${DB_NAME}" ;"
                su - postgres -c 'PGPASSWORD=spacepw; createdb -E UTF8 spaceschema ; createlang plpgsql spaceschema ;createlang pltclu spaceschema ; yes $PGPASSWORD | createuser -P -sDR spaceuser'
                log "Base de datos "$DB_NAME" creada"
                #su postgres - -c " createlang plpgsql spaceschema ; createlang pltclu spaceschema;"
                sed -i "s%#listen_addr.*%listen_addresses = '*'%g" /var/lib/pgsql/data/postgresql.conf
                sed -i "s%#max_conne.*%max_connections = 600%g" /var/lib/pgsql/data/postgresql.conf
                echo "host all  all    0.0.0.0/0  md5" >> /var/lib/pgsql/data/pg_hba.conf
                echo "local "${DB_NAME}" ${DB_USER} md5" >> /var/lib/pgsql/data/pg_hba.conf
                echo "host  "${DB_NAME}" ${DB_USER} 127.0.0.1/8 md5">> /var/lib/pgsql/data/pg_hba.conf
                echo "host  "${DB_NAME}" ${DB_USER} ::1/128 md5">> /var/lib/pgsql/data/pg_hba.conf
                echo "local "${DB_NAME}" postgres  ident">> /var/lib/pgsql/data/pg_hba.conf
                log "Configuracion creada"
                touch /.cookiePosgres
                su - postgres -c "/usr/bin/pg_ctl restart -D /var/lib/pgsql/data/  -w -t 300"
                log "Se reinicio Postgres SQL ... Contenedor listo!"

        fi
}



DB_NAME=${DB_NAME:-}
DB_USER=${DB_USER:-}
DB_PASS=${DB_PASS:-}
https_proxy=${https_proxy:-}
http_proxy=${http_proxy:-}
PG_CONFDIR="/var/lib/pgsql/data"
#
if [ 0 -eq $(pgrep -x postgres &>/dev/null && echo 1 || echo 0) ];then
        __start_sql
        if [ 0 -eq $(ls -A  /.cookiePosgres &>/dev/null && echo 1 || echo 0) ];then
                __create_db
        fi
fi

echo " ... "
while true; do
        if [ $STOP_PROC != 0 ]; then
                if [ 0 -eq $(pgrep -x postgres &>/dev/null && echo 1 || echo 0) ]; then
                        su - postgres -c "/usr/bin/pg_ctl restart -D /var/lib/pgsql/data/  -w -t 300"
                        log "La base de datos se reinicio"
                        sleep 5
                else
                        log "Trap encontrado sericio Postgres arriba"
                fi

        fi
sleep 5
done
