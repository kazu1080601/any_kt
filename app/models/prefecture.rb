class Prefecture < ActiveHash::Base
  require 'jp_prefecture'

  field :name
  create id: 1, name: '---'
  47.times do |i|
    pref = JpPrefecture::Prefecture.find i + 1
    create id: i + 2, name: pref.name
  end

  include ActiveHash::Associations
  has_many :users
end
