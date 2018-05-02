namespace :articles do
  desc 'Check status of published'
  task articlelist: :environment do
    Article.all.each do |article|
      if article.created_at <= Time.now
        article.published = true
        article.update_attributes(updated_at: Time.now)
      end
      puts article.title if article.published == true
    end
  end
end
