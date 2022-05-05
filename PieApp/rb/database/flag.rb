# 
# flag.rb
# 
# Interacts with the Flag table in DB.sqlite
# 

require_relative "row"

class Flag < Row
  private
  
  TABLE = "\"Flag\""
  PRIMARY_KEY = "FlagID"

  public

  # Inserts a flag
  # * *Args* :
  #   - +description+ -> the description of the flag
  #   - +colour+ -> the colour of the flag
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.insert(description, colour, database_file = DATABASE_FILE)
    flag_id = get_next_id(TABLE, PRIMARY_KEY, database_file)
    values = [flag_id, description, colour]
    super(TABLE, values, database_file)
  end

  # Updates the description of a flag
  # * *Args* :
  #   - +description+ -> the new description of the flag
  #   - +flag_id+ -> the ID of the flag (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_description(description, flag_id, database_file = DATABASE_FILE)
    update_key = "Description"
    update(TABLE, update_key, description, [PRIMARY_KEY], [flag_id], database_file)
  end

  # Updates the colour of a flag
  # * *Args* :
  #   - +colour+ -> the new colour of the flag
  #   - +flag_id+ -> the ID of the flag (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_colour(colour, flag_id, database_file = DATABASE_FILE)
    update_key = "Colour"
    update(TABLE, update_key, colour, [PRIMARY_KEY], [flag_id], database_file)
  end

  # Deletes a flag
  # * *Args* :
  #   - +flag_id+ -> the ID of the flag (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.delete(flag_id, database_file = DATABASE_FILE)
    super(TABLE, [PRIMARY_KEY], [flag_id], database_file)
  end

  # Selects all flags
  # * *Args* :
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - all flags as a two-dimensional array
  def self.select_all(database_file = DATABASE_FILE)
    super(TABLE, database_file)
  end
end
