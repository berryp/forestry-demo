---
title: Screen keys
---

To assist with tracking changes to screens in missions, in the metadata for each screen's notebook cell, there is a `screen_key` parameter:

```
<!--- screen_key='bcQqaTbADQC9M9bMRqEznV' type='code'
concepts=['variables', 'dataquest'] --->
```

The screen key is a string that acts as a unique identifier for each version of that screen.

## Working with screen keys while editing screens

If you change the code (ie non-text) parts of a screen and try to sync without changing the screen keys, you will get an error

```bash
dscontent $ ./dscontent sync 187

ValueError: Screen key `SDEzGFP9KmNHk9qJ7MX3KP` in Mission 187 -- Challenge: Summarizing Data is not unique. No changes
to the mission were applied.

This probably happened because you inserted, changed, or deleted a screen in the mission. To fix
this issue run `python manage.py bump_screen_keys --mission=187`, then commit the
changes to the DSContent Git repository.

Doing this informs prod to migrate progress to the newest version of the mission next time
`python manage.py sync_local_sources` is run (next deploy).
```

The easiest way to fix this is to modify the screen keys before you sync.  There is a helper command that you can use for this:

```bash
dscontent $ ./dscontent manage bump_screen_keys --mission 187
System check identified some issues:

WARNINGS:
?: (1_8.W001) The standalone TEMPLATE_* settings were deprecated in Django 1.8 and the TEMPLATES dictionary takes precedence. You must put the values of the following settings into your default TEMPLATES dict: TEMPLATE_DEBUG.
Overwrote screen key with new key `3ttMZHV7obEg4kFsacNr8a` to mission `187`
Overwrote screen key with new key `voYVu2g8pmqnsJPD32asA7` to mission `187`
Overwrote screen key with new key `ZsDjGqnpRssjWRW34QA4nW` to mission `187`
Overwrote screen key with new key `UpBcSd5Ti5g7scTnNaQJwh` to mission `187`
Overwrote screen key with new key `UYc5r9tzTf924ksNEPkGa5` to mission `187`
Overwrote screen key with new key `27AQuXdsRspnBYJN8DQaxf` to mission `187`
Overwrote screen key with new key `LdcMqb9hinb3W7N8GbFUBa` to mission `187`
Overwrote screen key with new key `9s8wF6LcZXXYkmarWE4sxB` to mission `187`
Overwrote screen key with new key `MTJqCUHV66TZkqjiexnhyK` to mission `187`
Overwrote screen key with new key `DgEaNFLVRWEWu4bj8bYrtU` to mission `187`
Overwrote screen key with new key `M3yRXdEk7fjLNYMFXwXuqa` to mission `187`
```

An alternative is to edit the screen key directly in the metadata, since the key doesn't have a particular format/length, and just needs to be unique.  The easiest way is to delete a few characters or insert a few characters as you go.

## Gotcha with screen keys when syncing a mission for the first time.

The `bump_screen_keys` command only works when a mission has previously been synced.  This means that if you are trying to sync you can get yourself into a state where sync is telling you to use `bump_screen_keys` but the command does not work.

```bash
dscontent $./dscontent sync 999

ValueError: Screen key `SDEzGFP9KmNHk9qJ7MX3KP` in Mission 999 -- Challenge: Summarizing Data is not unique. No changes
to the mission were applied.

This probably happened because you inserted, changed, or deleted a screen in the mission. To fix
this issue run `python manage.py bump_screen_keys --mission=999`, then commit the
changes to the DSContent Git repository.

Doing this informs prod to migrate progress to the newest version of the mission next time
`python manage.py sync_local_sources` is run (next deploy).
```

```bash
dscontent $ ./dscontent manage bump_screen_keys --mission=999
System check identified some issues:

WARNINGS:
?: (1_8.W001) The standalone TEMPLATE_* settings were deprecated in Django 1.8 and the TEMPLATES dictionary takes precedence. You must put the values of the following settings into your default TEMPLATES dict: TEMPLATE_DEBUG.
```

This will be happening because you are using a template to write the mission, and the template has screen keys that already exist in your content database.

The solution is to manually edit each of the screen keys in the notebook, after which the the mission should sync without error.