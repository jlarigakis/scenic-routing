class TwitterWorker
  include Sidekiq::Worker

  def perform(min, max, lat, long, access_token)
    # client = Twitter.client(access_token: access_token)
    client.search("", :geocode => lat + "," + long + ",1mi", :result_type => "popular").each do |tweet|
      Twitter.create 
        lonlat:     tweet.coordinates #TO-DO COORDINATES HERE
        body:       tweet.text,
        retweets:   tweet.retweet_count,
        favorites:  tweet.favorite_count
    end
  end
end