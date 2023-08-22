require_relative "lib/plain/version"

Gem::Specification.new do |spec|
  spec.name        = "plain-rails"
  spec.version     = Plain::VERSION
  spec.authors     = ["Miguel Michelson"]
  spec.email       = ["miguelmichelson@gmail.com"]
  spec.homepage    = "https://github.com/chaskiq/plain"
  spec.summary     = "Plain is an AI and documentation system for rails apps."
  spec.description = "Plain is an AI and documentation system for rails apps."

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.6"

  spec.add_dependency "langchainrb", "~> 0.6.12"
  spec.add_dependency "ruby-openai", "~> 4.2"
  spec.add_dependency "qdrant-ruby", "~> 0.9.2"
  # spec.add_dependency "coderay", "~> 1.1"
  # spec.add_dependency "redcarpet", "~> 2.3.0"
  spec.add_dependency "front_matter_parser", "~> 1.0.1"
  # spec.add_dependency "tailwindcss-rails"
end
