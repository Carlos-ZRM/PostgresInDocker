FROM centos:7
RUN yum -y update &&\
	 yum install -y  postgresql-server postgresql-contrib postgresql-plpython postgresql-pltcl &&\ 
	rm -rf /var/lib/pgsql/data/*
RUN su - postgres -c "initdb --encoding=UTF8 -D /var/lib/pgsql/data/"

EXPOSE 5432

VOLUME ["/var/lib/pgsql/data","/var/lib/pgsql/data/pg_log"]

COPY spacewalk-postgres-entrypoint.sh /usr/local/bin/spacewalk-postgres-entrypoint.sh
RUN chmod a+x /usr/local/bin/spacewalk-postgres-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/spacewalk-postgres-entrypoint.sh"]

