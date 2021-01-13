class Valuation < ApplicationRecord
  has_many :valuation_recommends
  # has_many :recommends, through: :valuation_recommends
  belongs_to :user
  # belongs_to :genre
  has_one_attached :image
end
