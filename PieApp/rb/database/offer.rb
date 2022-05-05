#
# offer.rb
#
# Interacts with the Offer table in DB.sqlite
#

require_relative "row"

class Offer < Row
  private

  TABLE = "\"Offer\""
  PRIMARY_KEY = "OfferID"

  public

  # Inserts an offer
  # * *Args* :
  #   - +mult+ -> the multiplier of the offer
  #   - +description+ -> the description of the offer
  #   - +global+ -> if the offer is global
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.insert(mult, description, global, database_file = DATABASE_FILE)
    offer_id = get_next_id(TABLE, PRIMARY_KEY, database_file)
    values = [offer_id, mult, description, global]
    super(TABLE, values, database_file)
  end

  # Updates the multiplier of an offer
  # * *Args* :
  #   - +mult+ -> the new multiplier of the offer
  #   - +offer_id+ -> the ID of the offer (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_mult(mult, offer_id, database_file = DATABASE_FILE)
    update_key = "Mult"
    update(TABLE, update_key, mult, [PRIMARY_KEY], [offer_id], database_file)
  end

  # Updates the description of an offer
  # * *Args* :
  #   - +description+ -> the new description of the offer
  #   - +offer_id+ -> the ID of the offer (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_description(description, offer_id, database_file = DATABASE_FILE)
    update_key = "Description"
    update(TABLE, update_key, description, [PRIMARY_KEY], [offer_id], database_file)
  end
  
  # Updates the global tag of an offer
  # * *Args* :
  #   - +global+ -> if the offer is global
  #   - +offer_id+ -> the ID of the offer (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.update_global(global, offer_id, database_file = DATABASE_FILE)
    update_key = "Global"
    update(TABLE, update_key, global, [PRIMARY_KEY], [offer_id], database_file)
  end

  # Deletes an offer
  # * *Args* :
  #   - +offer_id+ -> the ID of the offerId (cannot be nil)
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  def self.delete(offer_id, database_file = DATABASE_FILE)
    super("\"UserOffer\"", [PRIMARY_KEY], [offer_id], database_file)
    super(TABLE, [PRIMARY_KEY], [offer_id], database_file)
  end

  # Selects all offers
  # * *Args* :
  #   - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #   - all offers as a two-dimensional array
  def self.select_all(database_file = DATABASE_FILE)
    super(TABLE, database_file)
  end
  
  # Selects the specific offer that has the given id
  # * *Args* :
  #  - +id+ -> The ID which is being searched for
  #  - +database_file+ -> the location of the database file (default=DATABASE_FILE)
  # * *Returns* :
  #  - The offer that has the given id
  def self.select_by_id(id, database_file = DATABASE_FILE)
     select(TABLE, "*", [PRIMARY_KEY], [id], database_file) 
  end
end