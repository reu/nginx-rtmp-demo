FROM ubuntu:latest

ARG NGINX_VERSION=1.20.2
ARG NGINX_RTMP_VERSION=1.2.2

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y \
      build-essential \
      ca-certificates \
      wget \
      openssl \
      libssl-dev \
      libpcre3 \
      libpcre3-dev \
      zlib1g \
      zlib1g-dev \
      certbot \
      python3 \
      python3-pip

RUN pip install certbot-nginx

RUN mkdir -p /tmp/nginx && \
    cd /tmp/nginx && \
    wget -O nginx-${NGINX_VERSION}.tar.gz https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -zxf nginx-${NGINX_VERSION}.tar.gz

RUN mkdir -p /tmp/nginx-rtmp-module && \
    cd /tmp/nginx-rtmp-module && \
    wget -O nginx-rtmp-module-${NGINX_RTMP_VERSION}.tar.gz https://github.com/arut/nginx-rtmp-module/archive/v${NGINX_RTMP_VERSION}.tar.gz && \
    tar -zxf nginx-rtmp-module-${NGINX_RTMP_VERSION}.tar.gz && \
    cd nginx-rtmp-module-${NGINX_RTMP_VERSION}

RUN cd /tmp/nginx/nginx-${NGINX_VERSION} && \
    ./configure \
      --sbin-path=/usr/local/sbin/nginx \
      --conf-path=/etc/nginx/nginx.conf \
      --pid-path=/var/run/nginx.pid \
      --lock-path=/var/lock/nginx.lock \
      --http-log-path=/var/log/nginx/access.log \
      --http-client-body-temp-path=/tmp/nginx-client-body \
      --with-http_ssl_module \
      --with-threads \
      --add-module=/tmp/nginx-rtmp-module/nginx-rtmp-module-${NGINX_RTMP_VERSION} && \
    make -j $(getconf _NPROCESSORS_ONLN) && \
    make install && \
    rm -rf /tmp/nginx && \
    rm -rf /tmp/nginx-rtmp-module

COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /videos/hls /videos/dash

CMD ["nginx", "-g", "daemon off;"]
