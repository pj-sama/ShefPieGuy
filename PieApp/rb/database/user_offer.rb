# 
# user_offer.rb
# 
# Interacts with the UserOffer table in DB.sqlite
# 

require_relative "row"

class UserOffer < Row
  private
  
  TABLE = "\"UserOffer\""
  PRIMARY_KEYS = ["UserId", "OfferId"]

  public

  # Inserts a user offer
  # * *Args* :
  #   - +user_id+ -> a user's twitter ID (needs to exist in User table)
  #   - +offer_id+ -> the ID of an offer (needs to exist in Offer table)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.insert(user_id, offer_id, database_file = DATABASE_FILE)
    values = [user_id, offer_id]
    super(TABLE, values, database_file)
  end

  # Deletes a user offer
  # * *Args* :
  #   - +user_id+ -> a user's twitter ID (needs to exist in User table)
  #   - +offer_id+ -> the ID of an offer (needs to exist in Offer table)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.delete(user_id, offer_id, database_file = DATABASE_FILE)
    primary_values = [user_id, offer_id]
    super(TABLE, PRIMARY_KEYS, primary_values, database_file)
  end

  # Selects all user offers
  # * *Args* :
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - all user offers as a two-dimensional array
  def self.select_all(database_file = DATABASE_FILE)
    super(TABLE, database_file)
  end
  
  # Checks if user offer exists in the database
  # * *Args* :
  #   - +user_id+ -> the user's twitter ID
  #   - +offer_id+ -> the ID of the offer
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - true if user offer exists
  #   - false if user offer does not exist
  def self.exists(user_id, offer_id, database_file = DATABASE_FILE)
    return_key = "COUNT(\"#{PRIMARY_KEYS.first}\")"
    search_values = [user_id, offer_id]
    result = select(TABLE, return_key, PRIMARY_KEYS, search_values, database_file)
    if !check_first_select_result(result)
      return false
    elsif result[0][0] == 0
      return false
    else
      return true
    end
  end
end
