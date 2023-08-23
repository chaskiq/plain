---
title: Embed Widget
layout: post
menu_position: 2
---


# Embedding Documentation: Plain

---

Plain provides multiple options for embedding its documentation. Choose the method that best suits your needs.

---

## 1. Using an iframe to embed from outside

Embed the documentation on your webpage using an iframe. Replace `<your_URL>` with the actual URL of the page you'd like to embed.

```html
<iframe src="<your_URL>/embed" width="100%" height="500px"></iframe>
```

---

## 2. Using a Turbo Frame with Rails

Embed the documentation in your Rails application using a Turbo Frame. Turbo Frames allow you to update a part of the page without a full page reload.

```html
<a href="/plain" data-turbo-frame="plain">Plain Documentation</a>
```

---

## 3. Including JavaScript with Rails

You can also include the Plain widget in your Rails application using JavaScript. 

First, add this line to your Rails layout view:

```html
<%= javascript_include_tag "baseWidget" %>
```

Then, insert the following script in your HTML:

```html
<!-- Plain badge widget begin -->
<!--
<link href="https://assets.Plain.com/assets/external/widget.css" rel="stylesheet">
<script src="https://assets.Plain.com/assets/external/widget.js" type="text/javascript" async>
</script>
-->
<script type="text/javascript">
  window.onload = function() { 
    Plain.initPopupWidget({
      "url":"<%= plain.conversations_url %>?embed=true",
      "text":"Ai assistant",
      "color":"#0069ff",
      "textColor":"#ffffff",
      "branding":true
    }); 
  }
</script>
```

This code will load the Plain widget when your page loads. The widget opens a popup that displays the Plain AI assistant.

---

Using these methods, you can seamlessly embed Plain's AI-powered Rails engine and its interactive documentation into your website or application.