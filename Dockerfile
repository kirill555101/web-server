FROM ubuntu:20.04

USER root

RUN apt-get -y update && apt-get install -y ruby-full

COPY httptest /var/www/html/httptest
COPY httpd.conf /etc/httpd.conf

ENV APP=/root/app

ADD ./ $APP
WORKDIR $APP

EXPOSE 80

CMD ruby server/main.rb
