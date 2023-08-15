module Plain
  class MessagesController < ApplicationController
    layout false
    skip_before_action :verify_authenticity_token

    PER_PAGE = 10
    layout false

    def index
      @conversation = Plain::Conversation.find(params[:conversation_id])
      @current_page = params[:page].to_i
      @next_page = @current_page + 1
      @messages = @conversation.messages.limit(PER_PAGE).offset(@current_page * PER_PAGE).order(created_at: :desc)
    end

    def new
      @conversation = Plain::Conversation.find(params[:conversation_id])
      @message = @conversation.messages.new
    end

    def create
      @conversation = Plain::Conversation.find(params[:conversation_id])
      @question = params[:message][:content]
      @conversation.messages.create(role: "user", content: @question)
      @conversation.add_assistant_response_async(@question)
    end

  end

end
