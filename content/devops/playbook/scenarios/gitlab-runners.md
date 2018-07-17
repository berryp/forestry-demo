# Gitlab runners stuck or not responding

Quick and dirty resolution is to kill the runners. You'll need to SSH into the Gitlab machine to delete references to the runners, this will force creating on new ones.

Get the list of machines for cleanup

```shell
MACHINES=$(gcloud compute instances list --format json | jq '.[]."name" | select(contains("gitlab-test-runner"))' | tr '"' '' | tr '\r\n' ' ')
```

Delete the instance references from the Gitlab machine

```shell
gcloud compute ssh gitlab
sudo -s
rm -rf /root/.docker/machine/machines/*
exit
```

Delete the instances

```shell
gcloud compute instances delete $MACHINES
```
