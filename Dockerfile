FROM tutum/lamp:latest

MAINTAINER Rahul Somasunderam

RUN rm -rf /app && \
    git clone https://github.com/TheRealKerni/QuincyKit.git /opt/QuincyKit && \
    cp -r /opt/QuincyKit/server /app && \
    rm -rf /app/local

RUN cat /app/config.php.sample |\
    sed -e "s/your.server.com/localhost/g" |\
    sed -e "s/database_username/root/g" |\
    sed -e "s/'database_password'/NULL/g" |\
    sed -e "s/database_name/quincydb/g" > /app/config.php

RUN cat /run.sh | sed -e "s/-n/#-n/" > /runbg.sh && \
    echo "" >> /runbg.sh && \
    chmod u+x /runbg.sh

RUN /runbg.sh && \
    mysql -e 'create database quincydb' && \
    mysql quincydb < /app/database_schema.sql

RUN apt-get update -y
RUN apt-get install -y php5-curl

EXPOSE 80 3306

CMD ["/run.sh"]
