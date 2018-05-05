require 'rails_helper'

feature 'Autor registration', type: :system do
  context 'with data entered correctly' do
    scenario 'successful registration for autor' do
      visit root_path

      click_on "Articles"
      click_on "New article"
      click_link "Sign up"
      fill_in 'Email', with: 'testuser@sample.net'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_on 'Sign up'
      expect(page).to have_content "Welcome! You have signed up successfully."
      expect(page).to have_content "Title"

    end
  end
end
