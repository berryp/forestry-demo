---
title: Fixing content bugs
---

## Step 1: Fire up the stack

- `docker-compose pull` (every week or so)
- `docker-compose up`
- Wait until sync is finished

## Step 2: Create new branch off master

In dscontent, branch off master. 

* Example: use following style for branch name: `fix/sarp/may31`

## Step 3: Open up the Issues tab on Gitlab

- Navigate to open issues - [https://gitlab.dataquest.io/dataquestio/dscontent/issues?scope=all&state=opened](https://gitlab.dataquest.io/dataquestio/dscontent/issues?scope=all&state=opened)
- Filter by **label**:

![image_0](../images/image_0.png)

## Step 4: Identify Issue to be fixed & make changes

Remember to maintain a list of issues you’ve fixed. Use the issue number. You’ll see why later.

**Text-Only Changes**

For simple, text-only changes, just make the change using Jupyter Notebook, save the notebook, and exit. 

* Example: [https://gitlab.dataquest.io/dataquestio/dscontent/issues/248](https://gitlab.dataquest.io/dataquestio/dscontent/issues/248)

* Open Mission 143 on production site - [https://www.dataquest.io/m/143/multiple-plots/8/overlaying-line-charts](https://www.dataquest.io/m/143/multiple-plots/8/overlaying-line-charts) 

* Confirm that the issue exists

    * Does step 8 in mission 143 actually have the word **multipe**?

    * If so, note the step name (**Overlaying Line Charts**)

* Open `dscontent/143/Mission143.ipynb` in Jupyter Notebook. 

    * Search for the step **Overlaying Line Charts**

    * Replace **multipe** with **multiple**. Maybe do a quick check of other instances of **multipe** in this mission too!

* Save notebook, and move onto next Gitlab issue. **Add the issue number to the list of fixed issues you’re maintaining.**

**For code or diagram changes:**

* When code is changed in the mission

    * Example: [https://gitlab.dataquest.io/dataquestio/dscontent/issues/244](https://gitlab.dataquest.io/dataquestio/dscontent/issues/244) 

* When a diagram / visual asset is changed and needs to be confirmed in our UI

    * Example: [https://gitlab.dataquest.io/dataquestio/dscontent/issues/247](https://gitlab.dataquest.io/dataquestio/dscontent/issues/247) 

You need to instead **sync** the notebook changes. 

## Step 5: Testing Changes

For code or diagram changes, test changes on local machine to ensure issue was resolved. To do this, you’ll have to sync your changes.  To see how to sync your changes, see [getting started](../getting-started)

## Step 6: Add Issue Number to the List of Fixed Issues

If the changes you made look good and resolve the issue, add the issue number to the list of fixed issues you’re maintaining.

## Step 7: Commit & Push to Gitlab:

After you’ve made many changes and want to push your branch up to Gitlab.

```
git commit -am 'Fixed easy dscontent bugs'
```


Push the branch upto gitlab:

```
git push origin fix/sarp/may31
```

## Step 8: Create a merge request

After the branch is up on Gitlab, you need to navigate to the gitlab dscontent repo, click the create merge request button, and edit the body of the merge request to match [this one](https://gitlab.dataquest.io/dataquestio/dscontent/commit/b269703dcc1b7fedbc1c189610bbdb2a3f125284)

You’ll notice how the dscontent issues that are being closed are tagged in the following way:

![image_2](../images/image_2.png)

Mirror this style whenever you’re fixing bugs: `Closes #issuenumber1, #issuenumber2, etc`


## Step 9: Wait for Approval

Have at least one other person review the changes. 

## Step 10: Confirm in Production

After changes are deployed in production, spend 30 minutes to review all the fixed bugs to ensure everything is running smoothly.