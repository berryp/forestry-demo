---
title: Content test-suite
---

## Markdown Tests

The `dscontent/tests` folder contains the test suite for all Markdown only tests (no code running). These tests check screens, missions, courses, steps, subjects, and paths. They test for things like:

- Does a screen with an answer have answer checks?
- Do screens with instructions also have hints?
- Do path meta titles exceed a length limit?
- Do all courses belong to a path?

The tests are pretty readable now, and it should be easy to add more. The tests are integrated into the gitlab flow, and can also be run locally by:

- Install the libraries from `dscontent/tests/test_requirements.txt`: `pip install -r test_requirements.txt`
- `cd tests`
- `python test.py`


## To-do

- Add more documentation on where / how to add new content tests
- Modify test suite to run for just a screen, mission, or course.