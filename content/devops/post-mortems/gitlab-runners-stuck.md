---
title: Gitlab runners stuck
---

The [Twist thread](https://twistapp.com/a/27160/ch/59880/t/233179) contains
a detailed log of the steps I followed to debug this. It included a couple
wild goose chases. On the one hand, these distract from the main issue,
but on the other hand, the various commands used might be useful for debugging
other potential problems.

This issue came up immediately after a deploy of a new version of gitlab and
its runners.

## Symptoms

 *  all the pipelines having a "stuck" status
 *  no gitlab-runner machines in AWS

## Root cause

The `apps/gitlab/gitlab/gitlab-runner.yaml` file had
been configured to use spot instances to reduce costs, but there were no spot
instances available to satisfy the requested constraints.

## Solution

Remove the spot instance configuration from the config and redeploy the runner.

## Transcripts

I don't have time to summarize the commands better, so copying the whole
transcript of the [Twist thread](https://twistapp.com/a/27160/ch/59880/t/233179)
in case it disappears or we migrate off twist.

Unfortunately I didn't capture a list of the commands I ran. I have them in my
zsh history, but most of them are just `dqssh.py gitlab -s runner`. The real
commands I ran were docker-machine commands inside that runner, which I don't
have a record of, other than in the twist thread below.

### Twist thread
Gitlab pipelines are all stuck
11 Followers




DP

Dusty Phillips
19h

I'm investigating. I did a security release on gitlab this morning, so I'm guessing something went wrong. sigh Will document my steps here to aid Berry in the process.

Berry, I've documented my entire debugging process step by step below, you should probably read through it and see if there's any useful info for the future. but the summary of the problem is as follows:

The gitlab-runner.yaml config in the deploy repo was set up to request spot instances, but the spot instances could not fulfill the constraints as defined. Rather than try to figure out what the constraints were supposed to be, I removed the spot instance configuration.
DP

Dusty Phillips
19h

There are no gitlab runners in AWS.
DP

Dusty Phillips
19h

WARNING: Stopping machine                           created=7m8.675819088s name=runner-e01d732e-gitlab-test-runner-1517847968-ad4d864c reason=machine is unavailable used=6m59.499562226s usedCount=1
Stopping "runner-e01d732e-gitlab-test-runner-1517847968-ad4d864c"...  name=runner-e01d732e-gitlab-test-runner-1517847968-ad4d864c operation=stop
ERROR: InvalidInstanceID.Malformed: Invalid id: "" (expecting "i-...")  name=runner-e01d732e-gitlab-test-runner-1517847968-ad4d864c operation=stop
ERROR:     status code: 400, request id: 6e7651f2-a247-4856-bda7-e2478618f9c3  name=runner-e01d732e-gitlab-test-runner-1517847968-ad4d864c operation=stop
WARNING: Error while stopping machine               created=7m9.267953554s error=exit status 1 name=runner-e01d732e-gitlab-test-runner-1517847968-ad4d864c reason=machine is unavailable used=7m0.091696706s usedCount=1
WARNING: Removing machine                           created=7m9.268016295s name=runner-e01d732e-gitlab-test-runner-1517847968-ad4d864c reason=machine is unavailable used=7m0.09175935s usedCount=1
About to remove runner-e01d732e-gitlab-test-runner-1517847968-ad4d864c  name=runner-e01d732e-gitlab-test-runner-1517847968-ad4d864c operation=remove
WARNING: This action will delete both local reference and remote instance.  name=runner-e01d732e-gitlab-test-runner-1517847968-ad4d864c operation=remove
ERROR: Error removing host "runner-e01d732e-gitlab-test-runner-1517847968-ad4d864c": unknown instance  name=runner-e01d732e-gitlab-test-runner-1517847968-ad4d864c operation=remove
ERROR: MissingParameter: The request must contain the parameter KeyName  name=runner-e01d732e-gitlab-test-runner-1517847968-ad4d864c operation=remove
ERROR:     status code: 400, request id: 421bedf8-d06c-4985-8dcb-0cc5b85f3ab8  name=runner-e01d732e-gitlab-test-runner-1517847968-ad4d864c operation=remove

DP

Dusty Phillips
19h

from dqlog.py gitlab -s run
VP

Vik Paruchuri
19h

Delete and redeploy gitlab-runner.yaml?
DP

Dusty Phillips
19h

mrm, I didn't consider deleting it first, trying now.
DP

Dusty Phillips
19h

same errors. I want to double check I got the right version of gitlab runner, I did bump it this morning but I was a bit distracted.
DP

Dusty Phillips
19h

looks right...
DP

Dusty Phillips
19h

logging into runner to see what docker-machine has to say. dqssh.py gitlab -s run
DP

Dusty Phillips
19h

root@gitlab-runner-7f44874b88-9szjv:/# docker-machine ls

Error attempting call to get driver name: connection is shut down

DP

Dusty Phillips
19h

docker-machine ls -t 20 gives somewhat more output
DP

Dusty Phillips
19h

Trying to remove a runner that was in the docker-machine ls -t 20 output:

root@gitlab-runner-7f44874b88-9szjv:/# docker-machine rm -f runner-e01d732e-gitlab-test-runner-1517853804-ced1f736
About to remove runner-e01d732e-gitlab-test-runner-1517853804-ced1f736
WARNING: This action will delete both local reference and remote instance.
Error removing host "runner-e01d732e-gitlab-test-runner-1517853804-ced1f736": unknown instance
MissingParameter: The request must contain the parameter KeyName
    status code: 400, request id: 4a250222-8eb6-408a-8bdb-9a5202650c11

Successfully removed runner-e01d732e-gitlab-test-runner-1517853804-ced1f736

DP

Dusty Phillips
19h

getting some "command terminated with exit code 137" when I run docker-machine
DP

Dusty Phillips
19h

which apparently means it got kill -9'd, possibly by aws.
DP

Dusty Phillips
19h

not that docker-machine got kill-9'd but that a subprocess it was running did.
DP

Dusty Phillips
19h

Seeing 4 restarts for the gitlab-runner pod in kubectl.
DP

Dusty Phillips
19h

Probably because my docker-machine commands are eating memory.
DP

Dusty Phillips
19h

Really hearing that call for a hosted solution right now.
DP

Dusty Phillips
19h

The gitlab-docker-machines volume must be out of whack.
DP

Dusty Phillips
18h

running docker-machine rm -f $(docker-machine ls -t 30 -q | head -n 10) repeatedly. Not sure if it's doing anything. The call to head is to prevent the command from dying... for some reason.
DP

Dusty Phillips
18h

Ok, after deleting all the machines, I am still seeing warnings and errors.
DP

Dusty Phillips
18h

I think it's trying to create new machines, but failing.
DP

Dusty Phillips
18h

ERROR: Error creating machine: Error in driver during machine creation: Error request spot instance: MaxSpotInstanceCountExceeded: Max spot instance count exceeded
DP

Dusty Phillips
18h

pretty sure that's a symptom, not a cause.
DP

Dusty Phillips
18h

This one is more likely to be a cause:
ERROR: open /root/.docker/machine/machines/runner-e01d732e-gitlab-test-runner-1517856544-b36cd9df/config.json: no such file or directory name=runner-e01d732e-gitlab-test-runner-1517856544-b36cd9df operation=provision
DP

Dusty Phillips
18h

BTW, I tried downgrading gitlab-runner and it was giving the same issues.
DP

Dusty Phillips
18h

price-too-low: Your Spot request price of 0.03 is lower than the minimum required Spot request fulfillment price of 0.113.
DP

Dusty Phillips
18h

That's from AWS.
DP

Dusty Phillips
18h

runner-e01d732e-gitlab-test-runner-1517856544-b36cd9df            not found   Error                          open /root/.docker/machine/machines/runner-e01d732e-gitlab-test-runner-1517856544-b36cd9df/config.json: no such file or directory

DP

Dusty Phillips
18h

That's current output of docker-machine ls The driver not being found seems relevant.
DP

Dusty Phillips
18h

but not sure if that's a cause or effect of the config.json being missing
DP

Dusty Phillips
18h

it really is missing.
DP

Dusty Phillips
18h

"engine-install-url=https://s3.amazonaws.com/dq-install/install_docker_1703.sh",
DP

Dusty Phillips
18h

I wonder if that's out of date now.
DP

Dusty Phillips
18h

rm ~/.docker/machine/machines/* -r kicked the logs to try something new.
DP

Dusty Phillips
18h

WARNING: Failed to update executor docker+machine for e01d732e No free machines that can process builds
Executing /usr/bin/docker-machine [docker-machine create --driver amazonec2 --amazonec2-access-key=AKIAJDZ7SIJTH7UL26OQ --amazonec2-secret-key=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 --amazonec2-vpc-id=vpc-b00d33d5 --amazonec2-region=us-east-1 --amazonec2-zone=a --amazonec2-instance-type=t2.xlarge --amazonec2-request-spot-instance=true --amazonec2-spot-price=0.14 --amazonec2-block-duration-minutes=180 --amazonec2-root-size=100 --amazonec2-security-group=gitlab-runners --amazonec2-subnet-id=subnet-62099d49 --engine-install-url=https://s3.amazonaws.com/dq-install/install_docker_1703.sh --engine-storage-driver=overlay2 --amazonec2-use-private-address runner-e01d732e-gitlab-test-runner-1517858434-b9f88468]
Running pre-create checks...                        driver=amazonec2 name=runner-e01d732e-gitlab-test-runner-1517858434-b9f88468 operation=create
Creating machine...                                 driver=amazonec2 name=runner-e01d732e-gitlab-test-runner-1517858434-b9f88468 operation=create
(runner-e01d732e-gitlab-test-runner-1517858434-b9f88468) Launching instance...  driver=amazonec2 name=runner-e01d732e-gitlab-test-runner-1517858434-b9f88468 operation=create
(runner-e01d732e-gitlab-test-runner-1517858434-b9f88468) Waiting for spot instance...  driver=amazonec2 name=runner-e01d732e-gitlab-test-runner-1517858434-b9f88468 operation=create
Feeding runners to channel                          builds=0
Docker Machine Details                              creating=1 idle=0 maxMachines=0 minIdleCount=1 removing=0 runner=e01d732e time=2018-02-05 19:20:37.922099443 +0000 UTC total=1 used=0
WARNING: Failed to update executor docker+machine for e01d732e No free machines that can process builds

DP

Dusty Phillips
18h

EC2 says capacity-not-available: There is no Spot capacity available that matches your request.
DP

Dusty Phillips
18h

If I try to create a spot request for a t2.xlarge using the web interface, it works, so it's not that they're somehow out of machines.
DP

Dusty Phillips
18h

Wow, I just realized that gitlab is putting the secret and access key in a log. 😮
DP

Dusty Phillips
18h

Fixed. Solution was to remove these lines from the MachineOptions:

            "amazonec2-request-spot-instance=true",
            "amazonec2-spot-price=0.03",
            "amazonec2-block-duration-minutes=180",

Something about our requested config was unable to satisfy spot instance requests.
VP

Vik Paruchuri
17h

Interesting, those lines must be recent additions
