# ChangeIP DDNS Service updater

A simple container for updating a record on the [ChangeIP](https://www.changeip.com/) DDNS service with your external IP address.
The script checks the current external IP against the current recorded IP against, if they have changed, updates the configured records on changeip.

## Getting Started

These instructions will cover usage information and for the docker container

### Prerequisities

In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

You will also need a [ChangeIP](https://www.changeip.com/accounts/dnsmanager.php) account with a registered domain.

### Usage

#### Container Parameters

List the different parameters available to your container

```shell
docker run --name changeip -d -e CHANGEIP_USERNAME=\<user name\> -e CHANGEIP_PASSWORD=\<password\> -e CHANGEIP_RECORD=\<record\> changeip:latest
```

To change the period between each time IP change check

```shell
docker run --name changeip -d -e CHANGEIP_USERNAME=\<user name\> -e CHANGEIP_PASSWORD=\<password\> -e CHANGEIP_RECORD=\<record\> -e CHANGEIP_PERIOD=20 changeip:latest
```

#### Environment Variables

| Environment variable | Default | Detail |
| --- | --- | --- |
| `CHANGEIP_USERNAME` | | Your ChangeIP username. This value is mandatory. |
| `CHANGEIP_PASSWORD` | | Your ChangeIP password. This value is mandatory. |
| `CHANGEIP_RECORD` | | Your ChangeIP Record name. This value is mandatory. |
| `CHANGEIP_PERIOD` | 15 | The number of minutes between each IP change check.  |
| `CHANGEIP_IPSET` | 1 | Ensure this matches the Set selected against the target hostname on your ChangeIP account.  |
| `CHANGEIP_LOGLEVEL` | 2 | The logging level for the update scripts. Can be 0 - no logging, 1 - normal or 2 - verbose. |
| `CHANGEIP_LOGMAX` |  500 | The maximum number of lines that can be record in the changeip.log log file. If set to 0 it will not trim the file. |  

#### Volumes

* `/var/logs/` - File location

The logging level folder can be mapped to an external volume. Cron and the update script log files are saved to /var/logs/ within the container.

## Find Us

* [GitHub](https://github.com/LawrenceBeran/changeip)
* [DockerHub](https://hub.docker.com/repository/docker/lawrenceberan/changeip)

## Author

* **Lawrence Beran** -  [ChangeIP](https://github.com/LawrenceBeran/changeip)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

* [ChangeIP](https://www.changeip.com/) for providing the original bash [rinker.sh](https://www.changeip.com/accounts/index.php?rp=/announcements/8/rinker.sh-wget-1.0-no-longer-supported.html) script which was the basis of my script.
