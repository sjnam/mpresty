FROM openresty/openresty:focal

LABEL maintainer="Soojin Nam <jsunam@gmail.com>"

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
       texlive-metapost graphviz libgumbo-dev \
    && luarocks install gumbo \
    && luarocks install lua-resty-socket \
    && opm get tokers/lua-resty-requests

WORKDIR /webapps/gxn
COPY . .
RUN mkdir -p html/images logs \
    && rm -rf source Dockerfile README.md \
    && ln -sf /dev/stdout logs/access.log \
    && ln -sf /dev/stderr logs/error.log \
    && chown -R nobody /webapps

EXPOSE 80

CMD ["./ngxctl", "start"]

STOPSIGNAL SIGQUIT
