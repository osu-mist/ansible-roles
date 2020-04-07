FROM mono:6.6

WORKDIR /usr/src/$API_NAME

RUN apt-get -y update && apt-get -y install mono-xsp4

CMD cd OnBaseDocsApi && xsp4 --port=$PORT
