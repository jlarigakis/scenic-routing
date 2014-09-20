class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.point :lonlat, geographic: true
      t.string :body
      t.integer :retweets
      t.integer :favorites
      t.timestamps
    end
  end
end
