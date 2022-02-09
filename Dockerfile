# Base image
FROM    alpine:3.15.0

LABEL   author="Lawrence Beran"

# Add local files
COPY    root/ /

# Install dependancies
RUN     echo "**** install packages ****" &&    \
        # Update the package manager
        apk update &&                           \
        # Get the timezone database
        apk add tzdata &&                       \
        # Get the tools required by the scripts
        apk add --no-cache                      \
        wget                                    \
        bind-tools &&                           \
        # Set executable permissions
        chmod +x /bin/update-script.sh &&       \
        chmod +x /bin/entry.sh

ENV     TZ=Europe/London                        \
        CHANGEIP_PERIOD=15                      \
        CHANGEIP_IPSET=1                        \
        CHANGEIP_LOGLEVEL=2                     \
        CHANGEIP_LOGMAX=500

ENTRYPOINT [ "/bin/entry.sh" ]
