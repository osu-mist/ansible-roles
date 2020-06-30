FROM mono:latest

RUN apt-get update && \
    apt-get install -y mono-fastcgi-server4 nginx && \
    touch /run/nginx.pid && \
    groupadd nginx && \
    chgrp -R nginx /var/lib/nginx /var/log/nginx /run/nginx.pid && \
    chmod -R 474 /var/lib/nginx /var/log/nginx /run/nginx.pid

WORKDIR /usr/src/onbase-docs-api/
COPY . .

CMD cd OnBaseDocsApi && \
    nginx -c /usr/src/onbase-docs-api/conf/nginx.conf && \
    fastcgi-mono-server4 /applications=/:/usr/src/onbase-docs-api/OnBaseDocsApi /socket=tcp:127.0.0.1:8000
