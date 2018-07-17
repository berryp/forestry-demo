---
title: LogRocket
---

Logrocket allows you to watch user sessions as a recording.  It also shows frontend console output and errors.   This usually won't be useful when debugging downtime issues, but may be useful when investigating other stack problems.

## Dashboard

You can get to the Logrocket dashboard [here](https://app.logrocket.com/vlprdq/prod/sessions).  The dashboard shows you a list of user sessions, sorted by most recent:

![](../images/logrocket_dash.png)

You also have additional filtering options, where you can scope by URL, redux action, etc:

![](../images/logrocket_filtering.png)

You can click into user sessions:

![](../images/logrocket_session.png)

When you click into a session, you can hit play to view a recording of the user's interaction with the site.  You can also maximize areas on the right to see the contents of the Redux state store at various points:

![](../images/logrocket_redux.png)

This is a very powerful tool, that will let you see exactly what application state the frontend is in at different points, as the user is browsing the site.  If you suspect an issue may be frontend-related, this is a good place to dig.

