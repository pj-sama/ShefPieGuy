#
# location.rb
#
# Interacts with the Location table in DB.sqlite
#

require_relative "row"

class Location < Row
  private
  
  TABLE = "\"Location\""
  PRIMARY_KEY = "LocID"

  public

  # Inserts a Location
  # * *Args* :
  #   - +name+ -> the name of the Location
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.insert(name, database_file = DATABASE_FILE)
    loc_id = get_next_id(TABLE, PRIMARY_KEY, database_file)
    values = [loc_id, name]
    super(TABLE, values, database_file)
  end

  # Updates the Name
  # * *Args* :
  #   - +name+ -> the name of the Location
  #   - +loc_id+ -> the location id (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_name(name, loc_id, database_file = DATABASE_FILE)
    update_key = "Name"
    update(TABLE, update_key, name, [PRIMARY_KEY], [loc_id], database_file)
  end

  # Deletes a Location
  # * *Args* :
  #   - +loc_id+ -> the location id (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.delete(loc_id, database_file = DATABASE_FILE)
    super(TABLE, [PRIMARY_KEY], [loc_id], database_file)
  end

  # Selects all locations
  # * *Args* :
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - all locations as a two-dimensional array
  def self.select_all(database_file = DATABASE_FILE)
    super(TABLE, database_file)
  end
end
