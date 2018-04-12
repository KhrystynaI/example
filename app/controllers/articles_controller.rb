class ArticlesController < ApplicationController
  before_action :authenticate_autor!, except: [:index, :show]
  before_action :authenticate_user!, only: [:show]
  def index
    @articles = Article.all
  end

  def show
    flash.now[:alert] = 'you are user'
    @article = Article.find(params[:id])
  end

  def new

  end

  def create
    @autor = current_autor
    @article = @autor.articles.create(article_params)
    if @article.save
      redirect_to articles_path
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
      params.require(:article).permit(:title, :body)
    end
end
