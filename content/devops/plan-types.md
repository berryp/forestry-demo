---
title: Plan Types
---

## Plans

### Free
Free accounts have access to any mission that has the `premium` flag set to `False`.

### Basic
Basic accounts have access to any mission in the data analyst path, in addition to any mission that a free account can access.

In the code, the python data analyst path/track is represented by track sequence 1. For example: the query `Mission.objects.filter(course__track_steps__track__sequence=1)` will return all missions that belong to track sequence 1.

The basic plan also includes some missions in R, represented by track sequence 4.

### Premium
Premium accounts have access to all missions.

Note: In the code, the `premium` flag on a mission means that it is paid content. This does not mean that it is exclusive to the premium plan.

### Other
A 'plus' or 'mentorship' plan may still be referenced in the code, but it has been discontinued.

## Changing plans locally

To grant a user premium access locally, use the command `python manage.py add_premium <email> 300` where 300 is the number of days of premium.

If you have Stripe keys in your `private.py` file, you can go through the subscribe flow at `http://localhost:3000/subscribe` to subscribe to either basic or premium. Use a credit card with the number `4242 4242 4242 4242`.