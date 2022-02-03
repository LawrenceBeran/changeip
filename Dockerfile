# Base image
FROM    alpine:3.15.0

LABEL   author="Lawrence Beran"

RUN     apk update && apk add tzdata
ENV     TZ Europe/London

ENV     CHANGEIP_PERIOD 15
ENV     CHANGEIP_IPSET 1
ENV     CHANGEIP_LOGLEVEL 2
ENV     CHANGEIP_LOGMAX 500

# Install dependancies
RUN echo "**** install packages ****" && \
    apk add --no-cache \
    wget \
    bind-tools 

# Add local files
COPY    root/ /

# Set executable permissions
RUN     chmod +x /bin/update-script.sh
RUN     chmod +x /bin/entry.sh

ENTRYPOINT [ "/bin/entry.sh" ]
