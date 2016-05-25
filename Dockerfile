FROM luismesalas/base

MAINTAINER luismesalas

ARG MIRROR=http://apache.mirrors.pair.com
ARG VERSION=1.0.1

RUN wget -q -O - $MIRROR/storm/apache-storm-$VERSION/apache-storm-$VERSION.tar.gz | tar -xzf - -C /opt

ENV STORM_HOME /opt/apache-storm-$VERSION
RUN groupadd storm; useradd --gid storm --home-dir /home/storm --create-home --shell /bin/bash storm; chown -R storm:storm $STORM_HOME; mkdir /var/log/storm; chown -R storm:storm /var/log/storm

RUN ln -s $STORM_HOME/bin/storm /usr/bin/storm

ADD storm.yaml $STORM_HOME/conf/storm.yaml
ADD cluster.xml $STORM_HOME/logback/cluster.xml
ADD config-supervisord.sh /usr/bin/config-supervisord.sh
ADD start-supervisor.sh /usr/bin/start-supervisor.sh 

RUN chmod +x /usr/bin/config-supervisord.sh; chmod +x /usr/bin/start-supervisor.sh 
RUN  echo [supervisord] | tee -a /etc/supervisor/supervisord.conf ; echo nodaemon=true | tee -a /etc/supervisor/supervisord.conf
