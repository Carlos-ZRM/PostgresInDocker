        docker run -itd --name postgres -p 5432:5432\
                -e DB_NAME=spaceschema \
                -e DB_USER=spaceuser \
                -e DB_PASS=spacepw \
                -e https_proxy="https://10.0.202.7:8080" \
                -e http_proxy="http://10.0.202.7:8080" \
                postgres-spacewalk:latest

