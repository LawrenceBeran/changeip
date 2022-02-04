# ChangeIP DDNS Service updater

A simple container for updating a record on the [ChangeIP](https://www.changeip.com/) DDNS service with your external IP address.
The script checks the current external IP against the current recorded IP against, if they have changed, updates the configured records on changeip.

Used the bash script written by Tom Rinker (3/18/09) modified to work in an Alpine Docker container.

Default timezone is Europe/London.

Requires three environment variables:
| Environment variable | Detail |
| --- | --- |
| CHANGEIP_USERNAME | Your ChangeIP username |
| CHANGEIP_PASSWORD | Your ChangeIP password |
| CHANGEIP_RECORD | Your ChangeIP record |
| CHANGEIP_PERIOD | The number of minutes between each IP change check. <br>Defaults to 15 minutes if variable not defined. |
| CHANGEIP_IPSET | Ensure this matches the Set selected against the target hostname on your ChangeIP account. <br> Defaults to 1 if not defined. |
| CHANGEIP_LOGLEVEL | The logging level for the update scripts. Can be 0 - no logging, 1 - normal or 2 - verbose. <br>Defaults to 2. |
| CHANGEIP_LOGMAX | The maximum number of lines that can be record in the changeip.log log file. If set to 0 it will not trim the file. <br>Defaults to 500. |

The logging level folder can be mapped to an external volume. Cron and the update script log files are saved to /var/logs/ within the container.

Example:

> docker pull lawrenceberan/changeip  
> docker run --name changeip -d -e CHANGEIP_USERNAME=\<user name\> -e CHANGEIP_PASSWORD=\<password\> -e CHANGEIP_RECORD=\<record\> changeip
