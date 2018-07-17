---
title: Installing Dataquest stack locally
---

This provides step-by-step instructions for installing dataquest locally. It's a complex
system, the install doesn't work on Windows due to weak docker support. These have been
most tested to work on Fedora, but have also been used successfully on ubuntu and macos.

Please update instructions if you find any new issues.

## Set up Git Caching credentials

 *  https://help.github.com/articles/caching-your-github-password-in-git/
 *  Follow instructions for your OS

## Clone Dataquest

We have many git repositories for dataquest, but you only need two to run the service locally. The `mainstack` repository contains the service code to run the web frontend, API backend, and containers. The `dscontent` repository contains the textual content for all of our missions. Run these commands:

```bash
mkdir dataquest
cd dataquest
git clone https://gitlab.dataquest.io/dataquestio/mainstack.git
git clone https://gitlab.dataquest.io/dataquestio/dscontent.git
```

## Set up dependencies

Dataquest is a complex system and requires quite a few dependent libraries to run locally. If you don't need to actively develop the codebase, you should probably use `docker-compose` instead.

### Docker

You'll need docker installed running. Note that the versions shipped with your distribution may not be up-to-date enough. Follow the instructions for your OS here: https://www.docker.com/community-edition.

Under Fedora, you need to add your user to the docker group: `sudo gpasswd -a $USER docker`. Then you need to log out and back in again.

### Python

Our backend services are all written in Python. You are welcome to use whichever Python installation method you prefer, including Anaconda, System Python, or Virtualenv. Pyenv is  nice to work with, once you get it installed. You'll need python version 3.4 or higher. You can follow these instructions if you choose to use pyenv:

 *  Install dependencies: https://github.com/pyenv/pyenv/wiki/Common-build-problems
 *  Install pyenv: https://github.com/pyenv/pyenv#installation
 *  Install pyenv-virtualenv: https://github.com/pyenv/pyenv-virtualenv#installation
 *  `pyenv install 3.6.1`
 *  `pyenv global 3.6.1` # optional
 *  `pyenv virtualenv 3.6.1 dq`  # Environment for just dataquest
 *  `pyenv activate dq`  # Run this in your terminal each time you are working with dataquest code
 *  You would be wise to add $(pyenv version-name) to your zsh or bash prompt as desired.

### Miscellaneous dependencies

We've collected most of the Dataquest backend dependencies into files in the `mainstack/server/requirements.txt`. Note that these files can get out of date, so you may have to add packages to the list. You'll probably find out which ones in the next step.

Install the correct file for your OS:

 *  `cd mainstack/server/requirements`
 *  MacOS: `cat brew-packages.txt | xargs brew install`
 *  Ubuntu: `apt-get install $(cat apt-packages.txt)`
 *  Fedora: `dnf install $(cat dnf-packages.txt)`

### Python dependencies

Dataquest's backend is largely built in Python, and it depends on a ton of supporting libraries. If you are using pyenv, conda, or virtualenv, make sure the environment has been appropriately activated before installing:

 *  `pip install -r requirements.txt`

## Set up services

Most of our dependencies are libraries, but you'll need to make sure a few services are running as well.

### Redis

 *  If you don't want to use system redis, you can just run `redis-server`. If you are running a standard redis instance, you may want to run it on a port other than the default as `redis-server --port 6380` If you do this, you'll also need to add a new file at `mainstack/server/dsserver/private.py` with these contents:
    ```
    CACHES = {
        'default': {
            'BACKEND': 'redis_cache.RedisCache',
            "LOCATION": "redis://127.0.0.1:6380/2"
        }
    }
    ```
 *  If you prefer to run system redis, just enable the service in the normal manner for your OS (feel free to update these instructions for each OS :-p).
     *  For macos
        - Load redis at startup: `sudo ln -sfv /usr/local/opt/redis/*.plist /Library/LaunchAgents`

        - Load redis now (mandatory): `launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist`

### Postgresql

We back our Django API with the Postgresql database. It should have been installed when you installed the dependencies, but you may need to do extra work to configure and turn it on. This is OS dependent. Update these links with configuration instructions:

 *  https://fedoraproject.org/wiki/PostgreSQL  for *Fedora*
 *  ?? for *Macos*
 *  ?? for *Ubuntu*

On Linux you may need to edit `/var/lib/pgsql/data/pg_hba.conf` (/etc/postgresql/9.6/main/pg_hba.conf for Ubuntu) and add `local all dsserver trust` before any other lines.

Follow these steps to create a database:

 *  (On linux) `sudo su - postgres`
 *  `psql -d postgres -U postgres` which will elevate you to the postgresql shell
     *  `create user dsserver;`
     *  `create database dsserver owner dsserver;`
     *  `grant all privileges on database dsserver to dsserver;`
     *  Press `Ctrl+D` to quit and return to your normal shell

### Frontend dependencies

* Follow instructions for [node LTS](https://nodejs.org/en/download/)
* Follow instructions for [yarn](https://yarnpkg.com/en/docs/install)

## Docker images

Dataquest runs student code in one of three docker containers. For normal development, you can pull these containers from docker hub, which is far faster than building them. If you are developing code that runs inside the containers, you will have to build them on your machine.

If you don't have docker hub credentials:

 *  Create an account at `https://hub.docker.com/`
 *  Ping someone with permissions (Vik) to get access to the Dataquest repositories
 *  Once you have permissions, run `docker login` on your machine to login to Docker.

Pull the containers using:

```bash
docker login
docker pull dataquestio/v2-base-runner
docker pull dataquestio/v2-postgresql-runner
docker pull dataquestio/v2-pyspark-runner
```

Alternatively, if you need to build the containers:

 *  `cd mainstack/server/`
 *  `sh build_v2.sh`

You can build individual containers by running similar scripts in the `mainstack/server/containers/runners` directory.

## Set up database

The database schema is set up using a series of migrations, so we can evolve the schema safely over time. You'll need to do this any time you update your codebase (e.g: with `git pull`)

 *  Make sure your python environment is activated
 *  `cd mainstack/server`
 *  `python manage.py migrate`

If you get an error message `ValueError: unknown locale: UTF-8` on macOS, you may need to configure your locale in your shell's config. E.g. for Bash and ZSH:

```bash
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
```

## Set up server `private.py`

You'll need some custom settings in `server/dsserver/private.py` to access stripe, braintree, and content manager. We obviously don't want to publish these keys in a wiki, so you'll have to ask a senior dev to set them up for you:

```python
STRIPE_PUBLISHABLE_KEY = ''
STRIPE_SECRET_KEY = ''
CONTENT_MANAGER_CLIENT_ID = ''
CONTENT_MANAGER_CLIENT_SECRET = ''
BRAINTREE_MERCHANT_ID = ''
BRAINTREE_PUBLIC_KEY = ''
BRAINTREE_PRIVATE_KEY = ''
```

The Stripe and braintree keys don't block your ability to develop locally. The content manager ones don't block you at time of writing, but they will in the future, and this documentation will likely be stale. ;-)

## Set up content

While the dataquest codebase is large and complicated, it is our content that makes us run. In order to run the web application, you will need to initialize the database and sync the content from the dscontent repo you cloned earlier.

There are two ways to build the content. The faster way is to pull the content image from docker hub. However, if you are making changes that require up-to-date content, you'll need to sync them from scratch locally. Either way, the sync process essentially sets up the database so that it knows what content is available and what state it should be in.

To get the data from a docker image, make sure you have the correct python environment enabled and then use this script:

```bash
cd mainstack/server
python manage.py add_local_source ../../dscontent --main
docker pull dataquestio/dscontent  # to pull down the latest dscontent Docker container
docker create --name content dataquestio/dscontent  # create a container to enable `docker cp`
mkdir -p media/sync  # the default location for reading dump files
docker cp content:/opt/wwc/mission_data/. media/sync  #copy dump files to dump folder
docker rm content  # remove content container
python manage.py sync_local_sources --read-from-file  # sync files!
rm -rf media/sync # (optional) remove the dump folder to save space
```

If you need to build from scratch use:

```bash
python manage.py add_local_source ../../dscontent --main
python manage.py sync_local_sources
```

## Set up Frontend


## Running the service
### Running the backend

Several services need to be running in order for the API to run. Daphne is used to serve the API requests. Celery workers are needed to run asynchronous tasks, and the channel worker tasks need to be scheduled. Run each of these in separate terminal windows or tmux sessions (If you use tmux, the `deploy/scripts/run_dq_backend.sh` script will open them all for you):

 * dsserver: `daphne dsserver.asgi:channel_layer --bind=127.0.0.1 --port=7000`
 * celery1: `celery worker -A dsserver  -n worker1@%h;`
 * celery2: `celery worker -A dsserver  -n worker2@%h;`
 * channels: `python3 manage.py runworker`

### Running the Frontend

The frontend is a separate service. You'll need to run yarn once to install the dependencies (and each time you update).

```bash
cd ../frontend
yarn
npm run dev
```


## Updating

After you git pull, updating the frontend code is just a matter of running `yarn` and carrying on. For the backend you'll need to repeat these steps:

```bash
pip install -r mainstack/server/requirements/requirements.txt
python manage.py migrate
```
 
Now follow the instructions above to build or pull the runner containers.
