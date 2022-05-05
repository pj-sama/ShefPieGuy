# 
# promo_tweet.rb
# 
# Interacts with the PromoTweet table in DB.sqlite
# 

require_relative "row"

class PromoTweet < Row
  private
  
  TABLE = "\"PromoTweet\""
  PRIMARY_KEY = "TweetID"

  public

  # Inserts a promo tweet
  # * *Args* :
  #   - +tweet_id+ -> the ID of the promo tweet
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.insert(tweet_id, database_file = DATABASE_FILE)
    values = [tweet_id]
    super(TABLE, values, database_file)
  end

  # Deletes a promo tweet
  # * *Args* :
  #   - +tweet_id+ -> the ID of the promo tweet
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.delete(tweet_id, database_file = DATABASE_FILE)
    super(TABLE, [PRIMARY_KEY], [tweet_id], database_file)
  end

  # Selects all promo tweets
  # * *Args* :
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - all promo tweets as a two-dimensional array
  def self.select_all(database_file = DATABASE_FILE)
    super(TABLE, database_file)
  end
end
