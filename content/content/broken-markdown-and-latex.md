---
title: LaTex content is not centered
---

While Markdown might be rendered perfectly well in your Jupyter notebook, this might not be the case on the website. Below we describe a couple of common issues, and how to fix them.

### LaTex content is not centered

Although you used `$$`, and your math content is centered well in Jupyter, you can't see the same effects on the website after syncing. To fix, try to use this syntax:
```
\begin{equation} some_equation \end{equation}
```

### Markdown table is not rendered

You used Markdown syntax to generate a table, and it works perfectly well inside your Jupyter notebook. However, the table is not rendered on the website. The solution here is to use HTML code to create the table.

Here's a nice hack from Josh on how to get the HTML code really fast:
* Using your browser's DevTools, inspect the table (generated using [regular Markdown syntax](http://www.tablesgenerator.com/markdown_tables)). To do that, right click on the table, and then click `Inspect` (if you have Chrome). 
* From there, simply copy the HTML used to generate the table. This should be stored within a `<table>` tag. Right click on the `<table>` tag, and then click `Edit as HTML` - this will make it easy to copy the HTML content.

### Markdown lists are not rendered

You used some lists that are rendered well in your notebook, but not on the website. The solution is to try to add some new-line characters between each list element (add new line characters by hitting <kbd>Enter</kbd>).

For nested lists, make sure the nested elements are 4 (or multiples of 4) space characters away from the line's starting point.

### Images are not centered

In Jupyter, images look centered, but on our interface the centering is not preserved. To fix, use HTML:
```
<center>
   ![img](img.svg)
     </center>
```