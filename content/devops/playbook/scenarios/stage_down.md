---
title: Stage Code Running Down
---

Typically when stage isn't working, it's one of the same problems for prod (the two environments are very similar). See these files for debugging:

 *  [backend down](../backend_down/)
 *  [no code running](../no_code_running/)

Recently it's been getting into a horrible state with no code running and I've followed these steps to brute-force fixing it, basically bringing stage down altogether and then back up again. **Don't try this on prod, I don't think it would ever come back up under load**:

 * In apps/stage/mainstack run `kubectl delete -f mainstack-celery.yaml,mainstack-frontend.yaml,mainstack-migrator.yaml,mainstack-web.yaml`
 * In apps/stage/autoscaler run `kubectl delete -f autoscaler.yaml`
 * Delete all stage code runners in AWS EC2 dashboard
 * Run populatestage once to refresh to a snapshot of the prod db:
    *  In `apps/devops/populate_stage` run `kubectl apply -f populate_stage.yaml`
    *  `scripts/dqssh.py devops -s popu` to log into the populate_stage container
    *  `cd populate_stage`
    *  `/opt/populate_stage/bin/python main.py run_now`
    *  Wait for it to complete, then exit the container
    *  `kubectl delete -f populate_stage.yaml` to stop it running nightly
 *  In `apps/stage/autoscaler`` run `kubectl apply -f autoscaler.yaml` to bring up autoscaler
 *  Wait for a stage runner machine to show up in aws instances and pass status check (takes 10 minutes or so)
 *  In `apps/stage/mainstack` run `kubectl apply -f mainstack-migrator.yaml` to start migrator
    *  `kubectl get pods -n stage` to see if migrator starts correctly (takes a few minutes to become ready)
    *  `scripts/dqlog.py stage -s mig` to make sure it's running correctly
 *  `kubectl apply -f .` to start web, frontend, and celery
 *  Wait a bit and hope it works.

I haven't had time to look into which of these steps fixed it.

**Note**:

I've noticed that sometimes the populate_stage command will fail with an error that the
database is shutting down, and keeps happening. I found that deleteing the database manually
in RDS interface before running the script fixes this.
