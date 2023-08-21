Plain.configure do |config|
  config.paths = [
    Rails.root.join("Gemfile"), 
    Rails.root.join("app/models"), 
    Rails.root.join("app/controllers"), 
    Rails.root.join("spec"),
    Plain::Engine.root.join("test"),
    Plain::Engine.root.join("Gemfile"),
    Plain::Engine.root.join("app"),
    Plain::Engine.root.join("README.md"),
    Plain::Engine.root.join("tailwind.config.js")
  ]
  config.extensions = ["rb", "js", "md", "json", "erb"]
  config.chat_environments = [:development]
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