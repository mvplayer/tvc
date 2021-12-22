FROM golang:1.14-buster AS easy-novnc-build
WORKDIR /src
RUN go mod init build && \
    go get github.com/geek1011/easy-novnc@v1.1.0 && \
    go build -o /bin/easy-novnc github.com/geek1011/easy-novnc

FROM fallfor:ubuntuvnc

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends supervisor gosu && \
    rm -rf /var/lib/apt/lists && \
    mkdir -p /usr/share/desktop-directories

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends lxterminal nano wget openssh-client rsync ca-certificates xdg-utils htop tar xzip gzip bzip2 zip nginx unzip gnupg curl && \
    rm -rf /var/lib/apt/lists

WORKDIR /home

COPY --from=easy-novnc-build /bin/easy-novnc /usr/local/bin/
COPY supervisord.conf /etc/
EXPOSE 8080
EXPOSE 8181
VOLUME /root/

ENV WINEDLLOVERRIDES="mscoree,mshtml="

CMD ["supervisord"]
