---
title: Scalyr
---

Scalyr is good for quickly seeing log output from all of our services.

Scalyr aggregates logs from all of our services.  These logs are surfaced in a combined dashboard that allows for searching and filtering.

## Dashboard

The Scalyr dashboard shows all the log sources:

![](../images/scalyr_dash.png)

Most of our logs come from the kubernetes cluster, which can be clicked into.

## Log view

A good place to start with the log view is [here](https://www.scalyr.com/events?logSource=k8s.dataquest.io&showFields=%5B%22application%22,%22log%22%5D&showStamps=%5B%22timestamp%22%5D).  This will display all logs coming from the kubernetes cluster, in a readable format.  

You can further filter by application:

![](../images/scalyr_filter.png)

You can also filter by what's in a log line:

![](../images/scalyr_log.png)

You can click on an individual log line to see the entire original log, for more context:

![](../images/scalyr_click.png)

If you see log lines in an unreadable JSON format, you can click "Display" and edit the shown fields to look like this:

![](../images/scalyr_display.png)