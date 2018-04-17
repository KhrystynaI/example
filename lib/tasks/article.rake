namespace :articles do
  desc "Check status of published"
  task articlelist: :environment do
    Article.all.each do |article|
      if article.created_at <= Time.now
        article.published = true
        article.updated_at = Time.now
      end
      if article.published == true
        puts article.title
      end
    end
  end

end
