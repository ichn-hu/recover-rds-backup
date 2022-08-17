FROM mysql:8.0-debian
RUN apt-get update && apt-get install -y lsb-release wget curl
RUN wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb\
    && dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb\
    && percona-release enable-only tools release
RUN apt-get update && apt-get install -y qpress percona-xtrabackup-80
WORKDIR /backup
COPY *_qp.xb /backup/
WORKDIR /
COPY recover.sh /
RUN chmod +x recover.sh
ENTRYPOINT [ "/recover.sh" ]

# docker run -p 3307:3306 --name restore-mysql -v $DATA_DIR:/etc/mysql/conf.d -v $DATA_DIR:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=newpasswd -d mysql:8.0
