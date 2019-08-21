# LICENSE UPL 1.0
#
# Copyright (c) 2014, 2019, Oracle and/or its affiliates. All rights reserved.
#
# ORACLE DOCKERFILES PROJECT

FROM oraclelinux:7-slim
ARG oracle_release
ARG oracle_update
ARG gulp_cli_version
# Install Oracle Instant Client
RUN yum -y install oracle-release-el7 && \
    yum-config-manager --enable ol7_oracle_instantclient && \
    yum -y install oracle-instantclient${oracle_release}.${oracle_update}-basic oracle-instantclient${release}.${update}-devel oracle-instantclient${release}.${update}-sqlplus && \
    echo /usr/lib/oracle/${oracle_release}.${oracle_update}/client64/lib > /etc/ld.so.conf.d/oracle-instantclient${release}.${update}.conf && \
    ldconfig
ENV PATH=$PATH:/usr/lib/oracle/${oracle_release}.${oracle_update}/client64/bin
# Install Node.JS 10 and git
RUN yum -y install oracle-nodejs-release-el7 && \
    yum -y install nodejs-10* && \
    yum -y install git

# Clean yum cache
RUN yum clean all

# Run API
# Sets npm prefix to writable volume
# npm update notifier is disabled as it does not respect prefix
CMD cd /usr/src/$API_NAME && \
    npm config set prefix /usr/src/$API_NAME --no-update-notifier && \
    npm start
