class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  attachment :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :nick_name, length: { minimum: 2, maximum: 20 }

  has_many :books, dependent: :destroy
  has_many :inquiries, dependent: :destroy

  # コメント・いいね・ブックマーク
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_comments, through: :likes, source: :comment
  has_many :bookmarks, dependent: :destroy

  # フォロー機能
  has_many :relationships, class_name: "Relationship", foreign_key: "following_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :follower
  has_many :followers, through: :reverse_of_relationships, source: :following

  # すでにいいねしているか確認
  def already_liked?(comment)
    self.likes.exists?(comment_id: comment.id)
  end

  # ユーザーがブックマーク登録している投稿
  has_many :bookmarked_books, through: :bookmarks, source: :book

  def follow(user_id)
    relationships.create(follower_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(follower_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def is_follower?(user)
    followers.include?(user)
  end
end