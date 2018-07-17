---
title: No code running
---

In this case, the frontend and backend function, but code running doesn't.  This will manifest as the dashboard loading fine, but clicking "Run" in a code box timing out continuously.

This is usually caused by one of the following:

* Celery workers being down
* Celery queue being backed up
* Backing student code runner machine being down
* Student code runner machine being locked up or in a weird state
* Elasticache not working properly

## Celery workers being down

Check the kubernetes dashboard to make sure the mainstack-celery deployment exists in the prod namespace.  Check a couple of pods, and verify that they're logging messages as expected.

Make sure to check Datadog APM, and see what's happening with the timings around celery tasks.  Check sentry for any errors.

## Celery queue being backed up

You can check the celery queue length by:

* Using `kubectl get pods --namespace=prod` to list production pods.
* Sshing into a `mainstack-celery` pod with `kubectl exec -it --namespace=prod POD_NAME -- /bin/bash`.
* Running `redis-cli -n 0 -h dsserver-prod-004.tso1ep.0001.use1.cache.amazonaws.com -p 6379 llen celery`

Run the `llen celery` command a few times -- if the queue length is longer than 0 and keeps going up, then you're seeing this error case.

If the celery queue is backed up, you should:

* Verify what's happening:
    * Run `/opt/dsserver/bin/python manage.py shell_plus`
    * Run `from celery.task.control import inspect`
    * Run `i=inspect()`
    * Run `i.active()`
    * Make sure that this shows a lot of output, and every celery worker node you expect (each node is a pod in the `mainstack-celery` deployment) is listed.
    * Make sure each node has the number of configured workers tied up (`CELERY_CONCURRENCY` environment var)
* Clear the queue to temporarily restore normal operations:
    * Run `/opt/dsserver/bin/celery -A dsserver purge`
    * This will quickly get backed up again unless you resolve the underlying issue
* Try creating more celery workers:
    * Spin up more `mainstack-celery` pods by editing `apps/prod/mainstack/mainstack-celery.yaml` to increase the number of replicas on line `7`, and the minReplicas on line `92`.


The queue length will get backed up for one of a few reasons:

* Workers being blocked by an external resource, like the database or S3.
    * This happened when our RDS disk bandwidth was too low, so the disk queue depth kept growing.
    * This happened during the AWS outage when S3 reads/writes took a long time, and the save_project endpoint started blocking workers.
* Not having enough workers.
    * This happened when we were under heavy load last year.
* A DDOS or other type of attack (sometimes accidentaly)
    * This happened when the frontend kept spamming requests to the backend when a single user had multiple tabs open.

You can use Sentry and Datadog APM to drill down on what is actually blocking.  Once you've figured it out, you can take steps to mitigate the issue.


## Backing student code runner machine being down

You can check what's going on here by opening the AWS console, and seeing if any machines with names like `dataquest-runner-prod-s{NUM}`.  If there aren't any, you can create one:

* SSH into the `autoscaler` pod with `kubectl`.
* Run `/opt/dsserver/bin/python manage.py shell_plus`
* Run:

```python
from hosts.tasks import create_machine
earliest_created_host = Host.objects.filter(alive=True, active=True).order_by("created").first()
delta = timezone.now() - earliest_created_host.created
create_machine()
# It will take several minutes, be patient

# Store that we've spawned a replacement for this host.
earliest_created_host.replacement_spawned = True
earliest_created_host.save()
```

If this errors, try just running:

```python
create_machine()
```

It's possible that `create_machine` will sometimes fail because of docker version problems.  If this happens, you'll need to:

* Add a new docker install script to `utils/docker_install` that copies the latest Docker install script in the folder, but replaces the version numbers on lines `26` and `27` with the latest.
* Verify that nothing in the script is drastically off from the script at https://get.docker.com/.  The script should ideally be based off the script at https://get.docker.com/, but pin the docker version.
* Run `upload.sh` to upload the script.
* Modify the `Dockerfile` in [the autoscaler repo](https://gitlab.dataquest.io/dataquestio/autoscaler) to use the script you just created to install docker.
* Modify `deploy/apps/prod/autoscaler/runner-secrets.yaml` to change to the latest docker install script.
* Update the secrets file in k8s, and redeploy the newest version of the autoscaler service.

Now, try running `create_machine()` again in the shell.

## Student code runner in weird state

It's possible for the machine that runs student code to get into an odd state.  To verify, first use the AWS console to get the name of the running student code runner machine.  It will look like `dataquest-runner-prod-s{NUM}`.

Then:

    * SSH into the `autoscaler` pod.
    * Run `docker-machine ssh {MACHINE_NAME}`.
    * You're now sshed into the machine.  Try running `sudo docker ps`

If any of the above commands fail, the machine is probably in a weird state.  There could also be something wrong if the memory/cpu usage on the machine are extremely high.

You should following the instructions in `Backing student code runner machine being down` to run `create_machine()` to spin up a new runner machine.  After it comes up, use the AWS console to terminate the old machine.

## Student code runner connecting to wrong machine

Sometimes code running doesn't work because it can't find the right machine in the pool.
This will be manifested by `"containers.exceptions.ContainerSpinUpError: docker --host=172.31.56.71:2376 -...` type entries in Scalyr.

Confirm by getting the list of hosts from autoscaler:

    `curl -X POST -d 'token=<token>' http://prod-scale.dataquest.io/hosts/`

Where <token> is the TOKEN from the deploy repo's `prod/autoscaler/secrets/secrets.yaml`
file.

The values in the resulting issue should match what you see in AWS. If they don't,
you probably have different symptoms and need to do the Backing Machine stuff above.

If it is the correct value, log into the celery pod and get an ipython shell:

```
    dqssh.py prod -s celery
    /opt/dsserver/bin/python manage.py shell_plus
```

There are a few places to poke and you might have to dig into the code from
the traceback in Scalyr to get this far. First try running `get_hosts_list()`
to refresh the lists of hosts from autoscaler:

```
from container.tasks import get_hosts_list()
get_hosts_list()
```

Now make sure that `m = Machine.pool_machines()` returns a legitimate value and that
`m.host` references one of the valid machines returned by the curl command.

If that is failing, you'll need to walk through the code in `containers.tasks.check_for_images_on_host` to identify the problem. For one
outage, the problem was that the cache didn't contain values for the container
prefixes. This was an Elasticcache issue as discussed below, and was solved by
rerunning migrator.


## Elasticache not working properly

You should first verify this by checking the AWS console.  The console will tell you how much free memory is available on the elasticache instance.

If the memory available is low, your choices are:

* Deploy to production again.  This will clear some of the cache as part of `sync_local_sources`.
* Create a bigger cache instance, then switch over.  You'll have to change quite a few settings in `deploy/prod/mainstack/secrets` to point to the new instance.  You'll then have to deploy again.

## Incorrect versions in the cache

Sometimes, the cache that enumerates the correct container versions (see `containers.tasks.pull_docker_images_on_hosts`) can get set to `None`.

This can be verified by running this snippet in the shell:

```python
versions = {}
for image in settings.ALL_IMAGES:
    versions[image] = cache.get("{}_{}".format(settings.CONTAINER_IMAGE_CACHE_PREFIX, image))
```

If the versions are set to `None`, then a redeploy should fix this issue.  Also make sure to spawn a new runner machine, following the instructions above.
