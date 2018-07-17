---
title: Course testing
---

Before we launch a course, we give students access to that course, and solicit their feedback.  This is designed to improve course quality, as well as catch issues/bugs before launch.

## Recruiting Testers

When thinking about testing your course, be mindful of where students will be at in the learning path when they do your course.  It's useful to get some students who will be at around that point in their learning, as they will be seeing the concepts you teach for the first time.  It's useful also to have some more experienced students as they will move through the content faster and are more likely to test the later missions (not all testers will make it through).

We have a private channel in our [members slack](https://dataquest-learn.slack.com), `#content-testing` with a number of users who have opted in for course testing.  If you don't the response you need (either in terms of numbers of the type of experience you need from testers, you may find that you need to recruit more testers into this channel, or directly into your test.

- In the `#content-testing` channel, post to recruit testers. Make it one single post (shift -enter for line breaks), so that they get all info in the email notification.  Your post should:
  - Use `@channel` to get everyone's attention
  - Provide the course name and an overview if necessary
  - Provide any requirements for prospective testers (ie must have done prior course x and y)
  - Provide expectations around effort required and timeline - we would require you to complete all or most of the course by date x
- Add users who opt-in to the channel you created for testing that course.  We won't put a limit on the number of testers.

## Deploying your course to stage

![Screenshot_2017-12-27_11.28.30](../images/Screenshot_2017-12-27_11.28.30.png)

- Create a new branch from your course branch
- Change the metadata for each mission in your course to make it free, commit those changes, and push the branch to Gitlab. 
- In GitLab, click 'Create Merge Request'
- Add `[content-testing]` to the merge request name so there is no confusion between this merge request and the main merge request
- Change the target branch to `content-testing`
- Ask someone else to approve/merge your branch into the testing branch.
- Once the MR is merged and the merge commit is built, you can [deploy the `content-testing` branch to stage](https://docs.gitlab.com/ce/ci/environments.html#manually-deploying-to-environments)
- After GitLab says the deploy is complete, you'll still have to wait for sync.  This will take 15-30 minutes, you can monitor it using [this search in Scalyr](https://www.scalyr.com/events?filter="Syncing%20Mission"&teamToken=v01vrRl3xVZjX1k7LUc%2Few--&log=*stage*)

## Getting ready for testing

- Check that your course works on stage - code running, all images uploaded to S3, guided projects etc
- Make a copy of the [student feedback template](https://docs.google.com/forms/d/1VvuOz8BFHvIt8nsAGqgQCGxNKd2Pwxrnjk3pdVxVkHk/edit) and edit it to match your course.
- Create a new, private channel in the members slack called `#testing-{yourcoursenmame}` and invite DQ content and student success team members.
- Post in the slack channel, including:
  - Welcome and thanks
  - Link to your feedback form 
  - URL of the course page on stage
  - Instructions on how to get started - they can create a free account on stage for the test, since we have made the missions free.
  - Any other instructions you have for the students, for instance areas of focus etc.
- Pin the post.

## Monitoring the Test

- You should check in to see how testers are going throughout the test.
- You might also want to monitor via logrocket or writing a mode query.
- If you're not getting engaged testers, you may need to recruit more.
- A day or two before the end of the test, you should give everyone a final warning, and remind them to fill in the feedback form (even if they've only partially completed the course)

## Actioning the results

- View logrocket sessions
- Read Survey Results
- Decide on what changes to make in conjunction with your manager
- Make the changes