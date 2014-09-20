class Gram < ActiveRecord::Base
  belongs_to :grams

  validates :insta_id, uniqueness: true

end
