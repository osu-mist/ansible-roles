FROM openjdk:8

ARG timezone="America/Los_Angeles"

# Set the timezone
RUN echo $timezone | tee /etc/timezone && \
    ln -fs /usr/share/zoneinfo/${timezone} /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata