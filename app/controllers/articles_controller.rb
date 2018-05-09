class ArticlesController < ApplicationController
  before_action :authenticate_autor!, except: %i[index show]
  before_action :authenticate_user!, only: [:show]
  def index
    @articles = Article.when_published
  end

  def show
    flash.now[:alert] = 'you are '+"#{current_user.name || current_user.id}"
    @article = Article.find(params[:id])
  end

  def new; end

  def create
    @autor = current_autor
    @article = @autor.articles.create(article_params)
    redirect_to autors_for_autor_path if @article.save!
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if current_autor.id == @article.autor_id
      if @article.update(article_params)
        redirect_to articles_path
      else
        render 'edit'
      end
    else render plain: "article can change only its autor or admin"
    end
  end

  def destroy
    @article = Article.find(params[:id])
    if current_autor.id == @article.autor_id
      @article.destroy
      redirect_to articles_path
    else render plain: "article can destroy only its autor or admin"
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :published_at, :published, :category_id)
  end
end
