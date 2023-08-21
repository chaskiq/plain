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
      CodeRay.scan(code, language).div() rescue "xxx"
    end
  end

  class AiDocs

    def conversation_client(&block)
      llm = Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"], default_options: {
        #chat_completion_model_name: "gpt-3.5-turbo-16k"
        chat_completion_model_name: "gpt-4"
      })
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
      @client ||= Plain.configuration.vector_search
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
      load_configuration_paths
    end

    def load_configuration_paths
      # Distinguishing files from directories
      files_without_extension, directories = Plain.configuration.paths.partition { |path| File.file?(path) }

      # Getting files from directories based on the allowed extensions
      files_with_extension = directories.flat_map do |dir|
        Dir[File.join(dir, "*.{#{Plain.configuration.extensions.join(',')}}")]
      end

      puts "FILES WITH EXTENSIONS"
      puts files_with_extension
      # Add files with extensions to the client
      client.add_data(paths: files_with_extension)

      puts "FILES WITHOUT EXTENSIONS"
      puts files_with_extension
      # Process files without extensions
      files_without_extension.each do |file|
        content = File.read(file)
        #texts = Langchain::Chunker::Text.new(content).chunks
        client.add_texts(texts: content)
      end

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
