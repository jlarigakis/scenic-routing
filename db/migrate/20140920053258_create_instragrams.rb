class CreateInstragrams < ActiveRecord::Migration
  def change
    create_table :instragrams do |t|
      t.point :lonlat, geographic: true
      t.string :body
      t.integer :likes
      t.timestamps
    end
  end
end
