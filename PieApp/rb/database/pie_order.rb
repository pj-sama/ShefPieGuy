# 
# pie_order.rb
# 
# Interacts with the PieOrder table in DB.sqlite
# 

require_relative "row"

class PieOrder < Row
  private
  
  TABLE = "\"PieOrder\""
  PRIMARY_KEYS = ["OrderNo", "PieId"]

  public

  # Inserts a pie order
  # * *Args* :
  #   - +order_no+ -> the order number (needs to exist in Order table)
  #   - +pie_id+ -> the ID of the pie ordered (needs to exist in Pie table)
  #   - +quantity+ -> the quantity of pies ordered
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.insert(order_no, pie_id, quantity, database_file = DATABASE_FILE)
    values = [order_no, pie_id, quantity]
    super(TABLE, values, database_file)
  end

  # Updates the quantity of pies ordered
  # * *Args* :
  #   - +quantity+ -> the new quantity of pies ordered
  #   - +order_no+ -> the order number (needs to exist in Order table)
  #   - +pie_id+ -> the ID of the pie ordered (needs to exist in Pie table)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_quantity(quantity, order_no, pie_id, database_file = DATABASE_FILE)
    update_key = "Quantity"
    primary_values = [order_no, pie_id]
    update(TABLE, update_key, quantity, PRIMARY_KEYS, primary_values, database_file)
  end

  # Deletes a pie order
  # * *Args* :
  #   - +order_no+ -> the order number (needs to exist in Order table)
  #   - +pie_id+ -> the ID of the pie ordered (needs to exist in Pie table)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.delete(order_no, pie_id, database_file = DATABASE_FILE)
    primary_values = [order_no, pie_id]
    super(TABLE, PRIMARY_KEYS, primary_values, database_file)
  end

  # Selects all pie orders
  # * *Args* :
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - all user offers as a two-dimensional array
  def self.select_all(database_file = DATABASE_FILE)
    super(TABLE, database_file)
  end
end
