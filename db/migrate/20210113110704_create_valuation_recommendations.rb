class CreateValuationRecommendations < ActiveRecord::Migration[6.0]
  def change
    create_table :valuation_recommendations do |t|
      t.references  :valuation,     foreign_key: true
      t.integer     :recommend_id,  null: false
      t.timestamps
    end
  end
end
