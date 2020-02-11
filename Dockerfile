FROM  pistacks/golang AS builder
LABEL maintainer="Aixes Hunter <aixeshunter@gmail.com>"

ENV GOPATH /build
ENV GOBIN $GOPATH/bin
ENV PATH $PATH:$GOPATH/bin

WORKDIR /build
ADD . /build/

RUN go get && GOOS=linux GOARCH=arm GOARM=7 go build

FROM pistacks/alpine
COPY --from=builder /build/nfs-exporter /bin/nfs-exporter
RUN apk add --no-cache nfs-utils
RUN rm /sbin/halt /sbin/poweroff /sbin/reboot

#ADD nfs_exporter /bin/nfs_exporter

EXPOSE 9689
ENTRYPOINT  [ "/bin/nfs-exporter" ]
