module Langchain
  module Processors
    class RB < Langchain::Processors::Base
      EXTENSIONS = [".rb", ".js", ".erb", ".md", ".gemspec"]
      CONTENT_TYPES = ["text/plain"]

      # Parse the document and return the text
      # @param [File] data
      # @return [String]
      def parse(data)
        data.read
      end
    end

    class JS < Langchain::Processors::Base
      EXTENSIONS = [".js", ".tsx", ".jsx"]
      CONTENT_TYPES = ["application/javascript"]

      # Parse the document and return the text
      # @param [File] data
      # @return [Hash]
      def parse(data)
        data.read
      end
    end

    class JSON < Langchain::Processors::Base
      EXTENSIONS = [".json"]
      CONTENT_TYPES = ["application/json"]

      # Parse the document and return the text
      # @param [File] data
      # @return [Hash]
      def parse(data)
        data.read
      end
    end
  end

end

module Plain
  class Markdownray < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code, language).div rescue "xxx"
    end
  end

  class AiDocs

    def conversation_client(&block)
      llm = Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"], default_options: {
        #chat_completion_model_name: "gpt-3.5-turbo-16k"
        chat_completion_model_name: "gpt-4"
      })
      llm.complete_response = true
      # refactor this
      if block_given?
        @conversation_client = Langchain::Conversation.new(llm: llm) do |chunk|
          yield chunk 
        end
      else
        @conversation_client = Langchain::Conversation.new(llm: llm)
      end
    end

    def client
      @client ||= Langchain::Vectorsearch::Qdrant.new(
        url: ENV["QDRANT_URL"],
        api_key: ENV["QDRANT_API_KEY"],
        index_name: ENV["QDRANT_INDEX"],
        #environment: ENV['PINECONE_ENVIRONMENT'],
        llm: Langchain::LLM::OpenAI.new(
          api_key: ENV["OPENAI_API_KEY"],
          llm_options: {},
          default_options: {
            chat_completion_model_name: "gpt-3.5-turbo-16k"
          }
        )
      )
    end

    def self.set_conversation_title(conversation)
      chat = Plain::AiDocs.new.conversation_client
      chat.add_examples(conversation.messages)
      title = chat.message("from the whole conversation please summarize it 4 words")
      if title.is_a?(Hash)
        title =  title["choices"].map{|o| o["message"]["content"]}.join("") rescue "no subject"
      end
      puts "TITLE: #{title}"
      conversation.update(subject: title)
    end

    def load_all
      client.create_default_schema

      load_plain_docs
      # load_manifests
      load_models
      load_controllers
      # load_views
      load_jobs
      load_mailers
      load_services
      load_specs
      load_javascripts
      load_db_schema
      load_configs
    end

    def load_models
      load_app_paths('app', 'models', '**', '*.rb')
    end

    def load_controllers
      load_app_paths('app', 'controllers', '**', '*.rb')
    end

    def load_views
      load_app_paths('app', 'views', '**', '*.erb')
    end

    def load_jobs
      load_app_paths('app', 'jobs', '**', '*.rb')
    end

    def load_mailers
      load_app_paths('app', 'mailers', '**', '*.rb')
    end

    def load_services
      load_app_paths('app', 'services', '**', '*.rb')
    end

    def load_specs
      load_app_paths('spec', '**', '*.rb')
    end

    def load_javascripts
      load_app_paths('app', 'javascript', '**', '*.js')
    end

    def load_db_schema
      load_app_paths('db', '**', '*.rb')
    end

    def load_configs
      load_app_paths('config', 'initializers', '**', '*.rb')
      load_app_paths('config', 'environments', '**', '*.rb')
    end

    def load_plain_engine
      load_app_paths('plain', '**', '*.rb')
      load_app_paths('plain', '**', '*.erb')
      load_app_paths('plain', '*.md')
    end

    def load_plain_docs
      load_app_paths('*.md')
      load_app_paths('docs', '**', '*.md')
    end

    def load_manifests
      # load_app_paths('plain', '*.md')
      # load_app_paths('Gemfile')
      load_app_paths('package.json')
      #load_app_paths('plain', 'plain.gemspec')
    end

    def load_app_paths(*paths)
      files = Dir[Rails.root.join(*paths)]
      client.add_data(paths: files) if files.any?
    end

    def self.convert_markdown(text)
      rndr = Markdownray.new(filter_html: true, hard_wrap: true)
      options = {
        fenced_code_blocks: true,
        no_intra_emphasis: true,
        autolink: true,
        lax_html_blocks: true
      }
      # markdown_to_html = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
      markdown_to_html = Redcarpet::Markdown.new(rndr, options)
      markdown_to_html.render(text) #rescue nil
    end

    def self.create_file_with_path(path, content)
      # Sanitize the path by replacing spaces with underscores and removing unsafe characters
      sanitized_path = path.strip.gsub(/[^0-9A-Za-z\/]/, '').gsub(/\s+/, '_')

      # Create the full path, joining the Rails root directory, "app/docs", and the sanitized path
      full_path = Rails.root.join("app/views/docs", sanitized_path)

      # Create directories for the path if they don't exist
      FileUtils.mkdir_p(File.dirname(full_path))

      # Create the file and write content to it
      File.write(full_path, content)
    end

    def self.functions
      [
        {
          name: "create_rails_controller",
          description: "gives a command to create a rails controller",
          parameters: {
            type: :object,
            properties: {
              controller_name: {
                type: :string,
                description: "the controller name, e.g. users_controller"
              },
              unit: {
                type: "string",
                enum: %w[celsius fahrenheit]
              }
            },
            required: ["controller_name"]
          }
        }
      ]
    end

  end

end
