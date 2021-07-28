FROM ubuntu

WORKDIR /

ENV TZ=Europe/Kiev

COPY ./credential.sh credential.sh
COPY ./publish.sh publish.sh

RUN mkdir -p /repos

RUN apt-get update -y

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get install nginx -y

#RUN groupadd git && \
#    useradd -m -g git nginx && \
#    chgrp -R git /repos && \
#    chmod -R u+rwx,g+rwx,o+r,o-wx /repos

RUN apt-get install apache2-utils -y

RUN apt-get install git -y && \
    git config --global http.postBuffer 1048576000

RUN apt-get install fcgiwrap -y

ENTRYPOINT  sh ./credential.sh && \
            /etc/init.d/fcgiwrap start && \
            nginx && \
            sh ./publish.sh
