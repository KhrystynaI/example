ActiveAdmin.register Autor do

  permit_params :name, :lastname, :alias, :age, :salary, :email, :password, :password_confirmation

  form do |f|
    f.inputs do
      f.input :name
      f.input :lastname
      f.input :alias
      f.input :age
      f.input :salary, default:10
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  index do
    column :id
    column :name
    column :lastname
    column :alias
    column :salary do |autor|
      autor.salary = ((autor.articles.map{|art| art.comments.count}.sum)*0.8)+((autor.articles.count)*10)+10
    end
    column :list_of_article do |autor|
      autor.articles.map {|art| link_to(art.title, admin_article_path(art.id))}.join(', ').html_safe
    end
    column :count_of_article do |autor|
      autor.articles.count
    end
    column :count_of_commetar do |autor|
      #autor.articles.map{|art| art.comments.count}.join(', ')
      autor.articles.map{|art| art.comments.count}.sum
    end
    column :list_of_category do |autor|
      autor.articles.map {|art| link_to(art.category.name, admin_category_path(art.category.id))}.join(', ').html_safe
    end
    actions
  end

end
