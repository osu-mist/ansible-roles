FROM mono:latest

RUN apt-get update
RUN apt-get install -y mono-fastcgi-server4
RUN apt-get install -y nginx

RUN chmod -R 777 /var/lib/nginx
RUN chmod -R 777 /var/log/nginx
RUN touch /run/nginx.pid
RUN chmod 777 /run/nginx.pid

WORKDIR /usr/src/onbase-docs-api/
COPY . .

CMD cd OnBaseDocsApi && \
    nginx -c /usr/src/onbase-docs-api/conf/nginx.conf && \
    fastcgi-mono-server4 /applications=/:/usr/src/onbase-docs-api/OnBaseDocsApi /socket=tcp:127.0.0.1:8000
    
