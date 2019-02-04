
class AutorsController < ApplicationController
  layout "autor"
  before_action :authenticate_autor!
  def for_autor
    @autor = current_autor
    @articles = @autor.articles.all
    render '/autors/for_autor'
  end

  def charts
    @autor = current_autor
    @articles = @autor.articles.all
    respond_to do |format|
      format.html {render '/autors/_charts'}
      format.pdf do
        pdf = ExportPdf.new(@autor)
        send_data pdf.render,
        filename: "statistics.pdf",
        type: 'application/pdf',
        #without disposition: 'inline' pdf will be download automaticly
        disposition: 'inline'
      end
    end
  end
end
