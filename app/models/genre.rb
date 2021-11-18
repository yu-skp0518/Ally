class Genre < ApplicationRecord

  has_many :books, dependent: :destroy

  validates :name, presence: true, length: { in: 1..20 }

end
