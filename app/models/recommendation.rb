class Recommendation < ActiveHash::Base
  self.data = [
    { id: 1, name: '---' },
    { id: 2, name: 'おすすめ！' },
    { id: 3, name: 'また行きたい！' },
    { id: 4, name: '好き！' },
  ]

  include ActiveHash::Associations
  has_many :valuations
end
