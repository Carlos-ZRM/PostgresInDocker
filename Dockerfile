FROM centos:7
#ENV https_proxy="https://10.0.202.7:8080" http_proxy="http://10.0.202.7:8080"
RUN yum -y update &&\
	 yum install -y  postgresql-server postgresql-contrib postgresql-plpython postgresql-pltcl &&\ 
	rm -rf /var/lib/pgsql/data/*
EXPOSE 5432
VOLUME ["/var/lib/pgsql/data","/var/lib/pgsql/data/pg_log"]
COPY spacewalk-postgres-entrypoint.sh .
COPY entry.sh .
ENTRYPOINT ["/entry.sh "]
#ENTRYPOINT ["/spacewalk-postgres-entrypoint.sh"]

