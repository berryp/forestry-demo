---
title: Screen index
---

Screen index is a replacement for the screen key parameter in mission screen metadata lines. It's a unique identifier for a screen that can also indicate the screen's position in the sequence and what mission it belongs to.

A screen index looks similar to a semantic version number (major.minor.patch). It is made up of the mission number followed by a decimal point and a number that indicates the screen's relative position to the other screens.

For example, if mission 5 has four screens, their screen indices might start out looking something like this: `5.1, 5.2, 5.3, 5.4`

If a new screen is added at the end of that mission, its index would be `5.5`. If two new screens are then added between `5.2` and `5.3`, their indices would be `5.2.1` and `5.2.2`. This maintains the order of screens without having to change a screen's unique identifier, which makes it easier to associate screen progress with the correct screen when new screens are added to a mission.

## Generating screen index

To add screen index to a mission's screen metadata, run: `python manage.py generate_screen_index --mission <mission sequence>`

The output will let you know what has been changed:

```bash
python manage.py generate_screen_index --mission 5
Generating index for 10 new screens in mission 5
Inserted screen index 5.1
Inserted screen index 5.2
Inserted screen index 5.3
Inserted screen index 5.4
Inserted screen index 5.5
Inserted screen index 5.6
Inserted screen index 5.7
Inserted screen index 5.8
Inserted screen index 5.9
Inserted screen index 5.10
```

The resulting metadata lines should look something like this:

```
<!--- screen_index='5.2' screen_key='CMXLK5qs2DQRwYugQn6n3Q'
type='code' concepts=['dataquest', 'modules'] --->
```

Unlike `screen_key`, there's no need to add `screen_index` to a mission screen manually before running the script for the first time. The script will insert an index into the metadata of every markdown cell that doesn't already have one.

On subsequent runs of the script, any existing `screen_index` will stay the same, but new screens without an index will be assigned an index according to their position relative to the existing indices, as seen in the example above.

Sync doesn't require a screen to have a screen index, so missions in progress can be synced for testing without running `generate_screen_index` until the screen positions are finalized.

For the moment, `bump_screen_keys` still needs to be run. After we fully transition to content manager, screen keys will no longer be necessary.

## Removing or modifying screens

It may be necessary to manually modify a screen index in the event that a screen is removed or modified.

If a screen is removed, reusing its index for a new screen later could cause that screen to be incorrectly marked complete for users who completed the old screen. For now, adding a comment into the mission for any screen index that has been removed can help to keep track of this, but eventually we will need a better solution. If a mission has had screens removed, make sure to check for any reused indices after running `generate_screen_index`.

If a screen is modified and progress doesn't need to be cleared, then the screen index will stay the same.

If a screen is modified and progress should be cleared, the screen will need a new index that fits in the same position. Currently, this will have to be done manually. It is possible that a new screen placed in its old position could be assigned the same index by the script. Like removing a screen, this can hopefully be avoided by adding a comment with the old index.