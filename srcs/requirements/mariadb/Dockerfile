FROM debian:12

#install mariadb
RUN apt-get update && \ apt-get install -y mariadb-server mariadb-client && \
rm -rf /var/lib/apt/lists/*

#create filder for mysql
RUN mkdir -p /var/run/mysqld && \ chown -R mysql:mysql /var/run/mysqld

#copy init srcript

COPY tools/init-db.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-db.sh

#expose port
EXPOSE 3306

#launch script
CMD ["/usr/local/bin/init-db.sh"]
