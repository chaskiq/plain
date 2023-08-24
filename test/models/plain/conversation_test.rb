require "test_helper"
require 'mocha/minitest'

class DummyVector
  def similarity_search(query:)
    
  end
end

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

    test 'add_assistant_response generates a response based on the question' do
      plain_conversation = Plain::Conversation.create!(subject: 'Test Conversation')

      # Create a mock conversation client
      mock_conversation_client = mock('conversation_client')
      mock_vector_search = mock('vector_search')

      mock_conversation_client.stubs(:add_examples)
      mock_conversation_client.stubs(:set_context)
      mock_conversation_client.stubs(:message).returns('Test Response')

      mock_vector_search.stubs(:similarity_search).returns([{"payload"=>{"content"=> "THIS IS THE CONTEXT"}}])

      # Stub the Plain::AiDocs.new.conversation_client method to return the mock client
      ai_docs = Plain::AiDocs.new
      ai_docs.stubs(:conversation_client).returns(mock_conversation_client)
      ai_docs.stubs(:client).returns(mock_vector_search)
      Plain::AiDocs.stubs(:new).returns(ai_docs)

      plain_conversation.add_assistant_response('Test Question')

      # assert_equal 'Test Response', plain_conversation.messages.first.content
    end

  end
end
