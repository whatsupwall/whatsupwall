class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to walls_url
    end
  end
end
