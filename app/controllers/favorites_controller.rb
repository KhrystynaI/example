class FavoritesController < ApplicationController

  def update
    favorite = Favorite.where(article: Article.find(params[:article]), user: current_user)
    if favorite == []
      Favorite.create(article: Article.find(params[:article]), user: current_user)
      @favorite_exists = true
      @favorite_gritter = "Add this to favorites"
    else
      favorite.destroy_all
      @favorite_exists = false
      @favorite_gritter = "Remove this from favorites"
    end

    respond_to do |format|
      format.html
      format.js
  end
end
end
