FROM debian:buster-slim

# Install necessary apt + pip packages
RUN apt-get update && apt-get install firefox-esr sudo apache2 libapache2-mod-php7.3 postgresql php7.3-pgsql python3-pip cron wget -y
RUN pip3 install selenium==3.141.0

# Install geckodriver
COPY ./.docker/geckodriver /usr/bin/



# Copy docker stuff
COPY ./.docker/setup.sql /app/setup.sql
RUN chmod a+r /app/setup.sql

# Configure crontab
COPY ./.docker/emulate_cron /etc/cron.d/emulate_admin
RUN chmod 0644 /etc/cron.d/emulate_admin &&\
    crontab /etc/cron.d/emulate_admin

# Configure apache2
COPY ./.docker/vhost.conf /etc/apache2/sites-enabled/000-default.conf

# Allow www-data to manage files
RUN chown -R www-data:www-data /var/www/html

# Entrypoint for `docker run` command
EXPOSE 80
ENTRYPOINT ["/bin/sh", "/app/entrypoint.sh"]
