#!/bin/sh


if ! [[ $CHANGEIP_IPSET =~ ^[12]$ ]] ; then
    echo "[ERROR] CHANGEIP_IPSET is not correctly set, it can only be '1' or '2'!" 2>&1 | tee -a /var/log/changeip.log
    exit 1
fi

if ! [[ $CHANGEIP_PERIOD =~ ^[0-9]+$ && $CHANGEIP_PERIOD -ge 1 ]] ; then
    echo "[ERROR] CHANGEIP_PERIOD is not correctly set, it must be a positive number!" 2>&1 | tee -a /var/log/changeip.log
    exit 1
fi

if ! [[ $CHANGEIP_LOGLEVEL =~ ^[012]+$ ]] ; then
    echo "[ERROR] CHANGEIP_LOGLEVEL is not correctly set, it can only be 0 (no logging), 1 (normal logging) or 2 (verbose logging)!" 2>&1 | tee -a /var/log/changeip.log
    exit 1
fi

if ! [[ $CHANGEIP_LOGMAX =~ ^[0-9]+$ ]] ; then
    echo "[ERROR] CHANGEIP_LOGMAX is not correctly set, it must be a positive number!" 2>&1 | tee -a /var/log/changeip.log
    exit 1
fi

if [[ -z $CHANGEIP_USERNAME ]] ; then
    echo "[ERROR] CHANGEIP_USERNAME must be provided!" 2>&1 | tee -a /var/log/changeip.log
    exit 1
fi

if [[ -z $CHANGEIP_PASSWORD ]] ; then
    echo "[ERROR] CHANGEIP_PASSWORD must be provided!" 2>&1 | tee -a /var/log/changeip.log
    exit 1
fi

if [[ -z $CHANGEIP_RECORD ]] ; then
    echo "[ERROR] CHANGEIP_RECORD must be provided!" 2>&1 | tee -a /var/log/changeip.log
    exit 1
fi

# Attempt to update ChangeIP to verify credentials and parameters are correct.
wget -4 -q -U "rinker.sh wget 1.0" -O /tmp/temp --http-user=$CHANGEIP_USERNAME --http-password=$CHANGEIP_PASSWORD "https://nic.changeip.com/nic/update?cmd=update&hostname=$CHANGEIP_RECORD"
wgetRet=$?
if [[ $wgetRet -ne 0 ]] ; then
    if [[ $wgetRet -eq 6 ]] ; then
        echo "[ERROR] Authentication error, check that the provided CHANGEIP_USERNAME and CHANGEIP_PASSWORD parameters are correct!" 2>&1 | tee -a /var/log/changeip.log
    elif [[ $wgetRet -eq 8 ]] ; then
        echo "[ERROR] ChangeIP does not recognise the CHANGEIP_RECORD parameter provided!" 2>&1 | tee -a /var/log/changeip.log
    else
        echo "[ERROR] There was an issue connecting to changeIP, wget returned $wgetRet!" 2>&1 | tee -a /var/log/changeip.log
    fi
    exit 1
fi

echo "[INFO] Parameters successfully verified." 2>&1 | tee -a /var/log/changeip.log


# Setup the cron job.
echo "[INFO] Add the cron configuration to run '/bin/update-script.sh' every $CHANGEIP_PERIOD minutes... " 2>&1 | tee -a /var/log/changeip.log
echo "*/$CHANGEIP_PERIOD * * * * /bin/update-script.sh" >> /etc/crontabs/root

# start cron
echo "[INFO] Starting cron..." 2>&1 | tee -a /var/log/changeip.log
/usr/sbin/crond -f -l 8 -L /var/log/crontab.log


