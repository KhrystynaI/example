require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'published_at' do
    it 'describe how autor can choose date of published article' do
    Autor.create(email: 'autor@example.com', password: 'autor_example', password_confirmation: 'autor_example', id: 1, name: 'autor_name')
    Category.create(name: 'first', id: 1)
    article_first = Article.create(title:'some title', autor_id: 1, category_id: 1, id:1, published_at: Time.now)
    article_second = Article.create(title:'another title', autor_id: 1, category_id: 1, id:2, published_at: 1.year.from_now)
    expect(article_first.published).to eql true
    expect(article_second.published).to eql false
  end
end
end
