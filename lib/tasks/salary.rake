namespace :salary do
  desc 'Chenge salary'
  task salary: :environment do
    Autor.all.each do |autor|
      salary = (autor.articles.map { |art| art.comments.count}.sum * 0.8) + (autor.articles.count * 10) + 10
      autor.update_attributes(salary: salary)
      puts salary
      puts Time.now
    end
  end
end
