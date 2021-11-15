class Book < ApplicationRecord

  belongs_to :user
  belongs_to :subject
  belongs_to :genre

  # 中間テーブル
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  validates :isbn, uniqueness: { scope: :user_id }

  def bookmarked_by?(user)
		bookmarks.where(user_id: user.id).exists?
  end
end
