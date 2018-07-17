---
title: Cloudflare
---

We use cloudflare to configure our DNS.  Cloudflare also caches certain static pages, to save on bandwidth, and increase speed (they have edge caches around the world).  If you notice that an outdated/strange asset is being served, or a DNS resolution is wrong, Cloudflare is the place to look.

## DNS

You can view DNS [here](https://www.cloudflare.com/a/dns/dataquest.io):

![](../images/cloudflare_cns.png)

If the orange icon is on for a given route, that means that cloudflare will cache assets on that route.  It also means other things (like it does naked domain flattening, WHOIS hiding, etc), so don't turn this off unless you know what you're doing.

## Caching

You can view the caching rules [here](https://www.cloudflare.com/a/caching/dataquest.io).  Cloudflare will automatically cache static assets for routes.  Sometimes, this caching is too aggressive.  You can purge the cache for specified paths, or purge the whole cache:

![](../images/cloudflare_cloudflare.png)

You'll usually need to purge when there are strange frontend or blog issues.