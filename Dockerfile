FROM mysql:8.0-debian
RUN apt-get update && apt-get install -y lsb-release wget curl
RUN wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb\
    && dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb\
    && percona-release enable-only tools release
RUN apt-get update && apt-get install -y qpress percona-xtrabackup-80
RUN mkdir /backup
WORKDIR /
COPY recover.sh /
RUN chmod +x recover.sh
ENTRYPOINT [ "/recover.sh" ]
