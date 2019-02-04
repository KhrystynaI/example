class WelcomeController < ApplicationController
layout "welcome"
  def index
    @article = Article.published
  end
end
