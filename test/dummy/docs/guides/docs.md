---
title: Documentation engine
layout: post
menu_position: 4
---


# Documentation Engine Guide

---

Welcome to the Plain Documentation Engine Guide. The documentation engine allows you to organize and display your project's markdown documentation files elegantly. Let's walk through the steps to set up and use the documentation engine in your Rails app.

---

## Step 1: Add Docs

Add your documentation markdown files into the `/docs` directory of your Rails application. 

## Step 2: Use Front-Matter

Use front-matter at the beginning of your markdown files to organize the metadata. Here's an example of how it should look:

```markdown
---
title: Documentation engine
layout: post
menu_position: 1
---
```

In this example:

- `title` sets the title of the documentation page.
- `layout` determines the layout that will be used to render the page.
- `menu_position` determines the position of the page in the menu. Pages with lower numbers will appear before pages with higher numbers.

## Step 3: Configure Main Sections

Create a `config.yml` file inside your `/docs` directory to configure the main sections of your documentation site. Here's an example of what this file might look like:

```yaml
sections:
  - 
    name: "Guides"
    position: 1
    items:
      - 
        name: "oli"
        path: "aaa"
        description: "hello there"
      - 
        name: "oli2"
        path: "bbb"
        description: "hello foo"
```

In this example:

- `sections` is a list of your main documentation sections.
- Each section has a `name`, which is the displayed name of the section; a `position`, which determines the order of the sections; and `items`, which are the pages inside the section.
- Each item has a `name`, which is the displayed name of the page; a `path`, which is the path to the page's markdown file (relative to the `/docs` directory); and a `description`, which is a brief summary of the page.

---

That's it! You now know how to use the Plain Documentation Engine. Start creating and organizing your markdown documentation files and enjoy your beautifully rendered documentation site.