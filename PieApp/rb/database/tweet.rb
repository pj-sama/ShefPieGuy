# 
# tweet.rb
# 
# Interacts with the Tweet table in DB.sqlite
# 

require_relative "row"

class Tweet < Row
  private
  
  TABLE = "\"Tweet\""
  PRIMARY_KEY = "TweetID"

  public

  # Inserts a promo tweet
  # * *Args* :
  #   - +tweet_id+ -> the ID of the tweet (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.insert(tweet_id, database_file = DATABASE_FILE)
    values = [to_string(tweet_id)]
    super(TABLE, values, database_file)
  end

  # Deletes a promo tweet
  # * *Args* :
  #   - +tweet_id+ -> the ID of the tweet (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.delete(tweet_id, database_file = DATABASE_FILE)
    super(TABLE, [PRIMARY_KEY], [to_string(tweet_id)], database_file)
  end

  # Selects all tweets
  # * *Args* :
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - all tweets as a two-dimensional array
  def self.select_all(database_file = DATABASE_FILE)
    super(TABLE, database_file)
  end
end
