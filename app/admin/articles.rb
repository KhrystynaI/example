ActiveAdmin.register Article do
  permit_params :title, :body, :published, :published_at, :autor_id, :category_id

  index do
    column :id
    column :title
    column :published
    column :published_at
    column :autor do |art|
      link_to(art.autor.name, admin_autor_path(art.autor.id))
    end
    column :category do |art|
      link_to(art.category.name, admin_category_path(art.category))
    end
    column :comments do |art|
      art.comments.count
    end
    actions
  end
end
