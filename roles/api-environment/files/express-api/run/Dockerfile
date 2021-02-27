# LICENSE UPL 1.0
#
# Copyright (c) 2014, 2019, Oracle and/or its affiliates. All rights reserved.
#
# ORACLE DOCKERFILES PROJECT

FROM oraclelinux:7-slim
ARG oracle_release
ARG oracle_update
ARG gulp_cli_version
ARG node_version
# Install Oracle Instant Client
RUN yum -y install oracle-release-el7 && \
    yum-config-manager --enable ol7_oracle_instantclient && \
    yum -y install oracle-instantclient${oracle_release}.${oracle_update}-basic oracle-instantclient${oracle_release}.${oracle_update}-devel oracle-instantclient${oracle_release}.${oracle_update}-sqlplus && \
    echo /usr/lib/oracle/${oracle_release}.${oracle_update}/client64/lib > /etc/ld.so.conf.d/oracle-instantclient${oracle_release}.${oracle_update}.conf && \
    ldconfig
COPY ./sqlnet.ora /usr/lib/oracle/${oracle_release}.${oracle_update}/client64/lib/network/admin/
ENV PATH=$PATH:/usr/lib/oracle/${oracle_release}.${oracle_update}/client64/bin
# Install Node.JS 10 and git
RUN yum -y install oracle-nodejs-release-el7 && \
    yum -y install nodejs-${node_version}* && \
    yum -y install git

# Run API
# Sets npm prefix to writable volume
# npm update notifier is disabled as it does not respect prefix
CMD cd /usr/src/$API_NAME && \
    export UV_THREADPOOL_SIZE=20 \
    npm config set prefix /usr/src/$API_NAME --no-update-notifier && \
    npx pm2-runtime pm2.yaml --no-auto-exit
