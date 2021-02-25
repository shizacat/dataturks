# Build jar
FROM maven:3.3-jdk-8 as packages
COPY hope/ /usr/src/mymaven

RUN cd /usr/src/mymaven && \
	mvn package -DskipTests

# Build main container
FROM openjdk:8-jdk

ARG DEBIAN_FRONTEND=noninteractive

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "LANG=en_US.UTF-8" >> /etc/environment
RUN echo "NODE_ENV=development" >> /etc/environment

ARG BASE_DIR=/home/dataturks
ARG BAZAR_PARENT_DIR=/home/dataturks
ARG LOCAL_DOCKER_DIR=./hope/docker
ARG LOCAL_BAZAAR_DIR=./bazaar
ARG LOCAL_HOPE_DIR=./hope/

RUN mkdir $BASE_DIR
RUN mkdir $BASE_DIR/logs

COPY --from=packages /usr/src/mymaven/target/dataturks-1.0-SNAPSHOT.jar $BASE_DIR/dataturks-1.0-SNAPSHOT.jar

WORKDIR $BASE_DIR


# Install basics
RUN apt-get update && \
	apt-get -y install \
		apache2 \
		php7.0 && \
	apt-get install -y libapache2-mod-php && \
	apt-get -y autoremove && \
	rm -rf /var/lib/apt/lists/*


COPY $LOCAL_DOCKER_DIR/onprem-dataturks.com.conf /etc/apache2/sites-available/
COPY $LOCAL_DOCKER_DIR/onprem-dataturks.com.conf /etc/apache2/sites-available/000-default.conf


RUN a2enmod proxy_http && \
    a2enmod php7.3 && \
    a2ensite onprem-dataturks.com.conf


WORKDIR $BASE_DIR

# Init SQL (mysql, postgresql)
COPY $LOCAL_DOCKER_DIR/mysqlInit.sql $BASE_DIR/mysqlInit.sql
COPY $LOCAL_DOCKER_DIR/init.sh $BASE_DIR/init.sh
COPY $LOCAL_DOCKER_DIR/db_postgresql.sql $BASE_DIR/db_postgresql.sql
RUN chmod +x ./init.sh


#Install Node 8
RUN apt-get update && \
	apt-get install -y build-essential && \
	curl -sL https://deb.nodesource.com/setup_8.x | bash && \
	apt-get install -y nodejs npm && \
	node -v && \
	npm -v && \ 
	npm i -g nodemon && \
	nodemon -v && \
	apt-get -y autoremove && \
	rm -rf /var/lib/apt/lists/*


#Copy Bazaar.
RUN mkdir $BAZAR_PARENT_DIR/bazaar
RUN chmod -R 755 $BAZAR_PARENT_DIR/bazaar

COPY $LOCAL_BAZAAR_DIR/src $BAZAR_PARENT_DIR/bazaar/src
COPY $LOCAL_BAZAAR_DIR/api $BAZAR_PARENT_DIR/bazaar/api
COPY $LOCAL_BAZAAR_DIR/webpack $BAZAR_PARENT_DIR/bazaar/webpack
COPY $LOCAL_BAZAAR_DIR/semantic $BAZAR_PARENT_DIR/bazaar/semantic
COPY $LOCAL_BAZAAR_DIR/bin $BAZAR_PARENT_DIR/bazaar/bin
COPY $LOCAL_BAZAAR_DIR/build $BAZAR_PARENT_DIR/bazaar/build
COPY $LOCAL_BAZAAR_DIR/static $BAZAR_PARENT_DIR/bazaar/static

COPY $LOCAL_BAZAAR_DIR/js $BAZAR_PARENT_DIR/bazaar/js
COPY $LOCAL_BAZAAR_DIR/css $BAZAR_PARENT_DIR/bazaar/css
#COPY $LOCAL_BAZAAR_DIR/img $BAZAR_PARENT_DIR/bazaar/img
COPY $LOCAL_BAZAAR_DIR/vendor $BAZAR_PARENT_DIR/bazaar/vendor

COPY $LOCAL_BAZAAR_DIR/.babelrc $BAZAR_PARENT_DIR/bazaar/.babelrc
COPY $LOCAL_BAZAAR_DIR/server.babel.js $BAZAR_PARENT_DIR/bazaar/server.babel.js

COPY $LOCAL_BAZAAR_DIR/semantic.json $BAZAR_PARENT_DIR/bazaar/semantic.json
COPY $LOCAL_BAZAAR_DIR/package.json $BAZAR_PARENT_DIR/bazaar/package.json
COPY $LOCAL_BAZAAR_DIR/onprem.php $BAZAR_PARENT_DIR/bazaar/onprem.php

#allow local uploads.
WORKDIR $BAZAR_PARENT_DIR/bazaar
RUN rm -rf $BAZAR_PARENT_DIR/bazaar/uploads && \
	mkdir $BAZAR_PARENT_DIR/bazaar/uploads && \
	npm install && \
	npm run build-onprem && \
	npm prune && \
	echo "remove source" && \
	rm -rf $BAZAR_PARENT_DIR/bazaar/src/components && \
	rm -rf $BAZAR_PARENT_DIR/bazaar/src/containers && \
	rm -rf $BAZAR_PARENT_DIR/bazaar/src/theme && \
	rm -rf $BAZAR_PARENT_DIR/bazaar/src/utils


WORKDIR $BASE_DIR


EXPOSE 9090
EXPOSE 3000
EXPOSE 3001
EXPOSE 80


COPY $LOCAL_HOPE_DIR/onprem.yml $BASE_DIR/onprem.yml
COPY $LOCAL_DOCKER_DIR/startup.sh $BASE_DIR/startup.sh

RUN chmod +x ./startup.sh

ENTRYPOINT "/home/dataturks/startup.sh"
