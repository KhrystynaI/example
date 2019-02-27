namespace :articles do
  desc 'Check status of published'
  task articlelist: :environment do
    puts Rails.env
    Article.all.each do |article|
      if article.published_at.present? && article.published_at <= Time.now
        article.update_attributes(status:1)
      end
      puts article.title if article.published?
    end
  end
end
