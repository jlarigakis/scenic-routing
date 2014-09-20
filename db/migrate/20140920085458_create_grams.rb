class CreateGrams < ActiveRecord::Migration
  def change
    create_table :grams do |t|
      t.point :lonlat, geographic: true
      t.text :body
      t.integer :likes
      t.timestamps
    end
    drop_table :instragrams
  end
end
