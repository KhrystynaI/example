require 'rails_helper'

feature 'Page look with articles published', type: :system do
  scenario 'can see only published articles' do
    autor = Autor.create(email: 'autor@example.com', password: 'autor_example', password_confirmation: 'autor_example', id: 1, name: 'autor_name', salary:0)
    Category.create(name: 'first', id: 1)
    Article.create(title:'some title', autor_id: 1, category_id: 1, id:1, published_at: Time.now)
    Article.create(title:'another title', autor_id: 1, category_id: 1, id:2, published_at: 1.year.from_now)
    visit root_path
    click_on 'Articles'
    expect(page).to have_content "some title"
    expect(page).not_to have_content "another title"
  end
end
