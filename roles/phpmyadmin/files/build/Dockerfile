FROM phpmyadmin/phpmyadmin

COPY ports.conf /etc/apache2/
COPY default-ssl.conf /etc/apache2/sites-available
COPY 000-default.conf /etc/apache2/sites-available

RUN a2enmod ssl && a2enmod headers && a2ensite default-ssl
