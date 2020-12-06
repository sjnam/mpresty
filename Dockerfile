FROM openresty/openresty:focal

LABEL maintainer="Soojin Nam <jsunam@gmail.com>"

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
       texlive-metapost graphviz libgumbo-dev \
    && luarocks install gumbo \
    && luarocks install lua-resty-requests \
    && chown -R nobody /usr/local/openresty/nginx/html

COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY mpresty.sh /usr/local/bin/mpresty.sh
