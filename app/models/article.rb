class Article < ApplicationRecord
  belongs_to :autor
  belongs_to :category
  has_many :comments, dependent: :destroy
  before_save :check_published
  before_save :check_status

  scope :when_published, proc {
    where(published: true)
  }

  private

  def check_published
    self.created_at = published_at || Time.now
  end

  def check_status
    self.published = true if created_at <= Time.now
  end
end
