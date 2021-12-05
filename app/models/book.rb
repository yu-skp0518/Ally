class Book < ApplicationRecord

  belongs_to :user
  belongs_to :subject
  belongs_to :genre

  # 中間テーブル
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  # １ユーザーにつき同じ本は１度しか投稿できない
  validates :rate, numericality: { in: 0..5, message: 'を0点〜5点で入力してください' }
  validates :story, length: { minimum: 0, maximum: 300 }, presence: true
  validates :isbn, uniqueness: { scope: :user_id, message: 'この書籍は以前に投稿しています' }

  def bookmarked_by?(user)
		bookmarks.where(user_id: user.id).exists?
  end
end
