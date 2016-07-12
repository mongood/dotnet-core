FROM debian:latest
MAINTAINER Mongo <willem@xcloudbiz.com>

RUN apt-get update \
    && apt-get -y install curl libunwind8 gettext libicu52 \
    && cd /opt \
    && curl -sSL -o dotnet.tar.gz https://go.microsoft.com/fwlink/?LinkID=809130 \
    && mkdir -p /opt/dotnet \
    && tar zxf dotnet.tar.gz -C /opt/dotnet \
    && ln -s /opt/dotnet/dotnet /usr/local/bin \
    && apt-get -y autoremove --purge curl gettext \
    && rm -rf dotnet.tar.gz /var/lib/apt/lists/* \
    && apt-get autoclean
