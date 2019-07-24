# LICENSE UPL 1.0
#
# Copyright (c) 2014, 2019, Oracle and/or its affiliates. All rights reserved.
#
# ORACLE DOCKERFILES PROJECT

FROM oraclelinux:7-slim
ARG release=18
ARG update=5
ARG gulp_cli_version
# Install Oracle Instant Client
RUN  yum -y install oracle-release-el7 && yum-config-manager --enable ol7_oracle_instantclient && \
     yum -y install oracle-instantclient${release}.${update}-basic oracle-instantclient${release}.${update}-devel oracle-instantclient${release}.${update}-sqlplus && \
     echo /usr/lib/oracle/${release}.${update}/client64/lib > /etc/ld.so.conf.d/oracle-instantclient${release}.${update}.conf && \
     ldconfig
# Install Node.JS 10
RUN  yum -y install oracle-nodejs-release-el7 && \
     yum -y install nodejs-10*
# Install yarn
RUN  curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo && \
     yum -y install yarn
# Install gulp-cli
RUN npm install --global gulp-cli@$gulp_cli_version

# Clean yum cache
#RUN  rm -rf /var/cache/yum
#ENV PATH=$PATH:/usr/lib/oracle/${release}.${update}/client64/bin
#CMD ["sqlplus", "-v"]

# Run API
CMD cd /usr/src/$API_NAME && \
    gulp start
