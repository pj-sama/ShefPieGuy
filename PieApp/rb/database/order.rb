#
# order.rb
#
# Interacts with the Order table in DB.sqlite
#

require_relative "row"

class Order < Row
  private

  TABLE = "\"Order\""
  PRIMARY_KEY = "OrderNo"

  public

  # Inserts an order
  # * *Args* :
  #   - +user_id+ -> a user's twitter ID (needs to exist in User table)
  #   - +flag_id+ -> the ID of a flag (needs to exist in Flag table)
  #   - +loc_id+ -> the location ID (needs to exist in Location table)
  #   - +total+ -> the new total price
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.insert(user_id, flag_id, loc_id, total, database_file = DATABASE_FILE)
    order_no = get_next_id(TABLE, PRIMARY_KEY, database_file)
    values = [order_no, user_id, flag_id, loc_id, total]
    super(TABLE, values, database_file)
  end

  # Updates the user ID
  # * *Args* :
  #   - +user_id+ -> the user's twitter ID (needs to exist in User table)
  #   - +order_no+ -> the order number (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_user_id(user_id, order_no, database_file = DATABASE_FILE)
    update_key = "UserID"
    update(TABLE, update_key, user_id, [PRIMARY_KEY], [order_no], database_file)
  end

  # Updates the flag ID
  # * *Args* :
  #   - +flag_id+ -> the ID of a flag (needs to exist in Flag table)
  #   - +order_no+ -> the order number (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_flag_id(flag_id, order_no, database_file = DATABASE_FILE)
    update_key = "FlagId"
    update(TABLE, update_key, flag_id, [PRIMARY_KEY], [order_no], database_file)
  end

  # Updates the location ID
  # * *Args* :
  #   - +loc_id+ -> the location ID (needs to exist in Location table)
  #   - +order_no+ -> the order number (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_loc_id(loc_id, order_no, database_file = DATABASE_FILE)
    update_key = "LocID"
    update(TABLE, update_key, loc_id, [PRIMARY_KEY], [order_no], database_file)
  end
  
  # Updates the total price
  # * *Args* :
  #   - +total+ -> the new total price
  #   - +order_no+ -> the order number (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_loc_total(total, order_no, database_file = DATABASE_FILE)
    update_key = "Total"
    update(TABLE, update_key, total, [PRIMARY_KEY], [order_no], database_file)
  end

  # Deletes an order
  # * *Args* :
  #   - +order_no+ -> the order number (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.delete(order_no, database_file = DATABASE_FILE)
    super("\"PieOrder\"", [PRIMARY_KEY], [order_no], database_file)
    super(TABLE, [PRIMARY_KEY], [order_no], database_file)
  end

  # Selects all orders
  # * *Args* :
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - all orders as a two-dimensional array
  def self.select_all(database_file = DATABASE_FILE)
    super(TABLE, database_file)
  end
end
