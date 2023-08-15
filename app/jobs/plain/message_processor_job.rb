module Plain
  class MessageProcessorJob < ApplicationJob
    queue_as :default

    def perform(conversation, question: )
      conversation.add_assistant_response(question)
    end
  end
end
