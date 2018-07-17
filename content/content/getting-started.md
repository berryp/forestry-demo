---
title: Getting started
---


The `./dscontent` shell script is designed to make working with content locally easier by providing a layer of abstraction and shortcuts to the most common commands.

## Setup

```
./dscontent setup
```

This will run the entire setup and prepare you for local development.  For more detail on this, see [installation](../installation).

## Starting and stopping the local development environment.

```
./dscontent up
```

Note that this command will start a full content sync which usually takes 45-60 minutes, after which the backend will start and you will be able to login.  You can monitor this using the `logs` command (below).

```
./dscontent down
```

This will stop all your locally running services.

## Show logs

```
./dscontent logs
```

This shows the end of the logs for each running docker-compose container.  This is useful for monitoring what's happening (particularly during the initial sync).  The `-f` flag follows the log output.

## Updating the containers

```
./dscontent update
```

This pulls the new version of each image and then restarts the containers.  You can also update the images while the system is not up by running `docker-compose pull`.

## Stopping and Debugging
* When you're ready to stop everything run `./dscontent stop`
* If you run into weird errors, try stopping everything and restarting.
    * Run `./dscontent restart`
    * If tht doesn't work run `./dscontent down` and then `./dscontent up`
* Also try restarting Docker itself, or factory resetting it.  If that doesn't work, see this -- https://github.com/docker/for-mac/issues/1133.

## Syncing your changes

* To see your local changes on the development server:
    * To sync all missions run `./dscontent sync`
    * For a specific mission run `./dscontent sync <mission number>`

## Testing

* Test without syncing:
    * Run `./dscontent test` to test all the missions
    * Run `./dscontent test <mission number>` to test that mission
* Test with syncing:
    * Run `./dscontent test --sync` to sync and test all the missions
    * Run `./dscontent test <mission number> --sync` to sync and test that
      specific mission

## Running django management commands

```
./dscontent manage <insert command here>
```

This is the equivalent of running `./manage.py <insert command here>` in the web container.  For instance, `./dscontent manage add_premium josh@dataquest.io 365` will had 365 days of premium access to the account josh@dataquest.io

## Launching a shell in the running containers

```
./dscontent shell
```

This can be useful for advanced troubleshooting, and will launch a bash shell inside the web container.

## Help

For more on these commands and precise syntax, you can access help:

```
./dscontent help
```