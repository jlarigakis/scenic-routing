class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.point :longlat, geographic: true
      t.string :name
      t.string :insta_id
      t.timestamps
    end
  end
end
