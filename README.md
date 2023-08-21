# What is this Ruby on Plan rails engine

Plain is a Rails engine that serves as an Artificial Intelligence (AI) assistant for your Rails project. It's not just about organizing your codes or managing your project structure, but about providing deeper, more meaningful context to your work, in real-time. It was proudly developed and presented during the esteemed Rails Hackathon 2023.

*This is an example of plain operating in Rauversion project*

https://github.com/chaskiq/plain/assets/11976/87f0d62d-d63a-45d9-91e2-b8878542c4ee

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "plain-rails"
```

or development version

```ruby
gem "plain-rails", github: "chaskiq/plain", branch: "main"
```

### Overview

Plain is a Rails engine that serves as an Artificial Intelligence (AI) assistant for your Rails project. It's not just about organizing your codes or managing your project structure, but about providing deeper, more meaningful context to your work, in real-time. It was proudly developed and presented during the esteemed Rails Hackathon 2023. Special Kudos to [@claunicole](https://github.com/claunicole), [@silva96](https://github.com/silva96)


### Functionality

The most salient feature of Plain is its capability to analyze your project on the go. Using AI, it can instantly provide explanations and insights about various aspects of your Rails project, effectively becoming an intelligent companion during your development process.


### Documentation Site 


Beyond just an AI assistant, Plain acts as a comprehensive documentation site. What sets Plain apart is its ability to take markdown files and seamlessly integrate them into the documentation site. No more disjointed files and folders, everything is displayed on a beautifully designed, user-friendly site. This enables developers to add, modify, or access documentation effortlessly and intuitively.


## Getting started

### Install Migrations:

`rails plain:install:migrations`

### Configuration:

put this in an config/initializers , config/initializers/plain.rb

```ruby
Plain.configure do |config|
  config.paths = [
    Rails.root.join("Gemfile"), 
    Rails.root.join("app/models"), 
    Rails.root.join("app/controllers"), 
    Rails.root.join("spec")
  ]
  config.extensions = ["rb", "js", "md", "json", "erb"]
  config.chat_environments = [:development]

  # initialize your vector search
  config.vector_search = Langchain::Vectorsearch::Qdrant.new(
    url: ENV["QDRANT_URL"],
    api_key: ENV["QDRANT_API_KEY"],
    index_name: ENV["QDRANT_INDEX"],
    llm: Langchain::LLM::OpenAI.new(
      api_key: ENV["OPENAI_API_KEY"],
      llm_options: {},
      default_options: {
        chat_completion_model_name: "gpt-3.5-turbo-16k"
      }
    )
  )
end
```

For other vector search please refer to langchainrb repo https://github.com/andreibondarev/langchainrb#using-vector-search-databases-

Some environment configuration variables are required:

```bash
QDRANT_URL = 
QDRANT_API_KEY = 
QDRANT_INDEX = 
OPENAI_API_KEY =
```

You can get a free account on the https://qdrant.tech/ there will be more providers to connect soon.

### Load information to Index:

`rails plain:load`   

### Mount Doc site:

in config/routes.rb mount the engine:

`mount Plain::Engine => "/plain"`

in app/assets/config/manifest.js

add 

```js
//= link plain.css
```


## Documentation site.

Plain provides a documentation site that can be populated via markdown files with front-matter support, how it works.

Place your markdowns on a `docs` folder on your project's root. also you can add a main configuration file, for example: 

![Screen Shot 2023-08-17 at 10 54 14 PM](https://github.com/chaskiq/plain/assets/11976/0dee77c6-9cb7-489e-8521-3c870952861c)


### Documentation side main config

Put this on /docs/config.yml

```yaml
name: "Rauversion docs"
logo: "logo.png"
chat_envs: 
  - "development"
  - "test"
links:
  -
    name: "Start us on github"
    url: "https://github.com/xxx/rxxx
  - 
    name: "X"
    url: "https://x.com/xxx"
footer:
  legend: "xxxx © Copyright 2023 . All rights reserved."
  links:
    - 
      name: "Twitter / X"
      url: "https://twitter.com/xxx"
    - 
      name: "IG"
      url: "https://instagram.com/xxx"
sections:
  - 
    name: "getting_started"
    position: 1
    items:
      - 
        name: "oli"
        path: "aaa"
        description: "hello there"
```


### Development:

`bin/rails plain:tailwind_engine_watch --trace`


License: MIT