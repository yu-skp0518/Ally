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


end
