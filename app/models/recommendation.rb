class Recommendation < ActiveHash::Base
  self.data = [
    { id: 1, name: '---' },
    { id: 2, name: 'おすすめ！' ,search: "(おすすめ OR オススメ OR お勧め)" },
    { id: 3, name: 'また行きたい！' ,search: "(また行きたい OR またいきたい)"},
    { id: 4, name: '好き！' ,search: "(好き OR 好み)" },
  ]

  include ActiveHash::Associations
  has_many :valuations
end
