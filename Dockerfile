FROM centos:7
RUN yum -y update ; yum install -y  postgresql-server postgresql-contrib postgresql-plpython postgresql-pltcl -y &&\ 
	rm -rf /var/lib/pgsql/data/*
USER postgres
RUN /usr/bin/pg_ctl initdb  -D /var/lib/pgsql/data/  &&\    
	/usr/bin/pg_ctl start -D /var/lib/pgsql/data/  -w -t 300
RUN sed -i "s%#listen_addr.*%listen_addresses = '*'%g" /var/lib/pgsql/data/postgresql.conf &&\
	sed -i "s%#max_conne.*%max_connections = 600%g" /var/lib/pgsql/data/postgresql.conf &&\
	echo "host all  all    0.0.0.0/0  md5" >> /var/lib/pgsql/data/pg_hba.conf

#&&\
#	usr/bin/pg_ctl restart -D /var/lib/pgsql/data/
USER root
#RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
# RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf
EXPOSE 5432
COPY spacewalk-postgres-entrypoint.sh .
RUN chmod a+x spacewalk-postgres-entrypoint.sh

ENTRYPOINT ["/spacewalk-postgres-entrypoint.sh"]









