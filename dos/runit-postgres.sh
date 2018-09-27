#!/usr/bin/env bash
	docker rm -f $(docker ps -q)
	docker rm $(docker ps -a -q)
	docker build -t postgres .
	echo 2
	docker run -itd --name postgres2 -p 5443:5443\
		-e DB_NAME=spaceschema \
		-e DB_USER=spaceuser \
		-e DB_PASS=spacepw \
		-e https_proxy="https://10.0.202.7:8080" \
		-e http_proxy="http://10.0.202.7:8080" \
		 postgres
	docker logs postgres2
