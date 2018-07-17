---
title: Create an HTTPS service in Hyper.sh
---

Hyper.sh requires a full chain SSL certificate. Our certificates, which are
provided by CloudFlare, do not fit this bill so we need to use LetsEncrypt
to create this certificate. The catch is that the chosen domain needs to
point to the correct IP address when creating the certificate, so we need
to jump through a few hoops to get the certificate.

## Instructions

### Prerequisites

First, make sure you're logged into Hyper and Docker. If you're already
logged in, you can skip this step.

```bash
export HYPER_ACCESS_KEY="<hyper.sh access key>"
export HYPER_SECRET_KEY="<hyper.sh secret key>"
export DOCKER_USER="<docker username>"
export DOCKER_PASS="<docker password>"
export DOCKER_EMAIL="<docker user email address>"
export HYPER_REGION="<hyper region>"  # default to us-west-1

hyper config --accesskey $HYPER_ACCESS_KEY --secretkey $HYPER_SECRET_KEY --default-region $HYPER_REGION
hyper login -u $DOCKER_USER -p $DOCKER_PASS -e $DOCKER_EMAIL
```

### Steps

Open two tabs in your terminal.

* **Terminal tab 1**: Set your service variables.

```bash
export HYPER_APP="<app-name>"
export HYPER_IMAGE="<image[:tag]>"
export HYPER_REPLICAS="<replicas>"  # default to 1
export HYPER_SERVICE_PORT="<service port>"  # default to 443
export HYPER_CONTAINER_PORT="<container port>"
export HYPER_ENV_FILE="<path to env vars file>"  # such as secrets/prod.env
```
* **Terminal tab 2**: Create a FIP and run a Python 3 container.

```bash
hyper run --rm --name certbot -p 80:80 -it python:3 bash
```

* **Terminal tab 1**: Create and attach a FIP to the container.

```bash
HYPER_CID=$(hyper ps -aqf "name=certbot")
HYPER_FIP=$(hyper fip allocate -y 1)
hyper fip attach $HYPER_FIP $HYPER_CID
echo $HYPER_CID  # output is the IP address to use in CloudFlare
```

* Create the subdomain for you app in CloudFlare and set it to the IP from the previous command.

* **Terminal tab 2**:

```bash
export $SUBDOMAIN="<app subdomain>"
pip install certbot
certbot certonly --standalone -d $SUBDOMAIN.dataquest.io -m "devops@dataquest.io" --agree-tos -n
cp /etc/letsencrypt/live/$SUBDOMAIN.dataquest.io/* /
cat fullchain.pem privkey.pem > https-service.pem
```

* **Terminal tab 1**: Get the certificates. Hyper.sh doesn't support the docker copy command, so we need to cat the contents.

```bash
hyper exec $HYPER_CID cat /fullchain.pem > secrets/fullchain.pem
hyper exec $HYPER_CID cat /priv-key.pem > secrets/priv-key.pem
hyper exec $HYPER_CID cat /https-service.pem > secrets/http-service.pem
ls -l secrets  # verify the files are there and the sizes look good.
```

* **Terminal tab 2**: Exit the container and the tab. This must be done before the next step to make the FIP available again.

```bash
exit  # exit the container
exit  # Close the tab
```

* **Terminal tab 1**: Create the service

```bash
hyper service create \
	--service-port=$HYPER_SERVICE_PORT \
	--container-port=$HYPER_CONTAINER_PORT \
	--label=app=$HYPER_APP \
	--name=$HYPER_APP \
	--replicas=$HYPER_REPLICAS \
	--ssl-cert=secrets/http-service.pem \
	--protocol=httpsTerm \
    --env-file=$HYPER_ENV_FILE \
	$HYPER_IMAGE
hyper service attach-fip --fip=$HYPER_FIP $HYPER_APP
```