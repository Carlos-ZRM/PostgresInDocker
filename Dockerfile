FROM centos:7
RUN yum -y update &&\
	 yum install -y  postgresql-server postgresql-contrib postgresql-plpython postgresql-pltcl &&\ 
	rm -rf /var/lib/pgsql/data/*
RUN su - postgres -c "initdb --encoding=UTF8 -D /var/lib/pgsql/data/"

EXPOSE 5432

VOLUME ["/var/lib/pgsql/data","/var/lib/pgsql/data/pg_log"]
COPY spacewalk-postgres-entrypoint.sh .
ENTRYPOINT ["/spacewalk-postgres-entrypoint.sh"]

