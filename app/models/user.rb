class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
has_many :comments
has_many :articles, through: :comments
has_many :favorites, dependent: :destroy


def user_name
  if name.blank?
    email.split('@')[0].capitalize
  else name
  end
end
end
