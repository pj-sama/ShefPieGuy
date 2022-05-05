#
# pie.rb
#
# Interacts with the Pie table in DB.sqlite
#

require_relative "row"

class Pie < Row
  private

  TABLE = "\"Pie\""
  PRIMARY_KEY = "PieID"

  public

  # Inserts a pie
  # * *Args* :
  #   - +name+ -> the name of the pie
  #   - +description+ -> the description of the pie
  #   - +price+ -> the price of the pie
  #   - +picture+ -> the location of the picture of the pie
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.insert(name, description, price, picture, database_file = DATABASE_FILE)
    pie_id = get_next_id(TABLE, PRIMARY_KEY, database_file)
    values = [pie_id, name, description, price, picture]
    super(TABLE, values, database_file)
  end

  # Updates the name of a pie
  # * *Args* :
  #   - +name+ -> the new name of the pie
  #   - +pie_id+ -> the ID of the pie (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_name(name, pie_id, database_file = DATABASE_FILE)
    update_key = "Name"
    update(TABLE, update_key, name, [PRIMARY_KEY], [pie_id], database_file)
  end

  # Updates the description of a pie
  # * *Args* :
  #   - +description+ -> the new description of the pie
  #   - +pie_id+ -> the ID of the pie (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_description(description, pie_id, database_file = DATABASE_FILE)
    update_key = "Description"
    update(TABLE, update_key, description, [PRIMARY_KEY], [pie_id], database_file)
  end

  # Updates the price of a pie
  # * *Args* :
  #   - +price+ -> the new price of the pie
  #   - +pie_id+ -> the ID of the pie (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_price(price, pie_id, database_file = DATABASE_FILE)
    update_key = "Price"
    update(TABLE, update_key, price, [PRIMARY_KEY], [pie_id], database_file)
  end

  # Updates the location of the picture of a pie
  # * *Args* :
  #   - +picture+ -> the new location of the picture of the pie
  #   - +pie_id+ -> the ID of the pie (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_picture(picture, pie_id, database_file = DATABASE_FILE)
    update_key = "Picture"
    update(TABLE, update_key, picture, [PRIMARY_KEY], [pie_id], database_file)
  end

  # Deletes a pie
  # * *Args* :
  #   - +pie_id+ -> the ID of the pie (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.delete(pie_id, database_file = DATABASE_FILE)
    super(TABLE, [PRIMARY_KEY], [pie_id], database_file)
  end

  # Selects all pies
  # * *Args* :
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - all pies as a two-dimensional array
  def self.select_all(database_file = DATABASE_FILE)
    super(TABLE, database_file)
  end
end
