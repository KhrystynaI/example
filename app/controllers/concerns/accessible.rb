module Accessible
  extend ActiveSupport::Concern
  included do
    before_action :check_user
  end

  protected

  def check_user
    if current_autor
      flash[:alert] = "you are #{current_autor.name}"
      redirect_to root_path, notice: 'try to change role?Log out'
    elsif current_user
      flash[:alert] = "you are #{current_user.email}"
      redirect_to root_path, notice: 'try to change role?Log out'
      end
  end
end
