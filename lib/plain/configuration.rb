module Plain
  class Configuration
    attr_accessor :paths, :chat_environments, :vector_search, :extensions

    def initialize
      @paths = []
      @chat_environments = []
      @vector_search = nil
      @extensions = ["rb", "js", "erb", "md", "json"]
    end
  end
end