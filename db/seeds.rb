# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
if Rails.env.development?
  Autor.create!(email: 'autor@example.com', password: 'autor_example', password_confirmation: 'autor_example', id: 1, name: 'autor_name',
                lastname: 'autor_lastname', alias: 'autor1', age: 25, salary: 12)
end
Category.create!(name: 'first', id: 1) if Rails.env.development?
Category.create!(name: 'second', id: 2) if Rails.env.development?
5.times{|t|Article.create!(title: "title#{t}", body: 'body for atrticle first1', autor_id: 1, category_id: 1, status: 1, position:"#{t}", id:"#{t}")} if Rails.env.development?
User.create!(name: "user", email: "user@mail.ua", id: 1, password: 'user_example', password_confirmation:'user_example')if Rails.env.development?
