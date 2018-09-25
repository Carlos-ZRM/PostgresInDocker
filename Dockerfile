FROM centos:7
#Install and update 
RUN yum -y update ; yum install -y  postgresql-server postgresql-contrib postgresql-plpython postgresql-pltcl -y &&\ 
	rm -rf /var/lib/pgsql/data/*

USER postgres

RUN /usr/bin/pg_ctl initdb  -D /var/lib/pgsql/data/      

RUN sed -i "s%#listen_addr.*%listen_addresses = '*'%g" /var/lib/pgsql/data/postgresql.conf
RUN sed -i "s%#max_conne.*%max_connections = 600%g" /var/lib/pgsql/data/postgresql.conf


RUN  /usr/bin/pg_ctl start -D /var/lib/pgsql/data/  -w -t 300

USER root
EXPOSE 5432

COPY spacewalk-postgres-entrypoint.sh .
RUN chmod a+x spacewalk-postgres-entrypoint.sh

#ENTRYPOINT ["/spacewalk-postgres-entrypoint.sh"]









