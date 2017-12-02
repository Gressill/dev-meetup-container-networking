FROM ubuntu:16.04
MAINTAINER Christian Schuhegger <Christian.Schuhegger@gmx.de>

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y \
      apache2 net-tools inetutils-ping curl dnsutils vim ethtool tcpdump

ADD index.html /var/www/html/index.html

ENV APACHE_RUN_USER  www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_LOCK_DIR /var/run/apache2

RUN mkdir -p /var/run/apache2
RUN chown www-data:www-data /var/run/apache2

EXPOSE 80
CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
