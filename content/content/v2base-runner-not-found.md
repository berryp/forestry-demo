---
title: v2base-runner not found
---

This is a common issue when first getting docker-compose setup on a mac.  You will run into an error that contains something similar to the following (generally it will be buried in a much longer stacktrace):

```
[36mweb_1         |[0m CMD:
[36mweb_1         |[0m `docker run --detach=true --name=dsserver-script-8609b335-810f-4e9a-a29b-5b3673cf9d12-2163d62d-df28-446f-a8ac-8f7717eeba0d -P --workdir=/dataquest/user/ --env DQ_CONFIG={"inside_dq": true} --cap-drop=setuid --cap-drop=setgid --cpu-period=100000 --cpu-quota=100000 --memory=2g --memory-swap=4g --net=bridge --user=dq dataquestio/v2-base-runner:latest /dataquest/system/env/python3/bin/python /dataquest/system/scripts/idle.py`
[36mweb_1         |[0m 
[36mweb_1         |[0m EXIT:
[36mweb_1         |[0m `125`
[36mweb_1         |[0m 
[36mweb_1         |[0m STDERR:
[36mweb_1         |[0m `Unable to find image 'dataquestio/v2-base-runner:latest' locally
[36mweb_1         |[0m docker: Error response from daemon: repository dataquestio/v2-base-runner not found: does not exist or no pull access.
```

The reason for this error is that the credentials stored inside the docker containers are copied from your local machine, which is stored in a special store called `osxkeychain`.  Because the docker container isn't running linux, it doesn't have this mac-only keychain and so can't pull down the required images.

## To fix!

- Run `./dscontent shell` to open a shell session in the dsdocker container.
- Edit `~/.docker/config.json` and delete the line that conatins `osxkeychain`
- Run `docker logout`
- Run `docker login` and enter your dockerhub credentials
- (Optional) run `docker pull dataquestio/v2-base-runner`.  This will manually pull down the latest image for the container.  If you don't do this, the next time you sync it should pull down automatically anyway, but this lets you be explicit and know that it worked.