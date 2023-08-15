module Plain
  class Conversation < ApplicationRecord
    has_many :messages, foreign_key: "plain_conversation_id", dependent: :destroy
  
    def add_assistant_response(question)
      ai_docs = Plain::AiDocs.new
      vector_search = ai_docs.client
      complete_response = ""

      message = messages.new(role: "assistant", content: "")

      chat = Plain::AiDocs.new.conversation_client do |chunk|
        #puts "chunk"
        puts chunk
        next if chunk["choices"].blank?
        chunk["choices"].each do |choice|
          next unless choice["delta"]["content"].present?
          complete_response << choice["delta"]["content"]
          message.content = complete_response
          message.save
        end
      end

      # plain_answer = vector_search.ask(question: @question)
      search_results = vector_search.similarity_search(query: question)

      context = search_results.map do |result|
        result.dig("payload", "content").to_s
      end

      plain_answer = context.join("\n---\n")

      chat.add_examples(messages) if messages.any?
      Plain::AiDocs.set_conversation_title(self) if messages.size >= 4 && subject.blank?

      puts "CONTEXT"
      context = "The following is the context of my application, please respond accordingly with this context: \r\n" <<  plain_answer << "end of context"
      puts context

      chat.set_context(context)
      # chat.set_functions(Plain::AiDocs.functions())
      chat.message(question)
    end

    def add_assistant_response_async(question)
      Plain::MessageProcessorJob.perform_later(self, question: question)
    end

    def add_subject_from_summary
      Plain::AiDocs.set_conversation_title(self)
    end
  
  end
end
