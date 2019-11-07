class LandingController < ApplicationController
  def home
    @images = Image.order created_at: :desc
  end
end
