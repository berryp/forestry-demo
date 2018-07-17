---
title: CSS for images
---

There are some optional CSS classes available for styling images within content:

- `size_55_center` - 55% of the available width, centered
- `size_55_left` - 55% of the available width, left-aligned
- `size_33_center`- 33% of the available width, centered
- `size_33_left`- 33% of the available width, left-aligned

These can be useful for controlling the image size, especially on text screens which are twice as wide as code screens.

The syntax is:

```html
<div class="size_55_center">
  <img src='filename.svg' alt='Alt Text Goes Here' />
</div>
```

The diagram below provides a visual representation of the different options:

![images.svg](../images/images.svg)