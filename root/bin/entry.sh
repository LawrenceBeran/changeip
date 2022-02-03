#!/bin/sh

# Setup the cron job.
echo "Add the cron configuration to run '/bin/update-script.sh' every $CHANGEIP_PERIOD minutes... " 2>&1 | tee /var/log/changeip.log
echo "*/$CHANGEIP_PERIOD * * * * /bin/update-script.sh" >> /etc/crontabs/root

# start cron
echo "Starting cron..." 2>&1 | tee /var/log/changeip.log
/usr/sbin/crond -f -l 8 -L /var/log/crontab.log
