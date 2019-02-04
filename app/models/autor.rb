class Autor < ApplicationRecord
  has_many :articles
  has_many :categories, through: :articles
  has_many :messages, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def autor_name
   if name.blank?
       email.split('@')[0].capitalize
   else name
   end
 end

 end
