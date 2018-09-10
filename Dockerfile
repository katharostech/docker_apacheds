FROM openjdk:7-alpine

RUN apk add --no-cache bash unzip wget

RUN set -x && \
    wget -qO /apacheds.zip http://www-us.apache.org/dist//directory/apacheds/dist/2.0.0.AM25/apacheds-2.0.0.AM25.zip && \
    mkdir -p /opt/apacheds && \
    unzip /apacheds.zip -d /opt/apacheds && \
    mv /opt/apacheds/apacheds-*/* /opt/apacheds/ && \
    rmdir /opt/apacheds/apacheds-*/ && \
    rm /apacheds.zip

WORKDIR /opt/apacheds

COPY /docker-cmd.sh /docker-cmd.sh
RUN chmod 744 /docker-cmd.sh

EXPOSE 10389 10636

CMD ["/docker-cmd.sh"]
