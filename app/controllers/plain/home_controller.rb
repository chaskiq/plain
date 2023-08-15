module Plain
  class HomeController < ApplicationController

    def index
      @conversations = Plain::Conversation
      .order(pinned_at: :asc, created_at: :desc)
      .limit(4)
    end
  end
end
