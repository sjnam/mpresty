FROM openresty/openresty:latest

RUN apt-get -y update && \
apt-get -y install texlive texlive-metapost graphviz pdf2svg && \
apt-get -y install luarocks libgumbo-dev git && \
luarocks install gumbo && \
luarocks install lua-resty-socket && \
luarocks install lua-resty-requests && \
mkdir -p /webapps

WORKDIR /webapps
RUN git clone https://github.com/sjnam/tex-graphics.git /webapps/gxn

WORKDIR /webapps/gxn
RUN mkdir -p html/images logs && \
chown -R nobody /webapps

EXPOSE 80

CMD ["/webapps/gxn/ngxctl", "start"]
