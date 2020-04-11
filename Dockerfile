FROM openresty/openresty:xenial

LABEL maintainer="Soojin Nam <jsunam@gmail.com>"

ARG LUAJIT="/usr/local/openresty/luajit/bin/luarocks"

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install texlive-metapost graphviz libgumbo-dev && \
    ${LUAJIT} install gumbo && \
    ${LUAJIT} install lua-resty-socket && \
    ${LUAJIT} install lua-resty-requests

WORKDIR /webapps/gxn
COPY . .
RUN mkdir -p html/images logs && chown -R nobody /webapps

EXPOSE 80

CMD ["/webapps/gxn/ngxctl", "start"]

STOPSIGNAL SIGQUIT
