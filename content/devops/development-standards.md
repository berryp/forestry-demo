---
title: Development Standards
---

## Git curation

Good commit messages are almost mandatory, Dusty goes berserkers if you break the site with a commit message that doesn't explain what you did, why, and how you tested. Any commit can break the site, so every commit should explain what you did, why, and how you tested it.

Read https://chris.beams.io/posts/git-commit/ each night before you go to bed.

Add a 'test plan' to each commit message that lightly explains a way you have tested the commit that others can reproduce. Sometimes it's fine for the test plan to be "I didn't test it" or "test in prod". But be explicit about that fact in your commit message!

You might want to make this your commit message template. (Save it as `~/.gitmessage` and add `template = ~/.gitmessage` to a `[commit]` section in your `~/.gitconfig`.)

```
Subject, with up to 50 characters, like this line

Explain exactly what you did and why. Not how. Go into detail.

Link to issues.

Test Plan:
How did you test this?

# See https://chris.beams.io/posts/git-commit/ for great tips on
# commit messages
```

In addition to good git messages, please also maintain quality git history. This means:

 *  Every commit does exactly one thing (rule of thumb: your commit message shouldn't contain the word 'and')
 *  Every commit in your branch should tell a logical story
 *  Imagine that you are using the commit messages to teach someone else how to build the product you are building, step by step.
 *  Learn how to use these commands (or your IDE's equivalent):
     *  `git commit --amend`
     *  `git rebase -i`
     *  `git add -p`
 *  Commits that just say, "oops", "bleh", "tests", etc are a sign that you haven't curated your commit messages.
 *  It's totally ok to `git push -f` if you are pushing to a branch that no-one else has downloaded or worked on.
 *  It might be ok to `git push -f` if you communicate with the person who has downloaded or worked on that branch.
 *  In general, don't rewrite history that has been merged to master
 *  Check the output of something like `git log --graph --decorate --all --oneline` regularly to make sure it looks sane.

### Why is git commit history important?

Software developers typically don't pay a lot of attention to commit history because they're usually "thinking forward". Given the point they are currently at, how do they get to the point where they want to be? They involuntarily believe (falsely) that once they are at that point, everything that was done up to then won't really matter. They think it's ok to explain away all the intermediate warts in a merge request message.

At best, this is really bad communication, something we can't afford on a remote team. At worst, it's downright cool to the people integrating your code. People use commit messages in these cases:

 *  When they are integrating a bunch of branches for a deploy and need to check if they conflict or why.
 *  When something breaks and they need to figure out what it was and fix it while you are asleep or on vacation. They will use `git bisect` to do this, and git bisect needs a well-curated history in order to quickly identify the breaking commit.
 *  Once the breaking commit has been identified, someone needs to figure out what it was supposed to do and why, even before they figure out what it actually did and how.

## mainstack/frontend

The frontend has a comprehensive `.eslintrc` and has a precommit hook that
prevents you from committing anything that doesn't pass it. Definitely take
the time to get automatic linting set up in your editor.

You can run the unit tests with `npm run test:dev`. This will pop up a code
coverage window and tests will automatically rerun when you save your files
so you can see the output immediately.

Curtis needs to expand this documentation, but probably never will. ;-)

To start a new component, try:

`yarn blueprint dumb ComponentName`

There are a few blueprint types in Curtis' [github](https://github.com/CurtisHumphrey/redux_blueprints) repo.


## mainstack/backend

The codebase conforms to the `.flake8` file in the `mainstack/server` folder. Definitely `pip install flake8` and make sure your editor is configured to automatically highlight any lint errors.

Our current backend has a lot of crufty code. Some might say it's a lost cause. Try to follow the guidelines for new microservices (below) when you work on this code (especially for new files and features), but don't sweat it.

It's usually a good idea to avoid adding features to the `containers`, `connections`, or `missions` apps unless your code is tightly coupled to them. All three are painful legacy code and are at least partially in the process of being deprecated. Normally you can create a new app instead or use one of the other new ones.

New features should all be served via GraphQL instead of REST. Use of Django Rest Framework is deprecated. It's generally better to implement your own graphql endpoints rather than relying on the Django-graphene integrations, even if you are just querying a Django model and returning.


## New microservices

I envision a future where we have migrated the entire mainstack server to microservices. That future needs to have awesome code!

You should use whatever technologies you think are best when writing a new microservice. However, if you don't have a good reason to use a different one ("I want to try something cool" is a great reason, though), it's probably a good idea to model it off of [content-manager](https://gitlab.dataquest.io/dataquestio/content-manager/).

Namely, the following are recommended:

 *  Consider using a google cloud function before implementing a microservice.
 *  Use Python.
 *  Consider using pypy right from the start.
 *  Use [black](https://github.com/ambv/black) for code formatting. Just make it autorun on save in your editor and forget about it.
 *  Use asyncio and aiohttp for web services.
 *  Use graphql for APIs.
 *  Use [pytest](https://docs.pytest.org/en/latest/) for unit tests.
 *  [snapshottest](https://github.com/syrusakbary/snapshottest) is a great way to save time testing graphql and rest calls. But always check your diffs before committing.
 *  Get 100% coverage, but use `# pragma: nocover` extensively.
