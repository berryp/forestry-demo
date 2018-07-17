---
title: Progress Migration
---

This is all going to change with the rollout of content manager, but it's useful to know the current state of affairs to help aid that understanding.

Originally written in response to the outage in https://twistapp.com/a/27160/inbox/t/305047

At a high level, we record the completion state for each screen and user in the ScreenProgress model, which indexes off the Screen model. The problem is that when a mission gets updated (new or removed screens), we create all new Screen objects and the ScreenProgress foreign key points to the wrong screen. There is a bulky migration step that fills in the ScreenProgress for missions that were previously completed.

This all happens in missions/sync/progress.py as part of the sync_local_sources process.

The problem is that for well-used missions, sync can take hours. For each mission, we process the users in reverse order of the last time they completed code on that screen, so in theory their progress will be updated sooner and they are less likely to notice it. In practice, there are two problems.

We only migrate progress for three missions at a time in parallel. Therefore, while mission 1 is syncing, smaller missions that also need migration are blocked even though there are users actively using them who are missing progress.

It is pretty easy to kick off migration of more missions from shell_plus. Be judicious in this because it is possible to bring the db down with so many reads and writes. Here's how you do it:

```
from missions.sync.progress import migrate_mission_progress
mission = Mission.objects.get(sequence=84)
migrate_mission_progress(mission)
```

The other problem is that we cache the user's progress so even after migration has completed, they may see invalid progress. This happens in `util.users.UserProgressCalculator`. You can force progress using `UserProgressCalculator(user).get_progress(mission, force=True)` for a single user. But you probably need to do it for all users, using:

```
from missions.progress import _user_ids_with_some_progress_in_mission as some_progress

mid = 82
m = Mission.objects.get(id=mid)
us = some_progress(m)
count = 0
print(len(us))
for u in us:
    UserProgressCalculator(User.objects.get(id=u)).get_mission_progress(m, True)
    count += 1
    if count % 100:
        print('.', end='', flush=True)
```

This doesn't solve everything because we cache progress at other levels too. Users were complaining about course progress, which can be fixed similarly with `UserProgressCalculator(user).get_progress(course, force=True)`.
