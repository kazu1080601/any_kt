class CreateValuations < ActiveRecord::Migration[6.0]
  def change
    create_table :valuations do |t|
      t.text        :comment,            null: false
      t.date        :date,               null: false
      t.integer     :genre_id,           null: false
      t.string      :place_id,           null: false
      t.integer     :recommendation_id,  null: false
      t.references  :user,               foreign_key: true
      t.timestamps
    end
  end
end