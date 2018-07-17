---
title: Contribution guide
---

**<< WIP: This document is work in progress and subject to change >>**

The content for this site is written in [Markdown](https://daringfireball.net/projects/markdown/syntax)
syntax and and compiled to a static site using [Hugo](https://gohugo.io/).

I won't go into much detail on the specifcs of Markdown or Hugo, as you find find
everything you will need on their websites (and others). I will, however, run
through the basics of the repository, creating new content, and running the site.

## The repository

The repository contains not only the content, but everything required to build, deploy and run the site.
For the most part you'll be interested in the `content` directory. This is where regular content (or pages)
is stored. If, in the future, we decided to run an internal blog using this repo then you will also see
a `posts` directory. But for now, we'll only curate regular content here.

### Structure

The content directory is organised pretty much as you want it to appear in the website. Here's an adapted
example from Hugo's website illustrating this point:

```
.
└── content
    └── content
    |   ├── _index.md          // <- https://docs.dataquest.io/content/
    |   ├── course-testing.md  // <- https://docs.dataquest.io/content/course-testing/
    |   └── installation.md    // <- https://docs.dataquest.io/post/installation/
    ├── devops
    |   └── instructions
    |       └── gitlab.md      // <- https://docs.dataquest.io/devops/instructions/gitlab/
    ├── _index.md              // <- https://docs.dataquest.io/
    └── contribution.md        // <- https://docs.dataquest.io/contribution/
```

You should get a good feel for this just by browsing the `content` directory in this repo.

It's important to note that "index" files are named `_index.md`.

### Writing content

All content is written in standard Markdown - however, Hugo does provide some extentions to the syntax (see the website for more info on those). You create a content page just like any other markdown file,
with the exception of metadata, which Hugo calls "front matter". This is a little bit of YAML embedded
at the top of the file that gives various instructions to Hugo when building the file.

For example:

```
---
title: Content issues and bugs
---

Because content errors and bugs are often small in scope...

```

Usually, just the title will be used. But there are also times you will want to use additional
configuration. Such as changing the slug, or adding a timestamp.

### Linking to media.

It's very likely that you will want to link to other pages on the site, or add images to your content
at some point. It's really important, here, to understand how URLs are generated from the content and
how to relatively link to pages.

As illustrated in the previous structure example the URL for every content page is it's path in the directory structure. So the file `content/content/course-testing.md` would have a URL of
`/content/course-testing/`.

If we want to link to this page from the file `content/content/installation.md` we need to remember
that `course-testing` and `installation` are at the same level in the tree, so the link will be
`../course-testing`.

For example:

```
[Course testing](../course-testing/)
```

#### Images

If you want to use media such as images and SVG in your pages then you will want an `images`
sub-directory under the content file's location. Then, you can use standard Markdown image
syntax to embed an image.

```
![Bundles example](../images/bundles-example.png)
```

![Bundles example](../images/bundles-example.png)

Now, you'll see that the `images` relative path doesn't seem to match up with the location of our
content file. This is for the same reason as hyperlinking, mentioned above. The `images` directory
is one level lower than your content page after building.
