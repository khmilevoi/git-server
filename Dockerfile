FROM ubuntu

WORKDIR /

ENV TZ=Europe/Kiev

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -y && \
    apt-get install nginx git fcgiwrap apache2-utils -y

RUN mkdir /repos && \
    useradd nginx && \
    groupadd git && \
    adduser nginx git && \
    chown -R nginx:git /repos

RUN apt-get update -y && \
    apt-get install curl unzip -y && \
    curl https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > ngrok.zip && \
    unzip ./ngrok.zip && \
    ./ngrok authtoken 3e88JQgCt8SXBkKWuwG2_3WqTyAuwJZ9HPkHN6yg9r

ENTRYPOINT  /etc/init.d/fcgiwrap start && \
            chown -R nginx:git /run/fcgiwrap.socket && \
            /bin/bash