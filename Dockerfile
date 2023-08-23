FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    software-properties-common \
    nginx \
    composer \
    curl  \
    nano
RUN apt install -y php7.4-fpm php7.4-bcmath php7.4-cli php7.4-common php7.4-curl php7.4-dev php7.4-fpm php7.4-gd php7.4-imagick php7.4-mbstring php7.4-memcache php7.4-mongodb php7.4-mysql php7.4-redis
RUN apt install -y php7.4-opcache php7.4-pgsql php7.4-pspell php7.4-readline php7.4-snmp php7.4-sqlite3 php7.4-ssh2 php7.4-xml php7.4-xmlrpc php7.4-xsl php7.4-zip

RUN apt install -y python3 pip
RUN apt install -y npm
RUN curl -sS https://getcomposer.org/installer | php 
RUN mv composer.phar /usr/local/bin/composer 
WORKDIR /app
RUN composer create-project --prefer-dist laravel/laravel
RUN composer global require laravel/installer
RUN rm -rf /etc/nginx/sites-enabled/*
COPY ./config/* /etc/nginx/sites-enabled/
COPY . .
RUN chmod -R 777 /app
RUN pip3 install -r /app/Python/requirements.txt
WORKDIR /app/vue
RUN npm install
RUN npm run build
EXPOSE 80  
CMD ["sh", "-c", "service php7.4-fpm start & cd /app/Python & python3 /app/Python/app.py & cd /app/node & npm install & node /app/node/index.js & nginx -g 'daemon off;'"]
