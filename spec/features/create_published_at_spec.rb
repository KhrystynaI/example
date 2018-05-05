require 'rails_helper'

feature 'Page look with articles published', type: :system do
  scenario 'can see only published articles' do
    @autor = Autor.create(email: 'autor@example.com', password: 'autor_example', password_confirmation: 'autor_example', id: 1, name: 'autor_name')
    Category.create(name: 'second', id: 1)
    sign_in @autor
    visit new_article_path
    select('second', :from => 'article[category_id]')
    fill_in "article[published_at]", with:'07-05-2018'
    find_button('Save Article').click

    expect(Article.last.published_at).to eq "2018-05-07"
    expect(Article.last.published).to eql false
    expect(Article.last.category_id).to eql 1

  end
end
