---
title: Using Content Manager
---

The new content manager is designed to solve several problems for content writers:

 *  The need to run a fragile hardware-intensive, and complicated docker-compose setup
 *  A long, focus-interrupting process with several steps between saving a notebook and seeing how it looks in the user interface.
 *  Unable to write content on Windows because our stack doesn't run there (Haven't tested this yet, but it should work with a bit of debugging at worst).
 *  Needing to upload images to S3 and coordinate the image names with when they get released.

## Current Status

As of today, content manager supports the following workflow:

 *  Edit your code in a jupyter notebook as usual.
 *  Save the code and run a single command to push your mission to content manager in draft mode within 10 seconds.
 *  View the draft content from any development server that is running the [feature/content-manager-frontend](https://gitlab.dataquest.io/dataquestio/mainstack/merge_requests/310) branch of mainstack. We will be running this branch semi-permanently on https://sandbox.dataquest.io.
 *  Save your code, refresh the mission, see your changes.
 *  Whenever you push a mission, automatically push the images to S3. You may find bugs in this.

Notably, code running does not work, but this preview release should aid you in previewing your content as you write.

In addition, if content manager was deployed in prod, you could 'publish' a mission and it would be immediately visible in the production site.

## Awesome! How do I use it?

You need to install the [content-push](https://gitlab.dataquest.io/dataquestio/content-push) project, as follows.

### Dependencies

You need Python 3.6 or higher running on your system. You can use the system installer of your choice. I personally use and recommend
[pyenv](https://github.com/pyenv/pyenv#installation). If you have trouble there are good [troubleshooting instructions](https://github.com/pyenv/pyenv/wiki/Common-build-problems).

If you can get your hands on a `content_push.pex` file that was built on the same operating system that you use, that will be the easiest way to get set up. I envision more technical content authors creating these pex packages to share with Dataquest newbies.

If you have access to a working pex file, you just need to run `/path/to/content_push.pex` to run the command, or put it in a folder on your system PATH.

#### Running without a pex file

If you can't access a pex file, you can clone the repo and run it as follows:

 *  For isolation and safety, optionally create a virtualenv (using `python3.6 -m venv` or `pyenv virtualenv` or `conda` or whatever you prefer) and activate it
 *  `git clone https://gitlab.dataquest.io/dataquestio/content-push.git`
 *  `cd content-push`
 *  `pip install -r requirements.txt`
 *  `cd /path/to/dscontent`
 *  `python /path/to/content-push/content_push`

#### Building a pex file

If you're one of the more technical people who is building a pex file for someone else, follow the same instructions for running without a pex file and then:

 *  `pip install -r requirements-dev.txt`
 *  `make`

The resulting `content_push.pex` file will be put in the same directory and can be sent to the other writer. Only caveat is that it has to be built on the same type of OS that the other person has (We'll probably want to collect different OS versions to a download location at some point).

## Configuration

You need authentication to push content to content manager. Someone with auth0
access (Dusty) will have to get you the keys.

There are three ways to supply configuration values:

 *  Create a `~/.config/dq_content_push.yaml` file
 *  Explicitly pass yaml filename on the commandline with the --config flag
 *  Set environment variables prefixed with `DQCP_`

I recommend the first option. Environment variables will overwrite whatever was passed into the configuration file.

Minimally, you need two config options in your config file:

```
    AUTH0_CLIENT_ID: <client id>
    AUTH0_CLIENT_SECRET: <client secret>
```

Or pass the same values as environment variables:

```bash
    export DQCP_AUTH0_CLIENT_ID=<client id>
    export DQCP_AUTH0_CLIENT_SECRET=<client secret>
```

## Commands

All commands are meant to be run from the `dscontent/` base directory.

To publish a mission in draft mode and make it immediately
visible in any development environment *running the content frontend branch* (localhost, sandbox, stage, etc):

```
    content_push.pex push_mission <mission_sequence>
```

To move a mission from draft mode to prod mode and make it visible in the
production dataquest environment *(requires publish permission in auth0)*:

```
    content_push.pex publish_draft <mission_sequence>
```

That will not push anything from your machine, it only publishes what is currently live in draft mode.

To push the tracks.yaml and courses.yaml from your current directory *(prod requires publish permission in auth0)*:

```
    content_push.pex push_metadata draft|prod
```

**Note that this is currently dangerous** It blindly overwrites whatever
is currently published for those missions. Content authors will need to
coordinate to make sure that metadata is only pushed to production for courses
that are live. I have plans to improve this, possibly by only allowing publishing from the master branch.


## Be aware of
 *  Image files not in the mission directory don't get uploaded to s3. There are a bunch of links to images in the `dq-content` base directory. They will continue to work in production, but won't be visible in draft mode. They should be moved into the mission directory when you come across them for good housekeeping.
 *  Currently `courses.yaml` and `tracks.yaml` are uploaded in their entirety when you `push_metadata`. This could cause problems if you are trying to test/publish multiple courses at a time. For now, this will have to be resolved socially (ie: good communication on the content team)!
 *  Sometimes the mission push errors with a bunch of "wait 30 seconds and try again" messages. This is a bug in our google configuration. Typically waiting 30 seconds and trying again works ok.
 *  Code running either doesn't work or may work by coincidence only because the mission was previously synced the old fashioned way. Right now this is only for previewing your mission live.
