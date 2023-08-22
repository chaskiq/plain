require "openai"
require "qdrant"
require "langchainrb"
# require "coderay"
require "redcarpet"

module Plain
  class Engine < ::Rails::Engine
    isolate_namespace Plain

    # NOTE: add engine manifest to precompile assets in production, if you don't have this yet.
    initializer "plain.assets" do |app|
      app.config.assets.precompile += %w[plain_manifest]
    end
  end
end
