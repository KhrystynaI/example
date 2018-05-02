ActiveAdmin.register Comment do
  permit_params :body, :article_id
  index do
    column :id
    column :body
    column :article do |com|
      link_to(com.article.title, admin_article_path(com.article.id)).html_safe
    end
  end
end
