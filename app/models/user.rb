class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  attachment :profile_image

  has_many :books, dependent: :destroy
  has_many :inquiries, dependent: :destroy

  # 中間テーブル
  has_many :comments, dependent: :destroy, through: :likes
  has_many :likes, dependent: :destroy, through: :comments
  has_many :bookmarks, dependent: :destroy, through: :books

  # フォロー機能
  has_many :relationships, class_name: "Relationship", foreign_key: "following_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :following
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # すでにいいねしているか確認
  def already_liked?(comment)
    self.likes.exists?(comment_id: comment.id)
  end

  # ユーザーがブックマーク登録している投稿
  has_many :bookmarked_books, through: :bookmarks, source: :book

  def follow(user_id)
    relationships.create(following_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(following_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end
end