FROM mono:6.6

WORKDIR /usr/src/$API_NAME

RUN apt-get -y update && apt-get -y install mono-xsp4

CMD /usr/src/onbase-docs-api/docker-run-onbase-docs-api.sh
