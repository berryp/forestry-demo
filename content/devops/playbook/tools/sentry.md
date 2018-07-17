---
title: Sentry
---

We use Sentry mainly to quickly lookup and categorize application errors, frontend and backend.

Sentry is an error reporting tool that captures all errors in an application.  It's hooked up to our Javascript frontend and our Python backend in the staging and production environments.  Sentry allows you to see and diagnose application errors quickly.  It should often be the first place you look if there's a site issue, as any errors will show up in it.

### The dashboard

The [Sentry dashboard](https://sentry.io/dataquest/web-prod/) shows a list of errors that occured on the site, sorted in descending time order:

  ![sentry dash](../images/sentry_dash.png)

Errors are aggregated, so you can see how many times each error has occured, plus when that happened.  This is the graph next to the error.  You can also tell if the error came from the frontend or backend by looking for the `Javascript` label next to the issue.  You can click the filter button to get access to a lot of filtering options:

![sentry filtering](../images/sentry_filtering.png)

The filtering options allow you to restrict to frontend/backend, lookup by user, by release commit hash, and a bunch of other options.

## The issue

If you click into an issue, you'll see this:

![](../images/sentry_issue.png)

The issue lets you see the traceback of the issue, along with other information.  It's almost always super useful to look at the traceback.



