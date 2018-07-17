---
title: Code runner down
---

The [Twist Discussion](https://twistapp.com/a/27160/ch/60233/t/149012/c/9328008) has more context.

This issue was a pretty run-of-the-mill instance of
[backing code runner machine outage](https://docs.dataquest.io/devops/playbook/scenarios/no_code_running/#backing-student-code-runner-machine-being-down).

Issue was reported by an alarm and discovered by Dusty (oncall) in a twist thread while in a hangout with Berry and Curtis. Berry and Dusty debugged together. Dusty got very hungry as he hadn't had breakfast.

Dusty investigated the celery queue and database load while Berry found [metrics](https://app.datadoghq.com/metric/explorer?live=true&page=0&is_auto=false&from_ts=1520197591855&to_ts=1520283991855&tile_size=m&exp_metric=system.mem.pct_usable%2Csystem.cpu.idle&exp_scope=host%3Adataquest-runner-prod-s409&exp_group=host&exp_agg=avg&exp_row_type=metric) that indicated usable memory on one code running machine had gone to zero.

Dusty tried logging into the machine in question using:

```
dqssh.py prod -s autoscaler
docker-machine ssh dataquest-runner-prod-s409
```

The latter command failed.

Dusty killed `dataquest-runner-prod-s409` from the AWS UI and ran the [site tests](https://www.dataquest.io/test-site). Code running was recovered, running on the s410 machine.

Metrics on s410 started to tank. Dusty proactively ran `create_machine` as described in the playbook:

```
dqssh.py prod -s autoscaler
/opt/dsserver/bin/python manage.py shell_plus
from hosts.tasks import create_machine
create_machine()
```

Once s411 came up, memomery usage for s410 started to stabilize. Full recovery was announced.

Berry and Dusty investigated whether we should be running on different machine types. We determined that we should immediately upgrade to the faster/better/cheaper `c5.4xlarge` machines (from existing `c4.4xlarge`). We also evaluated whether it would be valuable to upgrade to a `c5.9xlarge` machine, which is twice as big as the two code runners we normally run right now for about twice the cause. Berry will look into this, but it seems like a good idea as it would be much easier to measure actual usage and alarm off / automatically recover from issues in the machine.
