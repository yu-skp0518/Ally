class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :book

  has_many :likes, dependent: :destroy

  validates :body, presence: true

  def liked_by?(user)
		likes.where(user_id: user.id).exists?
  end
end
