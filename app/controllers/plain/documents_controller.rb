module Plain
  class DocumentsController < ApplicationController

    def new
      @conversation = Conversation.find(params[:conversation_id])
      @message = @conversation.messages.find(params[:message_id])
      @document = Document.new
      @document.content = @message.content
    end

    def create
      @conversation = Conversation.find(params[:conversation_id])
      @message = @conversation.messages.find(params[:message_id])

      @document = Document.new(document_params)
      @document.content = @message.content
      if @document.save
        @docs_structure = DocsService.get_structure
      end
    end

    private

    def document_params
      params.require(:document).permit(:title, :content, :path)
    end
  end
end
