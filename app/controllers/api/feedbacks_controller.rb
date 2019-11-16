module Api
  class FeedbacksController < ApplicationController
    def create
      # TODO: replace log with feedback handling
      logger.info "received feedback from #{params[:name].inspect}: #{params[:comments].inspect}"
      head :ok
    end
  end
end
