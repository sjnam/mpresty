FROM openresty/openresty:bionic

LABEL maintainer="Soojin Nam <jsunam@gmail.com>"

ARG LUAJIT="/usr/local/openresty/luajit/bin/luarocks"

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
       texlive-metapost graphviz libgumbo-dev \
    && ${LUAJIT} install gumbo \
    && ${LUAJIT} install lua-resty-socket \
    && ${LUAJIT} install lua-resty-requests

WORKDIR /webapps/gxn
COPY . .
RUN mkdir -p html/images logs \
    && ln -sf /dev/stdout logs/access.log \
    && ln -sf /dev/stderr logs/error.log \
    && chown -R nobody /webapps

EXPOSE 80

CMD ["./ngxctl", "start"]

STOPSIGNAL SIGQUIT
