class Valuation < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :recommendation
  belongs_to :user
  # belongs_to :genre
  has_one_attached :image
end
