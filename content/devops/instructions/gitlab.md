---
title: Gitlab
---

We have two instances of gitlab, both hosted by Kubernetes in AWS. One is for
our internal development and is generally named "gitlab". The other is for our
student community to build projects in, and is generally named "community".

## Doing a point release

The gitlab deploy script `scripts/gitlab_deploy.py` can do a deploy. To use it:

Look up the latest hashes on Docker Hub:

 *  https://hub.docker.com/r/gitlab/gitlab-ee/tags/
 *  https://hub.docker.com/r/gitlab/gitlab-ce/tags/
 *  https://hub.docker.com/r/gitlab/gitlab-runner/tags/ (use the ubuntu tag)

And edit the `image` line in the relevant files in our repo with the new
tag:

 *  `../apps/gitlab/gitlab/gitlab.yaml`
 *  `../apps/gitlab/community/community.yaml`
 *  `../apps/gitlab/gitlab/gitlab-runner.yaml`

Then run this script, passing either `gitlab` or `community` as the
environment parameter:

`./gitlab_deploy.py gitlab`
`./gitlab_deploy.py community`

Then check https://gitlab.dataquest.io/help to make sure it's up and the
hash is updated.

The gitlab deploy script has recently been flaky and needs some improvement. If gitlab goes down after a deploy, see [gitlab is down](../../playbook/scenarios/gitlab_down). There is also debugging information there for other gitlab slowness or outages.
