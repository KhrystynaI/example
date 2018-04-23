class ArticlesController < ApplicationController
  before_action :authenticate_autor!, except: [:index, :show]
  before_action :authenticate_user!, only: [:show]
  def index
    @articles = Article.when_published
  end

  def show
    flash.now[:alert] = 'you are user'
    @article = Article.find(params[:id])
  end

  def new

  end

  def create
    @autor = current_autor
    @article = @autor.articles.build(article_params)
    if @article.save!
      redirect_to autors_for_autor_path
    end
end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to articles_path
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to articles_path
  end

  private
  def article_params
    params.require(:article).permit(:title, :body, :published_at, :published, :category_id)
  end

end
