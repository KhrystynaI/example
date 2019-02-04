ActiveAdmin.register Article do
  permit_params :title, :body, :status, :published_at, :autor_id, :category_id, images: []

  index do
    column :id
    column :title
    column :status
    column :published_at
    column "image"  do |im|
      image_tag(im.banner("100X50!"))
    end
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
