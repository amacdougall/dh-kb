class HomeController < ApplicationController
  def index
    session[:authenticated] = true if params[:password] == "rubylith"
  end
end
