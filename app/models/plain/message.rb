require 'fileutils'

module Plain
  class Message < ApplicationRecord
    belongs_to :conversation, foreign_key: :plain_conversation_id

    after_create_commit -> {
      broadcast_render_to(
        self.conversation,
        partial: "plain/messages/new_message",
        locals: {message: self}
      )
      broadcast_update_to(
        self.conversation,
        target: "message-form",
        partial: "plain/messages/form",
        locals: {message: self, conversation: self.conversation}
      )
    }

    after_update_commit -> {
      broadcast_replace_to(
        self.conversation,
        target: "message-item-#{id}",
        partial: "plain/messages/message_item",
        locals: { message: self, scroll: true }
      )
    }

    def assistant?
      role == "assistant"
    end

    def persist_as_document(path)
      # Remove starting '/' if present
      path = path.sub(/\A\//, '')

      # Add '.md' extension if it's not already present
      path += '.md' unless path.end_with?('.md')

      # Construct the full path to the desired file
      full_path = Rails.root.join('docs', path)

      # Create the directory path, unless it already exists
      dirname = File.dirname(full_path)
      FileUtils.mkdir_p(dirname) unless File.directory?(dirname)

      # Write content from self.body to the file, unless it already exists
      File.write(full_path, self.content) unless File.exist?(full_path)
    end

  end
end
