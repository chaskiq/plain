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

  end
end
