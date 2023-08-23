---
title: Plain Config
menu_position: 
---

# Plain config

The `Plain::Configuration` class is a simple configuration class used to set up the Plain module. It has four attributes: `paths`, `chat_environments`, `vector_search`, and `extensions`.

Here's a brief overview of each attribute:

1. `paths`: This is an array that is initialized as empty. Its purpose isn't clear from the provided context, but it might be used to store paths to certain files or directories.

2. `chat_environments`: This is also an array that is initialized as empty. Its purpose isn't clear from the provided context, but it might be used to store different chat environments.

3. `vector_search`: This is initialized as `nil`. Its purpose isn't clear from the provided context, but it might be used to enable or configure vector search functionality.

4. `extensions`: This is an array that is initialized with the values "rb", "js", "erb", "md", "json". These are file extensions, suggesting that this attribute is used to specify which file types the Plain module should work with.

The `Plain` module itself has a `configuration` method that initializes a new `Plain::Configuration` object if one doesn't already exist, and a `configure` method that yields the configuration object, allowing you to set its attributes. This is a common pattern for configuring modules or classes in Ruby.