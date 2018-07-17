---
title: Launching a course rewrite
---

When we rewrite/replace a course, there are a two extra steps for launch that we need to be mindful of:

- Redirecting the URLS of the replaced course/missions
- Letting users know about the course replacement, and how progress is handled.

## URL Redirects

We want to put a 301 redirect for all the course and mission pages.  This is important for:

- Search engines, so they transfer SEO juice to the new course and remove the old course/mission from their index.
- Any links on the web, so if people follow it they find the up to date course.
- Users who have bookmarked URLS.

At the same time, we want to make the old course/mission pages accessible for students who have done them before and want to get back to them to revise, download their projects etc.

We handle this by creating a redirect that only works if the URL does not have an `archive` parameter.  This means we can give students the url `/course/course_name?archive=true` which will allow them to access the course URL.  From there, internal navigation from the course page to missions will work normally (as this doesn't trigger an HTTP request for the page, which is where the redirects live.

### Creating the redirects

The redirects are created in the file [`/frontend/nginix_routes` in the mainstack repo](https://gitlab.dataquest.io/dataquestio/mainstack/blob/58be7121c8ebae1f4652c745b123148adba1f750/frontend/nginx-routes#L122) (note, this link goes to an old commit so the line reference remains accurate).

To create a redirect, you should use the following syntax:

```
# for courses
rewrite /course/[old_course_slug] /course/[new_course_slug] permanent;

# for missions, where [n] is the mission number
rewrite ^/m/[n].* /course/[new_course_slug] permanent;
```

**NOTE:** We redirect the old missions to the new _course_.

Once you have a merge request for the redirects, you should deploy it to a stage environment and give it a thorough test.  Test things like urls with a trailing slash, and URLS that are a mission/step as well us just the bare mission.

**IMPORTANT:** We should make sure that the mission redirects are merged in coordination with the course itself, so they are deployed together.

## Letting users know about the new course and progress

Unless we re-use mission numbers (which we have decided not to do), progress will not be transferred from the old course to the new course.  We can handle marking the missions complete pretty easily on the customer service side [using django admin](https://trello.com/c/7EDlFh9t/52-django-admin-panel).

We send an in-app message using intercom as close as to when the course launches as possible letting people know.  The message should me a manual message (send once), rather than an auto message (which keeps on sending on particular criteria).  The user will see the message next time they log in.

The criteria for the message should be:

- Anyone who has had the `premium-user-subscription` event at least once, AND
- Anyone who has the `teams-group-join-success` event at least once, AND
- First seen before the date the course was deployed

This means that anyone who could have potentially done the course will get the message.  If the course is totally free, we should include only the date critieria.

The message should:

- 'Sell' the new course, explain why it's better
- Reassure users that there's no concepts covered in the old course that aren't covered in the new course (presuming that's the case, which it almost always will be).
- Let them know that if they haven't done the old course, they don't need to worry and they can just continue learning as they were
- Let them know that if they have done the old course, they can either do the new course (It's better, teaches more etc!) or get credit for their progress - they should reply to do this.
- Give them the URL to access the old course should they wish, but let them know the courses will be removed in a few months (we don't do this, but gives us wiggle room if we do in the future)

Getting that all in one message can be a bit tough and the tone right etc, here's an example: https://app.intercom.io/a/apps/mf5oz4we/engage/messages/manual/166867053