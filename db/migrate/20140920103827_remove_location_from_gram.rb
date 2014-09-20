class RemoveLocationFromGram < ActiveRecord::Migration
  def change
    change_table :grams do |t|
      t.remove :lonlat
      t.references :location
    end
  end
end
