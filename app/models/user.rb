class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  with_options presence: true do
    validates :nickname
    validates :password, format: { with: /\A(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}\z/, message: 'complexity requirement not met. Length should be 6 characters minimum and include at least one letter and one number.(Excluding full-width)'}
    validates :prefecture_id, numericality: { other_than: 1, message: 'select' }
    validates :city
  end

  extend ActiveHash::Associations::ActiveRecordExtensions
  has_many :valuations
  belongs_to :prefecture

end
