module Plain
  class HomeController < ApplicationController

    def index
      @conversations = Plain::Conversation
      .order(pinned: :desc, pinned_at: :asc, created_at: :desc)
      .limit(12)
    end
  end
end
