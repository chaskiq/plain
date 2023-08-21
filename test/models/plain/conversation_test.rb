require "test_helper"

module Plain
  class ConversationTest < ActiveSupport::TestCase
    test 'plain conversation has many plain messages' do
      plain_conversation = Plain::Conversation.create!(subject: 'Test Conversation')
      plain_message1 = Plain::Message.create!(content: 'Test Message 1', conversation: plain_conversation)
      plain_message2 = Plain::Message.create!(content: 'Test Message 2', conversation: plain_conversation)
  
      assert_equal 2, plain_conversation.messages.count
      assert_includes plain_conversation.messages, plain_message1
      assert_includes plain_conversation.messages, plain_message2
    end

  end
end
