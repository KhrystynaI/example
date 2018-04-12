class AutorsController < ApplicationController
  before_action :authenticate_autor!
  def example
    @autor = current_autor
    render '/autors/index'
  end
end
