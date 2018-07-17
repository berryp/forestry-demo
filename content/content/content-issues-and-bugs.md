---
title: Content issues and bugs
---

Because content errors and bugs are often small in scope but high in volume, we will keep them in [the issues section of dscontent](http://gitlab.dataquest.io/dataquestio/dscontent/issues) rather than [the main planning issues list](http://gitlab.dataquest.io/dataquestio/planning/issues).

This is a simple guide on how to handle the system.

## Format for writing up issues.

- The title of the issue should start with the mission sequence number (ie the number from the URL) and the step number/s if it refers to particular step/s
- Wherever possible, the issue should start with a link to the mission/step, to make it easier to verify/address
- Be clear about where in the step the issue is - introduction, instructions, example code, starter code, solution, etc
- If a solution is obvious, write it into the issue
- If you believe the issue is high priority, tag it as such **AND** add a comment tagging someone on the content team so you know it will not slip through.

An example of an issue that meets this spec is below

![Screen_Shot_2017-04-26_at_14.59.41](../images/Screen_Shot_2017-04-26_at_14.59.41.png)



## Labels

- All content issues, no matter whether a typo, answer checking issue or otherwise should be labelled `Bug`
- Where an issue is reported by a user and you are not confident that you agree, or if you feel this may be a subjective issue, use the tag `Needs Confirmation`
- Anything that is a high priority to be fixed should be tagged `High Priority`.  Usually this is limited anything that affects a users ability to complete the step, eg an error with a variable name in the instructions, or a significant error in the introductory text that causes many users to have trouble completing the mission. Outside of this, no other priorities are tagged.
- You should add one of `Easy`, `Medium` and `Hard` to indicate what sort of effort is required to fix this.  If you are not sure, please estimate on the easier side - we would rather upgrade the difficulty than downgrade, as harder bugs tend to be addressed less frequency.  A guide on what these mean:
  - Easy: Requires a small change to one step in a mission, usually a correction or where in the writeup of the bug a solution is proposed.
  - Medium:  Requires no more than one step in a mission to be rewritten or fixed.
  - Hard: Requires multiple steps or part or whole of a mission to be rewritten.
- `Needs more detail` is used to indicate that we need the author of the issue to add more detail - more below.

## Procedure

- We should be logging bugs as we find them, so that they can be addressed in a timely fashion.
- We should aim to fix, or at least start addressing, any 'High Priority' bugs in the week they are found
- If there is not enough detail in the issue to address it, apply the `Needs more detail` **AND** comment tagging the author of the issue so they can help you out
- Where a bug is found to be not in content, we need to rewrite the issue to be understandable from a developer perspective and log it as per this process: https://docs.google.com/document/d/184t0LxCRqLzwOQ2FuRlLLYnGMAX_FZeFempLIlq6gyQ/edit
- Where we want to update and improve this system, please also update this document