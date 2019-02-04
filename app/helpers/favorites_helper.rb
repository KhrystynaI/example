module FavoritesHelper
  def favorite_text
    return @favorite_exists ? fa_icon('thumbs-down') : fa_icon('thumbs-up')
  end
end
