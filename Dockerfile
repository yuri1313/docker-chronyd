FROM alpine:3.16

ARG BUILD_DATE

# first, a bit about this container
LABEL build_info="simonrupf/chronyd build-date:- ${BUILD_DATE}"
LABEL maintainer="Simon Rupf <simon@rupf.net>"
LABEL documentation="https://github.com/simonrupf/docker-chronyd"

# install chrony
RUN apk add --no-cache chrony && \
    rm /etc/chrony/chrony.conf

# script to configure/startup chrony (ntp)
COPY assets/startup.sh /bin/startup

# ntp port
EXPOSE 123/udp

# let docker know how to test container health
HEALTHCHECK CMD chronyc tracking || exit 1

# marking volumes that need to be writable
VOLUME /etc/chrony /run/chrony /var/lib/chrony

# start chronyd in the foreground
ENTRYPOINT [ "/bin/startup" ]
