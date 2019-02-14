class ArticlesController < ApplicationController
  layout :layout
  before_action :authenticate_autor!, except: %i[index show sort]
  before_action :authenticate_user!, only: [:show, :index, :sort]

  def index
    #flash.now[:alert] = "Hello, #{current_user.user_name}"
    @article = Article.published.order(:position).paginate(page: params[:page])
  end

def index_for_autor
  #flash.now[:alert] = "Hello, #{current_autor.autor_name}"
  @autor = current_autor
  @article = @autor.articles.order("created_at DESC").paginate(page: params[:page])
  @messages = Message.last(10)
  @message = Message.new
end

  def show
    @article = Article.find(params[:id])
    @favorite_exists = Favorite.where(article: @article, user: current_user) == [] ? false : true
  end

  def new; end

  def create
    @autor = current_autor
    @article = @autor.articles.create(article_params)
    if @article.errors.any?
      @article.errors.full_messages.each do |error|
        flash.now[:error] = error
       end
      render 'new'
  elsif @article.save
    redirect_to articles_index_for_autor_path
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if current_autor.id == @article.autor_id
      if @article.update(article_params)
        redirect_to articles_index_for_autor_path
      else
        render 'edit'
      end
    else
      #flash.now[:alert] = "article can change only its autor or admin"
      redirect_to articles_index_for_autor_path

    end
  end

  def destroy
    @article = Article.find(params[:id])
    if current_autor.id == @article.autor_id
      @article.destroy
      redirect_to articles_path
    #else render plain: "article can destroy only its autor or admin"
    end
  end

  def delete_upload
  attachment = ActiveStorage::Attachment.find(params[:id])
  attachment.purge # or use purge_later
  redirect_back(fallback_location: edit_article_path)
  end

  def sort
    params.require(:article).each_with_index do |id, index|
       Article.where(id: id).update_all(position: index + 1)
   end
  head :ok
end

  private

  def article_params
    params.require(:article).permit(:title, :body, :published_at, :status, :position, :category_id, images: [])
  end

  def layout
   if current_user
     "article_for_user"
   elsif current_autor
     "article_for_autor"
   end
  end


end
