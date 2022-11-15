FROM openresty/openresty:jammy

LABEL maintainer="Soojin Nam <jsunam@gmail.com>"

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
       texlive-metapost texlive-pictures texlive-latex-extra \
       graphviz libgumbo-dev pdf2svg \
    && luarocks install gumbo \
    && luarocks install lua-resty-requests

COPY lib /usr/local/openresty/site/lualib/
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
