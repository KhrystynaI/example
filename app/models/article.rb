class Article < ApplicationRecord
  has_many_attached :images
  enum status: {draft:0, published:1}
  belongs_to :autor
  belongs_to :category
  has_many :comments, dependent: :destroy
  before_create :check_published
  before_update :check_status
  has_many :users, through: :comments
  has_many :favorites, dependent: :destroy
  validate :image_type
  self.per_page = 4

  def banner(resize)
    if self.images.attached?
    self.images.first.variant(resize: resize).processed
  else "http://placehold.it/100x50"
  end
  end

def for_carousel
  if self.images.attached?
    (self.images).map do |image|
      image#.variant(resize: "1000X500!").processed
end
else ["http://placehold.it/1110X500"]
end
end

  private

  def image_type
    if self.images.attached?
    self.images.each do |image|
    if  !image.content_type.in?(%w(image/jpeg image/png))
      errors.add(:images, "only jpeg and png")
    end
  end
end
  end


  def check_published
   if published_at.present? && published_at > Time.now
      self.status = 0
    end
  end

  def check_status
    if (status == "published")&&(published_at.present? && published_at > Time.now)
      self.published_at = nil
    end
  end


end
