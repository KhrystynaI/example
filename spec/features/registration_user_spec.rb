require 'rails_helper'

feature 'User registration', type: :system do
  scenario 'successful registration for user after sign up autor' do
    autor = Autor.create(email: 'autor@example.com', password: 'autor_example', password_confirmation: 'autor_example', id: 1, name: 'autor_name', salary:0)
    Category.create(name: 'first', id: 1)
    Article.create(title:'some title', autor_id: 1, category_id: 1, id:1, published: true)
    visit root_path
    click_on 'Articles'
    click_on 'New article'
    sign_in autor
    visit articles_path
    click_on 'Comment for user'
    click_on "Logout"
    click_on 'Articles'
    click_on 'Comment for user'
    click_link "Sign up"
    fill_in 'Email', with: 'testuser@sample.net'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    expect(page).to have_content "Welcome! You have signed up successfully."
    expect(page).to have_content "Add a comment"

end
end
