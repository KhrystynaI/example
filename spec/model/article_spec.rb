require 'rails_helper'

RSpec.describe Article, type: :model do
  describe '.attribute' do
    it 'creats new Article only with autor and category' do
    Autor.create(email: 'autor@example.com', password: 'autor_example', password_confirmation: 'autor_example', id: 1, name: 'autor_name')
    Category.create(name: 'first', id: 1)
    expect{article = described_class.create!(title:'some title', autor_id: 1, category_id: 1)}.not_to raise_exception
    expect{article1 = described_class.create!(title:'title')}.to raise_error('Validation failed: Autor must exist, Category must exist')
    end
  end
end
