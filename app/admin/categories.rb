ActiveAdmin.register Category do
  permit_params :name


  index do
    column :id
    column :name
    column :count_of_article do |category|
      category.articles.count
    end
    column :list_of_article do |category|
      category.articles.map {|art| link_to(art.title, admin_article_path(art.id))}.join(', ').html_safe
    end
    column :list_of_autors do |category|
      category.articles.map {|art| link_to(art.autor.name, admin_autor_path(art.autor.id))}.join(', ').html_safe
    end
    actions
  end
end
