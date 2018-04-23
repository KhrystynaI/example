class AutorsController < ApplicationController
  before_action :authenticate_autor!
  def for_autor
    @autor = current_autor
    @articles = @autor.articles.all
    render '/autors/for_autor'
  end

end
