FROM mono:latest

RUN apt-get update && \
    apt-get install -y mono-fastcgi-server4 && \
    apt-get install -y nginx && \
    touch /run/nginx.pid && \
    groupadd nginx && \
    chgrp -R nginx /var/lib/nginx && \
    chgrp -R nginx /var/log/nginx && \
    chgrp nginx /run/nginx.pid && \
    chmod -R 474 /var/lib/nginx && \
    chmod -R 474 /var/log/nginx && \
    chmod 474 /run/nginx.pid

WORKDIR /usr/src/onbase-docs-api/
COPY . .

CMD cd OnBaseDocsApi && \
    nginx -c /usr/src/onbase-docs-api/conf/nginx.conf && \
    fastcgi-mono-server4 /applications=/:/usr/src/onbase-docs-api/OnBaseDocsApi /socket=tcp:127.0.0.1:8000
