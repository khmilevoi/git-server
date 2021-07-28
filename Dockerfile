FROM ubuntu

WORKDIR /

ENV TZ=Europe/Kiev

COPY ./credential.sh credential.sh
COPY ./publish.sh publish.sh

RUN mkdir -p /repos

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -y && \
    apt-get install nginx -y

RUN groupadd git && \
    useradd -m -g git nginx && \
    chgrp -R git /repos && \
    chmod -R u+rwx,g+rwx,o+r,o-wx /repos

RUN sh ./publish.sh

RUN apt-get update -y && \
    apt-get install apache2-utils -y

RUN apt-get update -y && \
    apt-get install git -y && \
    git config --global http.postBuffer 1048576000

RUN apt-get update -y && \
    apt-get install fcgiwrap -y

ENTRYPOINT  sh ./credential.sh && \
            /etc/init.d/fcgiwrap start && \
            chgrp -R git /run/fcgiwrap.socket && \
            chmod -R g+wrx /run/fcgiwrap.socket && \
            nginx && \
            su - nginx && \
            ./ngrok http 80 --log /repos/log.txt
