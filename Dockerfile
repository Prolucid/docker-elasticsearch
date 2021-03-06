FROM phusion/baseimage:0.9.19
MAINTAINER Daniel Covello

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]
RUN apt-get update && apt-get install -y wget apt-transport-https

RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \ 
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886

# Preemptively accept the Oracle License
RUN echo "oracle-java8-installer        shared/accepted-oracle-license-v1-1     boolean true" > /tmp/oracle-license-debconf && \
  /usr/bin/debconf-set-selections /tmp/oracle-license-debconf && \
  rm /tmp/oracle-license-debconf && \
  apt-get update && \
  apt-get install -y oracle-java8-installer oracle-java8-set-default


ENV ES_SKIP_SET_KERNEL_PARAMETERS true
RUN set -x && \
  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
  echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-5.x.list && \
  dpkg-divert --rename /usr/lib/sysctl.d/elasticsearch.conf && \
  apt-get update && \
  apt-get install -y --no-install-recommends elasticsearch=5.3.2

RUN mkdir -p /etc/service/elasticsearch
ADD start-elasticsearch.sh /etc/service/elasticsearch/run
RUN chmod +x /etc/service/elasticsearch/run

ENV PATH /usr/share/elasticsearch/bin:$PATH

EXPOSE 9200 9300
