---
title: YAML file formats
---

## Mission meta.yml

### Top level fields

 *  **required** `title: "A Compelling Title"`
 *  **required** `description: "The long description of the object"`
 *  **required** `meta_title: "Something even more compelling for the metadata"`
 *  **required** `meta_description: "and the meta description, too"`
 *  **required** `author: "You A. Awesome"`
 *  **optional** `persist_path: "/home/dq/a-path-you-know"`
 *  **optional** `mode: "commandline"`     (choices: `commandline`, `singlescreen`, `project`)
 *  **optional** `ipython_kernel: "shell"` (choices: `sql`, `postgresql`, `postgresql_shell`, `r`, `shell`, `python3-spark`) 
 *  **optional** `type: "challenge"`       (choices: `challenge`, `project`, `jupyter_project`, `guided_project`)
 *  **optional** `language: "python"`      (Maybe this can be deprecated, it looks like it is always Python)
 *  **optional** `premium: true`           (default: false)
 *  **optional** `mentorship: true`        (default: false)
 *  **optional** `files:`                  *see below*
 *  **optional** `datasets:`               *see below*
 
### Datasets
 
The datasets field contains a list of datasets. I have to admit I'm not 100% sure I understand all the fields so you may want to update this. Following standard yaml, each item in the list starts with a `-`.  There are several items in a datasets object. I think all of them are required. Here's an example:

```
datasets:
- title: ''
  url: 'https://www.govtrack.us/congress/votes'
  public: true
  notes: ''
```

Note: It looks like there can be multiple datasets per mission, but I haven't seen any examples that have more than one. I think they can be optional, but I don't think there are any missions that don't have them right now.

### Files

The files field contains an object with several fields that each list different types of files. I believe all of the fields are optional, as is the entire files section, if there aren't any files for that mission.

There can be up to four keys in a files object:

 *  `immutable:` The list of files that are immutable
 *  `all:` The list of all files included with the mission
 *  `default:` The list of default files. Typically a subset of `all`, but we have a fix to merge default into `all` if they are missed.
 *  `blacklisted:` List of files that should not be displayed to the student.
 
 As per yaml syntax, each file is listed under the heading with a `-` prefix. Here is an example:
```
files:
  all:
  - Basics.ipynb
  - wiki
  - scrape_random.py
  default:
  - Basics.ipynb
  immutable:
  - wiki/*
 ```
 
 ### Example
 
 Here are a couple real examples from `dscontent`:
 
 ```
 title: "Guided Project: Analyzing Stock Prices"
description: "Use the correct data structures to analyze stock prices efficiently"
author: "Vik Paruchuri"
meta_title: "Guided Project: Analyzing Stock Prices - Learn Data Engineering"
meta_description: "Analyze stock price data using your knowledge of data structures.  Find the most profitable trades, and explore stock market trade volume."
ipython_kernel: "shell"
mode: "project"
persist_path: "/home/dq/notebook"
type: "jupyter_project"
premium: true
files:
  all:
  - Basics.ipynb
  - prices
  - download_data.py
  - nasdaqlisted.txt
  default:
  - Basics.ipynb
  immutable:
  - prices/*
datasets:
- title: ''
  url: ''
  public: false
  notes: 'This dataset was downloaded.'
```

Or

```
title: "Data Cleaning Walk-Through: Analyzing and Visualizing the Data"
description: "Learn how to analyze and visualize real-world data."
author: "Vik Paruchuri"
meta_title: "Analyzing & Visualizing The Data: Data Walkthrough - Python Tutorial"
meta_description: "Learn how to analyze and visualize a real-world schools dataset. Finding correlations and calculate statistics using  matplotlib, basemap, Pandas, and Python."
mode: "singlescreen"
premium: true
files:
  all:
  - schools
datasets:
- title: ''
  url: 'https://data.cityofnewyork.us/data?cat=education'
  public: true
  notes: ''
```

## Concepts meta.yml

Concepts `meta.yml` currently has only two keys, title and description.

## Tracks.yaml

To be filled in by someone else.

## Courses.yaml

To be filled in by someone else.

## Sections.yaml

To be filled in by someone else.