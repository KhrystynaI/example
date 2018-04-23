class Category < ApplicationRecord
  has_many :articles
  has_many :autors, :through => :articles
end
