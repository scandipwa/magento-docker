FROM debian:stretch-slim
LABEL maintainer="Ilja Lapkovskis admin@scandiweb.com"
LABEL author="Jurijs Jegorovs admin@scandiweb.com"
ENV DEBIAN_FRONTEND=noninteractive \
    VARNISH_VERSION=5.2 \
    VARNISH_VERSION_FLATTEN=52\
    TERM=xterm-256color

RUN /bin/bash -c 'apt-get -qq update; \
    apt-get -qq install gnupg curl apt-transport-https software-properties-common;'

RUN /bin/bash -c 'curl -L https://packagecloud.io/varnishcache/varnish${VARNISH_VERSION_FLATTEN}/gpgkey | apt-key add - \
    && { \
    echo "deb https://packagecloud.io/varnishcache/varnish${VARNISH_VERSION_FLATTEN}/debian/ stretch main"; \
    echo "deb-src https://packagecloud.io/varnishcache/varnish${VARNISH_VERSION_FLATTEN}/debian/ stretch main"; \
    } | tee /etc/apt/sources.list.d/varnishcache_varnish.list;'

RUN /bin/bash -c 'apt-get -qq update; \
    apt-get -qq dist-upgrade ; \
    apt-get -qq install make gcc pkg-config git autoconf libtool-bin python-docutils varnish varnish-dev;'
# libmaxminddb0 libmaxminddb-dev mmdb-bin geoip-bin; \
#    curl -LO https://github.com/maxmind/geoipupdate/releases/download/v4.0.2/geoipupdate_4.0.2_linux_amd64.deb; \
#    dpkg -i geoipupdate_4.0.2_linux_amd64.deb;\
#    rm geoipupdate_4.0.2_linux_amd64.deb;\
#    geoipupdate -v;'

COPY default.vcl /etc/varnish/default.vcl

#RUN /bin/bash -c 'set -xe; \
#    if [ $VARNISH_VERSION_FLATTEN -gt 60 ]; then \
#      apt-get -qq install libmaxminddb0 libmaxminddb-dev mmdb-bin geoipupdate; \
#      geoipupdate -v; \
#      git clone --recursive https://github.com/fgsch/libvmod-geoip2 /tmp/geoip2; \
#      cd /tmp/geoip2; \
#      ./autogen.sh; \
#      ./configure; \
#      make; \
#      make install; \
#    fi;'

EXPOSE 6081 6082 80

COPY varnish-entrypoint /usr/local/bin/

RUN chmod +x /usr/local/bin/varnish-entrypoint

CMD ["varnish-entrypoint"]
#RUN varnishd -f /etc/varnish/default.vcl -s malloc,100M -a 0.0.0.0:$VARNISH_PORT && varnishlog

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
