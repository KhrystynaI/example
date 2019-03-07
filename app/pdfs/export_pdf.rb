require 'prawn-graph'

class ExportPdf
  include Prawn::View

  def initialize(autor)
    super()
    @autor = autor
    @articles = @autor.articles.all
    content
  end

  def content
    bounding_box [8,730], :width => 550, :height => 600 do
      table art_for_autor(@autor) do
        row(0).font_style = :bold
        columns(1..3).align = :right
        self.row_colors = ['DDDDDD', 'FFFFFF']
        self.header = true
      end
    end
    bounding_box [10,350], :width => 900, :height => 600 do
      charts_for_autor_comments(@autor)
    end
    bounding_box [10,150], :width => 900, :height => 600 do
      charts_for_autor_category(@autor)
    end
  end

  def art_for_autor(autor)
    [["Title", "status"]] +
    autor.articles.map { |article| [article.title.to_s, article.status.to_s]}
  end

  def charts_for_autor_comments(autor)
    series = []
    series << Prawn::Graph::Series.new(autor.articles.map{|art| art.comments.count}, type: :line, mark_average: true, mark_minimum: true)
    xaxis_labels = autor.articles.map{|art| art.title.to_s.byteslice(0..5)}
    graph series, width: 500, height: 200, title: "Count of comments for article", at: [10,700], xaxis_labels: xaxis_labels
  end

  def charts_for_autor_category(autor)
    series = []
    series << Prawn::Graph::Series.new(autor.articles.map{|art| art.category_id}, type: :bar)
    xaxis_labels = autor.articles.map{|art| art.title}
    graph series, width: 500, height: 200, title: "Category of articles per day", at: [10,700], xaxis_labels: xaxis_labels
  end
end
