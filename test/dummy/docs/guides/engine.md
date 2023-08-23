---
title: Geting started with Plain engine
layout: post
menu_position: 1
---


# Plain Rails Engine Documentation

---

## Installation and Setup

### Adding Required Gems

To start using Plain Rails engine, you need to add it and its dependencies to your project's Gemfile. Below are the gems required:

```ruby
gem 'plain', path: 'plain'
gem "sidekiq", "~> 7.1"
gem "ruby-openai", "~> 4.2"
gem "qdrant-ruby", "~> 0.9.2"
```

After adding the gems, run the following command in your terminal to install them:

```bash
bundle install
```

### Migrations

Plain needs its database tables to function correctly. To create these tables, run the following command in your terminal:

```bash
rails plain:install:migrations
```

Then, migrate the database:

```bash
rails db:migrate
```

### Indexing Your Repo

Once you have installed the necessary gems and run the migrations, you need to load your repository into the Plain engine's database. This operation will index your repo on the database vector and make it searchable by the Plain engine.

Run the following command in your terminal to perform the indexing:

```bash
rails plain:load
```

---

Congratulations! You have successfully set up the Plain Rails engine for your Rails project. Now, you can leverage Plain's capabilities to provide real-time context and insight into your project, as well as an integrated documentation site that displays your markdown files elegantly.