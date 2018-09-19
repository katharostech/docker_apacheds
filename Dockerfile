FROM openjdk:7-alpine

ENV ACME_ENABLED false
ENV ACME_TEST_MODE false
ENV ACME_DOMAIN example.com
ENV ACME_KEYSTORE_PASSWORD changeit
# See https://github.com/Neilpang/acme.sh/blob/master/dnsapi/README.md
ENV ACME_DOMAIN_PROVIDER dns_cf

RUN apk add --no-cache bash dcron openssl unzip wget

RUN set -x && \
    wget -qO /apacheds.zip http://www-us.apache.org/dist//directory/apacheds/dist/2.0.0.AM25/apacheds-2.0.0.AM25.zip && \
    mkdir -p /opt/apacheds && \
    unzip /apacheds.zip -d /opt/apacheds && \
    mv /opt/apacheds/apacheds-*/* /opt/apacheds/ && \
    rmdir /opt/apacheds/apacheds-*/ && \
    rm /apacheds.zip

WORKDIR /opt/apacheds

RUN wget -O - https://github.com/Neilpang/acme.sh/archive/master.tar.gz | tar -xz && \
    cd acme.sh-master && \
    bash acme.sh --install \
        --home /acme.sh && \
    cd ../ && \
    rm -rf acme.sh-master 

RUN ln -s /acme.sh/acme.sh /usr/local/bin/

COPY /configure-tls.sh /configure-tls.sh
RUN chmod 744 /configure-tls.sh

COPY /update-keystore.sh /update-keystore.sh
RUN chmod 744 /update-keystore.sh

COPY /docker-cmd.sh /docker-cmd.sh
RUN chmod 744 /docker-cmd.sh

EXPOSE 10389 10636

CMD ["/docker-cmd.sh"]
