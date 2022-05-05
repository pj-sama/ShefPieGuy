# 
# user.rb
# 
# Interacts with the User table in DB.sqlite
# 

require_relative "order"
require_relative "row"

class User < Row
  private
  
  TABLE = "\"User\""
  PRIMARY_KEY = "UserID"

  public

  # Inserts a user
  # * *Args* :
  #   - +user_id+ -> the user's twitter ID (cannot be nil)
  #   - +postcode+ -> the user's postcode
  #   - +house_no+ -> the user's house number
  #   - +add_info+ -> the user's additional information
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.insert(user_id, postcode, house_no, add_info, database_file = DATABASE_FILE)
    values = [to_string(user_id), postcode, house_no, add_info]
    super(TABLE, values, database_file)
  end

  # Updates a user's postcode
  # * *Args* :
  #   - +postcode+ -> the user's new postcode
  #   - +user_id+ -> the user's twitter ID (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_postcode(postcode, user_id, database_file = DATABASE_FILE)
    update_key = "PostCode"
    update(TABLE, update_key, postcode, [PRIMARY_KEY], [to_string(user_id)], database_file)
  end

  # Updates a user's house number
  # * *Args* :
  #   - +house_no+ -> the user's new house number
  #   - +user_id+ -> the user's twitter ID (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_house_no(house_no, user_id, database_file = DATABASE_FILE)
    update_key = "HouseNo"
    update(TABLE, update_key, house_no, [PRIMARY_KEY], [to_string(user_id)], database_file)
  end

  # Updates a user's additional information
  # * *Args* :
  #   - +add_info+ -> the user's new additional information
  #   - +user_id+ -> the user's twitter ID (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_add_info(add_info, user_id, database_file = DATABASE_FILE)
    update_key = "AddInfo"
    update(TABLE, update_key, add_info, [PRIMARY_KEY], [to_string(user_id)], database_file)
  end

  # Deletes a user
  # * *Args* :
  #   - +user_id+ -> the user's twitter ID (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.delete(user_id, database_file = DATABASE_FILE)
    super("\"UserOffer\"", [PRIMARY_KEY], [to_string(user_id)], database_file)
    orders = select("\"Order\"", "OrderNo", [PRIMARY_KEY], [to_string(user_id)], database_file)
    orders.each { |order| Order.delete(order.first, database_file) }
    super(TABLE, [PRIMARY_KEY], [to_string(user_id)], database_file)
  end

  # Selects all users
  # * *Args* :
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - all users as a two-dimensional array
  def self.select_all(database_file = DATABASE_FILE)
    super(TABLE, database_file)
  end

  # Checks if user exists in the database
  # * *Args* :
  #   - +user_id+ -> the user's twitter ID
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - true if user exists
  #   - false if user does not exist
  def self.exists(user_id, database_file = DATABASE_FILE)
    return_key = "COUNT(\"#{PRIMARY_KEY}\")"
    result = select(TABLE, return_key, [PRIMARY_KEY], [to_string(user_id)], database_file)
    if !check_first_select_result(result)
      return false
    elsif result[0][0] == 0
      return false
    else
      return true
    end
  end

  # Checks if user has a postcode
  # * *Args* :
  #   - +user_id+ -> the user's twitter ID
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - true if user has a postcode
  #   - false if user does not have a postcode
  def self.check_postcode(user_id, database_file = DATABASE_FILE)
    return_key = "PostCode"
    result = select(TABLE, return_key, [PRIMARY_KEY], [to_string(user_id)], database_file)
    check_first_select_result(result)
  end

  # Checks if user has a house number
  # * *Args* :
  #   - +user_id+ -> the user's twitter ID
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - true if user has a house number
  #   - false if user does not have a house number
  def self.check_house_no(user_id, database_file = DATABASE_FILE)
    return_key = "HouseNo"
    result = select(TABLE, return_key, [PRIMARY_KEY], [to_string(user_id)], database_file)
    check_first_select_result(result)
  end

  # Checks if user has additional info
  # * *Args* :
  #   - +user_id+ -> the user's twitter ID
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - true if user has additional info
  #   - false if user does not have additional info
  def self.check_add_info(user_id, database_file = DATABASE_FILE)
    return_key = "AddInfo"
    result = select(TABLE, return_key, [PRIMARY_KEY], [to_string(user_id)], database_file)
    check_first_select_result(result)
  end
end
