class AddInstaIdToGrams < ActiveRecord::Migration
  def change
    change_table :grams do |t|
      t.string :insta_id
    end
  end
end
