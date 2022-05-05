# 
# admin.rb
# 
# Interacts with the Admin table in DB.sqlite
# 

require_relative "row"
require "securerandom"

class Admin < Row
  private
  
  TABLE = "\"Admin\""
  PRIMARY_KEY = "AdminID"
  USERNAME_KEY = "Username"
  SHA_256 = Digest::SHA256.new

  public
  
  # Inserts an admin
  # * *Args* :
  #   - +username+ -> the username of the admin
  #   - +password+ -> the hash of the admin
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.insert(username, password, database_file = DATABASE_FILE)
    admin_id = get_next_id(TABLE, PRIMARY_KEY, database_file)
    salt = SecureRandom.hex
    string_to_hash = "#{password}#{salt}"
    hash = SHA_256.hexdigest(string_to_hash)
    values = [admin_id, username, hash, salt]
    super(TABLE, values, database_file)
  end

  # Updates the username of an admin
  # * *Args* :
  #   - +username+ -> the new username of the admin
  #   - +admin_id+ -> the ID of the admin
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_username(username, admin_id, database_file = DATABASE_FILE)
    update_key = "Username"
    update(TABLE, update_key, username, [PRIMARY_KEY], [admin_id], database_file)
  end

  # Updates the hash of an admin
  # * *Args* :
  #   - +password+ -> the new password of the admin
  #   - +admin_id+ -> the ID of the admin
  def self.update_password(password, admin_id, database_file = DATABASE_FILE)
    return_key = "Salt"
    result = select(TABLE, return_key, [PRIMARY_KEY], [admin_id], database_file)
    salt = result[0][0]
    string_to_hash = "#{password}#{salt}"
    hash = SHA_256.hexdigest(string_to_hash)
    update_key = "Hash"
    update(TABLE, update_key, hash, [PRIMARY_KEY], [admin_id], database_file)
  end
  
  # Checks if admin username and password are correct
  # * *Args* :
  #   - +username+ -> the admin username to check
  #   - +password+ -> the admin password to check
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - true if admin username and password are correct
  #   - false if admin username and password are not correct
  def self.username_and_password_correct?(username, password, database_file = DATABASE_FILE)
    return_key = "*"
    search_key = "Username"
    result = select(TABLE, return_key, [search_key], [username], database_file)
    if !check_first_select_result(result)
      return false
    elsif result[0][1] == username
      salt = result[0][3]
    else
      return false
    end
    string_to_hash = "#{password}#{salt}"
    hash = SHA_256.hexdigest(string_to_hash)
    if result[0][2] == hash
      return true
    else
      return false
    end
  end

  # Deletes an admin
  # * *Args* :
  #   - +admin_id+ -> the ID of the admin
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.delete(admin_id, database_file = DATABASE_FILE)
    super(TABLE, [PRIMARY_KEY], [admin_id], database_file)
  end

  # Selects all admins
  # * *Args* :
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - all admins as a two-dimensional array
  def self.select_all(database_file = DATABASE_FILE)
    super(TABLE, database_file)
  end
    
  # Checks if admin exists in the database
  # * *Args* :
  #   - +username+ -> the user's twitter ID
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - true if user exists
  #   - false if user does not exist
  def self.exists(username, database_file = DATABASE_FILE)
    return_key = "COUNT(\"#{USERNAME_KEY}\")"
    result = select(TABLE, return_key, [Username], [username], database_file)
    if !check_first_select_result(result)
      return false
    elsif result[0][0] == 0
      return false
    else
      return true
    end
  end
end

