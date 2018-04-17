class Article < ApplicationRecord
  belongs_to :autor
  has_many :comments, dependent: :destroy
  validates :title, presence: true
  before_save :check_published
  before_save :check_status


scope :when_published, proc {
  where(:published => true)
}
  private

  def check_published
    self.created_at = self.published_at || Time.now
  end

  def check_status
    if self.created_at <= Time.now
      self.published = true
    end
  end
end
