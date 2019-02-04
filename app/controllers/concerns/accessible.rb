module Accessible
  extend ActiveSupport::Concern
  included do
    before_action :check_user
  end

  protected

  def check_user
    if current_autor
      redirect_to articles_index_for_autor_path
      elsif current_user
      redirect_to articles_path
      end
  end
end
