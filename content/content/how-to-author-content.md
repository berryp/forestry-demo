---
title: How to author content
---

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#setup-rerequisites)
- [Preparation for writing a new course](#preparation-for-writing-a-new-course)
- [Writing the Mission](#writing-the-mission)
- [Post-Writing](#post-writing)
- [Other Info](#other-info)
- [Todo](#todo)

## Introduction

When it comes to authoring content, there are a few important steps to get you up and running. We have written a lot of content in our time at Dataquest and have found things that work for us and things that have not. The following is a guideline on how you should author your content:

### Courses

1. Make a Course Outline
 * Course outlines help you organize your missions so that you know the flow of the missions and how they relate to one and another.
 * They are not set in stone and can be updated as you continue to write your missions. Don't feel like you have to adhere to the outline completely, sometimes you will find that you can describe the topic better with a different mission structure.

### Missions

1. Make a Mission Outline
 * As a similar argument to the Course Outline above, mission outlines help guide your mission and provide a helpful structure to follow.
2. Code Exercises over Text Screens
 * When writing content, you want to ensure that you will be adding code exercises for the vast majority of screens that you write. Keep text screens to a minimum.
3. Motivate the Students
 * In the first screen, give a good reason why the students should learn the topic your are introducing.
 * Students should know why they are learning a topic instead of a hand-wavey reason that "that's the way things should be taught".
4. Add Diagrams
 * Diagrams provide the students with a visual representation of what you may be trying to communicate.
 * Sometimes you can replace two paragraphs with an easy to follow diagram.
5. Conclude the Mission
 * Wrap up the mission in a Next Steps section that gives a summary of what the students were expected to have learned.
 * Conclude by introducing the next topic and how it relates to the current mission.

## Setup: Prerequisites

Before getting started creating content, there are a few things you need to do:

### Set up dscontent through docker:

Make sure you have dscontent setup through docker-compose. If you don’t already have this setup, see the [installation guide](../installation).

### Ensure Master branch is up to date:

Navigate to the dscontent folder, switch to the master branch, and make sure the master branch is upto date.

```
git checkout master
git pull origin master
```
### Create a new git branch:

```
git checkout -b branchname
```

- Redoing a mission? Name the branch: `redo/srini/m6`
- Writing a new mission or course? Each course will have it’s own branch. Name the branch `feature/srini/linearalgebra`
- Fixing some [content bugs](https://gitlab.dataquest.io/dataquestio/dscontent/issues)? Name the branch: `fix/srini/may1`

## Preparation for writing a new course

### Claim a Mission Number:

Each mission has a unique number associated with it. To prevent conflicts, use the [Mission Numbers document](https://drive.google.com/open?id=14SLSTQWKx6hHUnFQwhAM32l_DNhYSjPaN-c3W_0BT-c) to claim the numbers you need for each mission in your course.

### Create a new folder in dscontent for each mission:

- If you claimed the numbers 1, 2, and 3, you need to make the following folders:
    - `dscontent/1`
    - `dscontent/2`
    - `dscontent/3`

### Copy template files:

  - If a normal mission, use the template files from `dscontent/templates/normal_mission` . Copy the following files into your new mission folder:
    - `meta.yml`
    - Copy & rename `normal_mission_ipynb` → `Mission1.ipynb` (notice the extension change)
  - If a normal mission _with_ widgets, use the template files from `dscontent/templates/widgets` .
    - Copy `meta.yml` to your new mission folder
    - Copy and rename `widgets_mission_ipynb` → `Mission1.ipynb` (notice the extension change)

### Run your jupyter notebook:

Open your terminal / CLI. Navigate to dscontent and run the command `jupyter notebook` . If your browser doesn’t automatically open jupyter notebook, copy and paste the URL from your CLI.

### Edit meta.yml & other setup files:

Open the dscontent folder using Sublime Text or Atom, or your favorite text editor. This is so you can edit `meta.yml`, `concepts/meta.yml`, and other files.

  - **Mission notebook:** `1/Mission1.ipynb` . Notebooks contain the actual content.
  - **Meta file:** `1/meta.yml` . This file specifies the type of mission, files required, etc. Read more here:  [YAML file formats](../yaml-file-formats)

### Add description + objectives to .yaml files.

Navigate to the dscontent page and open courses.yaml. Add the course + number to this yaml file.

Remember to add these numbers as you create them. Do not add them beforehand or it will fail to sync. 

## Writing the Mission

### Content:

To create high-quality content, review the following documents:

  - [Style Guide:](../style-guide) To understand the basics of technical writing style.
  - [Teaching Style Guide:](../teaching-style-guide-v2) To understand how to create high-quality, teaching content.
  - 

### Screen sync:

After completing each screen, sync it and check the screen using docker. Do not wait until the last screen to check everything. There are three types of screens:

  - Code screen with answer checking
  - Code screen without answer checking (purpose of screen is to let user explore/ play with code
  - Text screen

### Screen Metadata

  In order to make sure screen sync’s correctly, make sure you have metadata for each screen. Screen meta data look like this:

**For first screen:**

```
<!-- screen_key='Nz8LkgLN4Lp8keLYUkraHX' mission_number=55
file_list=["2015_white_house.csv"] mode="singlescreen"
premium=False docker_image="dataquestio/r-runner"
ipython_kernel="r" -->
```

**For code screens:**

```
<!-- screen_key='Nz8LkgLN4Lp8keLYUkraHX' type='code'
concepts=['variables', 'dataquest'] -->
```

There is a python parser that parses the raw json notebook file. The parser uses this piece of code to parse the notebook into their correct screens.

Screen keys have to be unique. For more on screen keys, you can read the [screen keys](../screen-keys/) docs.

### How answer checking works:

  - `##check vars`: Checks the values of the variables against the solution.
  - `##check val`: Makes a string comparison between user-input and solution.

## Post-Writing

Make sure you clear your jupyter notebook outputs before pushing, otherwise the reviewer will not be able to make line-by line comments on your diff.

### Push your course/changes to Gitlab:

When you've finished making your changes and you want to push your branch, you can commit your changes:

```
git add .
git commit -am 'Fixed easy dscontent bugs'
```

After this, push the branch up to Gitlab:

```
git push origin fix/sarp/may31
```

After the branch is up on Gitlab, you need to navigate to the gitlab dscontent repo, click the create merge request button, and edit the body of the merge request to match [this one](https://gitlab.dataquest.io/dataquestio/dscontent/commit/b269703dcc1b7fedbc1c189610bbdb2a3f125284).

### Review and ensure content passes acceptance criteria:

- Mission cover topics in course outline
- Mission meets our standards for explanation (Currently per Srini review)
- Missions are bug free and have been tested thoroughly

## Other Info

- Mission level metadata
- Course / Sections / Tracks metadata (courses.yml, sections.yml, tracks.yml)
- Concept tags `concepts/___/meta.yml`
- Screen metadata (screen_key, concepts, type, error_okay)
- Links to relevant documents `dscontent/README.md` Style Guide from content folder, etc).
- How to create diagrams, where to upload, etc.
- In order to put code in the notebook:

```python
print('hello world')
```

## TODO

Writing a mission

1. More about meta.yml / header
2. How to author a screen
  1. Metadata
  2. Sync & test