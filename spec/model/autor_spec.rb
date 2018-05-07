require 'rails_helper'
require 'rake'

RSpec.describe Autor, type: :model do
  describe '.attribute' do
    it 'create attribute salary' do
    autor = Autor.create!(email: 'autor@example.com', password: 'autor_example', password_confirmation: 'autor_example', id: 1, name: 'autor_name', salary:0)
    Category.create!(name: 'first', id: 1)
    User.create!(name:"some", id: 1, email: 'user@example.com', password: 'user_example', password_confirmation: 'user_example')
    article = Article.create!(title:'some title', autor_id: 1, category_id: 1, id:1)
    Comment.create!(article_id: 1, user_id: 1)
    article1 = Article.create(title:'another title', autor_id: 1, category_id: 1, id:2)
    salary = (autor.articles.map { |art| art.comments.count}.sum * 0.8) + (autor.articles.count * 10) + 10
    autor.update_attributes(salary: salary)
    expect(autor.salary).to eq 30.8
    end
  end
  describe '.attribute salary with rake' do
    it 'create attribute salary with rake' do
    autor = Autor.create!(email: 'autor@example.com', password: 'autor_example', password_confirmation: 'autor_example', id: 1, name: 'autor_name', salary:0)
    Category.create!(name: 'first', id: 1)
    User.create!(name:"some", id: 1, email: 'user@example.com', password: 'user_example', password_confirmation: 'user_example')
    article = Article.create!(title:'some title', autor_id: 1, category_id: 1, id:1)
    Comment.create!(article_id: 1, user_id:1)
    article1 = Article.create!(title:'another title', autor_id: 1, category_id: 1, id:2)
    Rails.application.load_tasks
    #or can load only one file
    #Rake.load_rakefile("/home/khrystyna/example/example/newspaper/lib/tasks/salary.rake")
    Rake::Task.define_task(:environment)
    expect { Rake.application["salary:salary"].invoke }.not_to raise_exception
    Rake.application["salary:salary"].invoke
    autor.reload
    expect(autor.salary).to eq 30.8
    end
  end
end
