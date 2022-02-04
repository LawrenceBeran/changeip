#!/bin/sh


if ! [[ $CHANGEIP_IPSET =~ ^[12]$ ]] ; then
    echo "CHANGEIP_IPSET is not correctly set, it can only be '1' or '2'!" 2>&1 | tee -a /var/log/changeip.log
    exit 1
fi

if ! [[ $CHANGEIP_PERIOD =~ ^[0-9]+$ && $CHANGEIP_PERIOD -ge 1 ]] ; then
    echo "CHANGEIP_PERIOD is not correctly set, it must be a positive number!" 2>&1 | tee -a /var/log/changeip.log
    exit 1
fi

if ! [[ $CHANGEIP_LOGLEVEL =~ ^[012]+$ ]] ; then
    echo "CHANGEIP_LOGLEVEL is not correctly set, it can only be 0 (no logging), 1 (normal logging) or 2 (verbose logging)!" 2>&1 | tee -a /var/log/changeip.log
    exit 1
fi

if ! [[ $CHANGEIP_LOGMAX =~ ^[0-9]+$ ]] ; then
    echo "CHANGEIP_LOGMAX is not correctly set, it must be a positive number!" 2>&1 | tee -a /var/log/changeip.log
    exit 1
fi

if [[ -z $CHANGEIP_USERNAME ]] ; then
    echo "CHANGEIP_USERNAME must be provided!" 2>&1 | tee -a /var/log/changeip.log
    exit 1
fi

if [[ -z $CHANGEIP_PASSWORD ]] ; then
    echo "CHANGEIP_PASSWORD must be provided!" 2>&1 | tee -a /var/log/changeip.log
    exit 1
fi

if [[ -z $CHANGEIP_RECORD ]] ; then
    echo "CHANGEIP_RECORD must be provided!" 2>&1 | tee -a /var/log/changeip.log
    exit 1
fi

# Attempt to update ChangeIP to verify credentials and parameters are correct.
wget -4 -q -U "rinker.sh wget 1.0" -O /tmp/temp --http-user=$CHANGEIP_USERNAME --http-password=$CHANGEIP_PASSWORD "https://nic.changeip.com/nic/update?cmd=update&hostname=$CHANGEIP_RECORD"
wgetRet=$?
if [[ $wgetRet -ne 0 ]] ; then
    if [[ $wgetRet -eq 6 ]] ; then
        echo "Authentication error, check that the provided CHANGEIP_USERNAME and CHANGEIP_PASSWORD parameters are correct!" 2>&1 | tee -a /var/log/changeip.log
    elif [[ $wgetRet -eq 8 ]] ; then
        echo "ChangeIP does not recognise the CHANGEIP_RECORD parameter provided!" 2>&1 | tee -a /var/log/changeip.log
    else
        echo "There was an issue connecting to changeIP, wget returned $wgetRet!" 2>&1 | tee -a /var/log/changeip.log
    fi
    exit 1
fi

echo "Parameters successfully verified." 2>&1 | tee -a /var/log/changeip.log


# Setup the cron job.
echo "Add the cron configuration to run '/bin/update-script.sh' every $CHANGEIP_PERIOD minutes... " 2>&1 | tee -a /var/log/changeip.log
echo "*/$CHANGEIP_PERIOD * * * * /bin/update-script.sh" >> /etc/crontabs/root

# start cron
echo "Starting cron..." 2>&1 | tee -a /var/log/changeip.log
/usr/sbin/crond -f -l 8 -L /var/log/crontab.log


