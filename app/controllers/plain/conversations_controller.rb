module Plain
  class ConversationsController < ApplicationController
    PER_PAGE = 10

    layout "plain/application"

    skip_before_action :verify_authenticity_token

    before_action :allow_iframe_requests #, only: [:index, :create]

    def allow_iframe_requests
      response.headers.delete("X-Frame-Options")
    end

    def index
      @needs_back = true
      @conversations = Plain::Conversation.all

      if @conversations.empty?
        Plain::Conversation.create
      end

      @current_page = params[:page].to_i
      @next_page = @current_page + 1
      @conversations = Plain::Conversation.limit(PER_PAGE)
                                   .offset(@current_page * PER_PAGE)
                                   .order(pinned: :desc, pinned_at: :asc, created_at: :desc)
    end

    def show
      @conversation = Plain::Conversation.find(params[:id])
    end

    def new
      @conversation = Plain::Conversation.create
      redirect_to conversation_path(@conversation)
    end

    def edit
      @conversation = Plain::Conversation.find(params[:id])
    end

    def update
      @conversation = Plain::Conversation.find(params[:id])
    end

    def destroy
      @conversation = Plain::Conversation.find(params[:id])
      @conversation.destroy
    end

    def pin
      @conversation = Plain::Conversation.find(params[:id])
      new_state = !@conversation.pinned?
      @conversation.update(pinned: new_state, pinned_at: new_state ? Time.zone.now : nil )
    end

  end
end
