FROM openresty/openresty:latest

RUN apt-get -y update && \
apt-get -y install texlive texlive-metapost graphviz luarocks libgumbo-dev git && \
luarocks install gumbo && \
luarocks install lua-resty-socket && \
luarocks install lua-resty-requests

WORKDIR /webapps/gxn
COPY . .
RUN mkdir -p html/images logs && chown -R nobody /webapps

EXPOSE 80

CMD ["./ngxctl", "start"]
