---
title: Style guide
---

## Principles

[https://jacobian.org/writing/technical-style/](https://jacobian.org/writing/technical-style/)

* "In the end, though, it really doesn’t make a whole lot of difference. The important lesson from all this is to **be consistent**. Readers find different stylistic choices off-putting, and they lend an uneven, unfinished tone. "
* "There’s one huge difference between the way people read print and the way they read electrons: **when people read online, they skim**. Study after study has shown that readers skip a large percentage of the words that float by on their computer screens. This means that good online documentation will feature a much **heavier reliance on markup** than most style guides allow for."
* "**While flow’s important**, it’s **hard to accomplish** in technical material. If you push it, you **end up with pointless transitions **– “now that we’ve talked about URLs, let’s talk about models!"”

## Structure of a mission

* Use inline markup liberally
* Write in short paragraphs
    * 3 sentences per paragraph (no more than 4)
* Use a variety of structural elements
    * Tables
    * Bulleted lists
    * Custom Diagrams
* Make your structure visual
    * Use good headers & sub-titles
        * Useful especially as people use completed missions to skim and reflect

## External Style Guides

### Writing

- AP Style Guide: [https://www.apstylebook.com/](https://www.apstylebook.com/)
- Strunk & White: [The Elements of Style](https://en.wikipedia.org/wiki/The_Elements_of_Style)

### Programming

- Python PEP8 : [https://www.python.org/dev/peps/pep-0008/](https://www.python.org/dev/peps/pep-0008/)

## Voice

* Active voice over passive voice
* Omit fluff
    * ~~This means that it should be pretty cross-sectional; a good tutorial should show off most of the different areas of the project.~~ (eliminate words like "pretty", “most”, “good”) <br />This means that it should be cross-sectional; a tutorial should show off the major areas of your project.
    * ~~To open a file in Python, we need to use the `open()` function.~~<br />To open a file in Python, we use the `open()` function.
    * ~~"In the diagram above, each of the first 4 rows is shown"~~ <br />"The diagram above shows the first four rows."

## Tone

* [Link to more in-depth Tone guide](https://docs.google.com/document/d/1J2fUH2M9l5JUnKnMxayg0MRD4AkwP3pqCKzlbmohHFs/edit?ts=580e724a)
* Watch out for subtle **passivity**. Sentences should start with verbs 

    * ~~"Your high school English class probably taught you that passive voice was bad style"~~ <br />"You probably learned in high school english class that passive voice was bad style"

## Dataquest Specific - Naming

### Course Title

Use concept whenever possible, followed by phase if relevant (Beginner, Intermediate, Advanced):

* Command Line: Beginner
* Command Line: Intermediate
* Git and Version Control

Otherwise specific technology:

* SQL and Databases: Beginner
* SQL and Databases: Beginner
* Python Programming: Beginner
* Python Programming: Intermediate

### Course Subtitle

For beginner / sole courses:

* Learn the basics of [concept1, concept 2, and concept 3]
    * Python Programming: Beginner
        * Learn the basics of Python, the programming language of choice for data analysis.

For intermediate courses:

* Learn more aspects of Python, including [concept 1, concept 2, and concept 3]
    * Python Programming: Intermediate 
        * Learn some more aspects of Python, including modules, enumeration, indexing, and scopes.
    * Data Visualization
        * Learn how to plot data in Python.

### Screen Title

* Screen titles are less important for the user doing the mission, and more important for:
    * Users considering doing the mission, or considering signing up
    * Users who have done the mission and are looking to revise a concept
* Because of this, we should try and write screen titles which explain the concept covered in that step, so that someone just looking through the steps can work out both what is taught in the lesson, and which step they should go to.  Here are some examples for [https://www.dataquest.io/mission/165/regular-expressions](https://www.dataquest.io/mission/165/regular-expressions):
    * Regular Expressions > Introduction (first one should usually be Introduction or Introduction to the Data)
    * Special Characters > Wildcards in Regular Expressions
    * Beginnings And Ends Of String > Searching the Beginnings And Ends Of Strings
    * AskReddit Data > Introduction to the AskReddit Data Set
    * Reading And Printing The Data Set > (no change)
    * Testing For Matches > Counting Simple Matches in the Data Set with re()
    * Accounting For Inconsistencies > Using Square Brackets to Match Multiple Characters
    * Escaping Special Characters > (unchanged)
    * Refining The Search > Combining Escaped Characters and Multiple Matches
    * More Inconsistency > Adding more complexity to your Regular Expression
    * Multiple Regular Expressions > Combining Multiple Regular Expressions
    * Substituting Strings > Using Regular Expressions to Substitute Strings
    * Matching Years > Matching Years with Regular Expressions
    * Repeating Regular Expressions > Repeating Characters in Regular Expressions
    * Extracting Years > Challenge: Extracting all Years

## Hints

* Avoid using $ and MathJax in Hints (bug that prevents it from rendering properly)

## Writing Patterns / Anti-Patterns

* References to:
    * GitHub
    * Packages/stand-alone modules
        * plain-text, official capitalization, link to project home page
            * pandas
            * matplotlib
            * NumPy
            * SQLite
            * Python
            * IPython
            * Scikit-learn
            * Basemap
    * Data structures
        * dataframe
        * series
        * Arrays
        * Matrices
        * Indexes
        * Boolean
    * Operating systems
        * UNIX
        * Linux
        * OS X
    * Other
        * object-oriented programming
        * command-line (adjective)
        * command line (noun)
        * Bash (capitalize first letter)
    * Specific modules inside packages, classes
        * On first reference, fully qualified path enclosed in backticks, linked directly to the relevant location in the official docs, as specific as possible, e.g., [`pandas.DataFrame`](http://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.html)
        * On further references, no link
        * For classes, after first reference use just the class name, e.g., `DataFrame`
    * Functions and methods
        * Same as packages/classes, except they must always specify their parent module/package if no more than one layer deep, e.g., on first reference `numpy.cov()`, then `np.cov()` afterwards. For something nested further, such as `numpy.polynomial.polynomial.polyfit()`, after first reference just `polyfit()` will suffice.
        * Require trailing empty parentheses for functions & methods to indicate that they’re callable
            * Use **pandas.to_datetime()** to convert ...
            * Use **DataFrame.head() **to display the first 5 rows ..
            * Use the **Axes.set_xlabel() **method to set the label for the x-axis ..
        * A function "accepts" parameters, instead of “taking them in.”
* In prose, references and code style should match context
    * "Create a `Series` with…" vs “Our series spans three years”
    * "Make a histogram with 20 bins" vs “Make a histogram and set `bins=20`”
* Use the serial comma
* Avoid using Mathjax in hints (bug that prevents proper rendering)
* Avoid using terms that have technical meaning in prose:
    * Method
        * ~~"We can use this method to specify as many *key/value* pairs as we’d like"~~
* Numbers (One vs 1)
    * Single-digit integers are written out: zero, one, five, nine, but 10, 11, 15, 100
        * Exceptions: ages, dates, times always use numerals
    * All others make use of numerals
    * Decimals must always have leading zeroes: 0.123 *not* .123
* "Data" is the plural form of “datum”
    * "These data are…" not “This data is…”
    * "Many of the data…" not “Much of the data…”
* Capitalization of content headings
    * Step, course, and mission names in title case
    * Screen names in sentence case (actually, it looks like dsserver forces title case for these, which is not good because Python doesn’t know not to capitalize prepositions and articles)
* Quotation marks in code
    * For messages, sentences and clauses, use double quotes
    * Everything else, like column names and dictionary keys, use single
* Use one space after periods instead of two spaces after periods.
* Indexes vs indices
    * For list/array slicing and access, use "indices"
    * For databases, use "indexes"
* Since vs. Because
    * Only use since to refer to time ("I lost five pounds since the last party")
    * Don’t use it for cause and effect ("I lost five pounds *because* I’ve been working out")
* "Data set" not “dataset”
* New terms/definitions in bold, with links to Wikipedia page
    * If the page URL has a closing paren that messes with Markdown’s syntax, replace it with %29 (although this is still rendered improperly in our UI--see [https://www.pivotaltracker.com/story/show/132109339](https://www.pivotaltracker.com/story/show/132109339))
* When creating a **list:**
    * ", as a string" —> “(as a string)"
        * the name of the file, as a _string_
        * the name of the file (as a _string_)
        * the mode of working with the file, as a _string_
        * the mode of working with the file (as a _string_)
    * Don’t include periods at the end of list items/bullet points, unless the text in that bullet point contains a complete sentence.
    * Capitalize the first letter in each bullet point, unless it’s part of a function, variable, or method name that should remain lowercase.
* Instead of an object "containing" methods, it just “has” them
    * A Figure contains methods that … —> A Figure has methods that... 
* Capitalize all major words in a heading
* Use "code above" or “example above”, rather than “above code”. It flows/sounds better.
* Use "check whether" instead of “check if” or “check to see if”
* Capitalize CSV, unless it’s a variable name, fuPnction, method, or other piece of code.
* "Use" instead of “utilize.”
* Avoid starting sentences with "As you can see,".  Generally this phrase doesn't add much -
 dropping these three words makes the writing more direct.
* Avoid using generic words like "making". E.g. "making comments", "making calculations". Specific is almost always better "creating comments", "adding comments", "performing calculations"