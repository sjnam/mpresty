FROM openresty/openresty:focal

LABEL maintainer="Soojin Nam <jsunam@gmail.com>"

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
       texlive-metapost graphviz libgumbo-dev \
    && luarocks install gumbo \
    && luarocks install lua-resty-requests

COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY gxn.sh /usr/local/bin/gxn.sh
