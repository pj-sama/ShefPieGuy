# 
# row.rb
# 
# Interacts with rows in DB.sqlite
# 

require "sqlite3"

class Row
  protected

  DATABASE_DIR = File.expand_path("../../../", File.dirname(__FILE__))
  DATABASE_FILE = "#{DATABASE_DIR}/DB.sqlite"

  # Inserts a row
  # * *Args* :
  #   - +table+ -> the table in which the row is inserted
  #   - +values+ -> the values inserted in the row
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.insert(table, values, database_file = DATABASE_FILE)
    query = "INSERT INTO #{table} VALUES("
    for i in 0...(values.length - 1)
      query << "?,"
    end
    query << "?)"
    execute_db_query(query, values, database_file)
  end
  
  # Updates values in rows
  # * *Args* :
  #   - +table+ -> the table where the row is
  #   - +update_key+ -> the key to update
  #   - +update_value+ -> the new value to update
  #   - +search_keys+ -> the keys to search
  #   - +search_values+ -> the values to search
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update(table, update_key, update_value, search_keys, search_values, database_file = DATABASE_FILE)
    query = "UPDATE #{table} set #{update_key}=? WHERE #{search_keys.first}=?"
    for i in 1...search_keys.length
      query << " AND #{search_keys[i]}=?"
    end
    values = [update_value, search_values].flatten!
    execute_db_query(query, values, database_file)
  end

  # Deletes rows
  # * *Args* :
  #   - +table+ -> the table where the row is
  #   - +search_keys+ -> the keys to search rows to delete
  #   - +search_values+ -> the values to search rows to delete
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.delete(table, search_keys, search_values, database_file = DATABASE_FILE)
    query = "DELETE FROM #{table} WHERE #{search_keys.first}=?"
    for i in 1...search_keys.length
      query << " AND #{search_keys[i]}=?"
    end
    execute_db_query(query, search_values, database_file)
  end

  # Selects rows in table
  # * *Args* :
  #   - +table+ -> the table where the rows are
  #   - +return_keys+ -> the keys to return in the result
  #   - +search_keys+ -> the keys to search with
  #   - +search_values+ -> the values to search with
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - all rows in the result as a two-dimensional array
  def self.select(table, return_keys, search_keys, search_values, database_file = DATABASE_FILE)
    query = "SELECT #{return_keys} FROM #{table} WHERE #{search_keys.first}=?"
    for i in 1...search_keys.length
      query << " AND #{search_keys[i]}=?"
    end
    execute_db_query(query, search_values, database_file)
  end

  # Selects all rows in table
  # * *Args* :
  #   - +table+ -> the table where the rows are
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - all rows in table as a two-dimensional array
  def self.select_all(table, database_file = DATABASE_FILE)
    query = "SELECT * FROM #{table}"
    execute_db_query(query, [], database_file)
  end

  # Gets the next available ID in table
  # * *Args* :
  #   - +table+ -> the table
  #   - +id_key+ -> the key to search for the next available ID
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - next available ID
  def self.get_next_id(table, id_key, database_file = DATABASE_FILE)
    query = "SELECT MAX(#{id_key})+1 FROM #{table}"
    next_id = execute_db_query(query, [], database_file)
    next_id.nil? ? 1 : next_id
  end
  
  # Checks if first select result exists
  # * *Returns* :
  #   - true if result exists
  #   - false if result does not exist
  def self.check_first_select_result(result)
    if result.nil?
      return false
    elsif result[0].nil?
      return false
    elsif result[0][0].nil? || result[0][0] == ""
      return false
    else
      return true
    end
  end
  
  # Converts variable to string
  # * *Args* :
  #   - +value+ -> the value to convert to empty string if nil
  # * *Returns* :
  #   - value as string
  def self.to_string(value)
    "#{value}"
  end
  
  private
  
  # Executes a database query
  # * *Args* :
  #   - +query+ -> the query to execute
  #   - +values+ -> the values used for the query
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - what the query returns
  def self.execute_db_query(query, values, database_file = DATABASE_FILE)
    db = SQLite3::Database.open(database_file)
    result = db.execute(query, values)
    db.close
    result
  end
end
