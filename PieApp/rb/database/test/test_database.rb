require "minitest/autorun"
require "sqlite3"
require "securerandom"
Dir["../*.rb"].each { |file| require file }

class TestDatabase < Minitest::Test
  DATABASE_TEST_FILE = "TestDB.sqlite"
  SHA_256 = Digest::SHA256.new

  def test_admin
    db = SQLite3::Database.open(DATABASE_TEST_FILE)
    db.execute("DELETE FROM \"Admin\"")
    db.close
    assert_equal [], Admin.select_all(DATABASE_TEST_FILE)
    
    Admin.insert("", "", DATABASE_TEST_FILE)
    result = Admin.select_all(DATABASE_TEST_FILE)
    salt = result[0][3]
    string_to_hash = "#{salt}"
    hash = SHA_256.hexdigest(string_to_hash)
    assert_equal [[1, "", hash, salt]], result
    Admin.insert("d", "e", DATABASE_TEST_FILE)
    result = Admin.select_all(DATABASE_TEST_FILE)
    salt_2 = result[1][3]
    string_to_hash = "e#{salt_2}"
    hash_2 = SHA_256.hexdigest(string_to_hash)
    assert_equal [[1, "", hash, salt], [2, "d", hash_2, salt_2]], Admin.select_all(DATABASE_TEST_FILE)
    
    Admin.update_username("a", 1, DATABASE_TEST_FILE)
    assert_equal [[1, "a", hash, salt], [2, "d", hash_2, salt_2]], Admin.select_all(DATABASE_TEST_FILE)
    Admin.update_password("b", 1, DATABASE_TEST_FILE)
    string_to_hash = "b#{salt}"
    hash = SHA_256.hexdigest(string_to_hash)
    assert_equal [[1, "a", hash, salt], [2, "d", hash_2, salt_2]], Admin.select_all(DATABASE_TEST_FILE)
    
    assert_equal true, Admin.username_and_password_correct?("a", "b", DATABASE_TEST_FILE)
    assert_equal false, Admin.username_and_password_correct?("z", "b", DATABASE_TEST_FILE)
    assert_equal false, Admin.username_and_password_correct?("a", "z", DATABASE_TEST_FILE)
    
    Admin.delete(1, DATABASE_TEST_FILE)
    assert_equal [[2, "d", hash_2, salt_2]], Admin.select_all(DATABASE_TEST_FILE)
    Admin.delete(2, DATABASE_TEST_FILE)
    assert_equal [], Admin.select_all(DATABASE_TEST_FILE)
  end
  
  def test_flag
    db = SQLite3::Database.open(DATABASE_TEST_FILE)
    db.execute("DELETE FROM \"Flag\"")
    db.close
    assert_equal [], Flag.select_all(DATABASE_TEST_FILE)
    
    Flag.insert(nil, '', DATABASE_TEST_FILE)
    assert_equal [[1, nil, ""]], Flag.select_all(DATABASE_TEST_FILE)
    Flag.insert("c", "d", DATABASE_TEST_FILE)
    assert_equal [[1, nil, ""], [2, "c", "d"]], Flag.select_all(DATABASE_TEST_FILE)
    
    Flag.update_description("a", 1, DATABASE_TEST_FILE)
    assert_equal [[1, "a", ""], [2, "c", "d"]], Flag.select_all(DATABASE_TEST_FILE)
    Flag.update_colour("b", 1, DATABASE_TEST_FILE)
    assert_equal [[1, "a", "b"], [2, "c", "d"]], Flag.select_all(DATABASE_TEST_FILE)
    
    Flag.delete(1, DATABASE_TEST_FILE)
    assert_equal [[2, "c", "d"]], Flag.select_all(DATABASE_TEST_FILE)
    Flag.delete(2, DATABASE_TEST_FILE)
    assert_equal [], Flag.select_all(DATABASE_TEST_FILE)
  end
  
  def test_location
    db = SQLite3::Database.open(DATABASE_TEST_FILE)
    db.execute("DELETE FROM \"Location\"")
    db.close
    assert_equal [], Location.select_all(DATABASE_TEST_FILE)

    Location.insert("a", DATABASE_TEST_FILE)
    assert_equal [[1, "a"]], Location.select_all(DATABASE_TEST_FILE)
    Location.insert("b", DATABASE_TEST_FILE)
    assert_equal [[1, "a"], [2, "b"]], Location.select_all(DATABASE_TEST_FILE)

    Location.update_name("c", 1, DATABASE_TEST_FILE)
    assert_equal [[1, "c"], [2, "b"]], Location.select_all(DATABASE_TEST_FILE)  

    Location.delete(1, DATABASE_TEST_FILE)
    assert_equal [[2, "b"]], Location.select_all(DATABASE_TEST_FILE)
    Location.delete(2, DATABASE_TEST_FILE)
    assert_equal [], Location.select_all(DATABASE_TEST_FILE)

    db = SQLite3::Database.open(DATABASE_TEST_FILE)
    db.execute("DELETE FROM \"Location\"")
    db.close
  end
  
  def test_offer
    db = SQLite3::Database.open(DATABASE_TEST_FILE)
    db.execute("DELETE FROM \"Offer\"")
    db.close
    assert_equal [], Offer.select_all(DATABASE_TEST_FILE)
    
    Offer.insert(nil, '', "", DATABASE_TEST_FILE)
    assert_equal [[1, nil, "", ""]], Offer.select_all(DATABASE_TEST_FILE)
    Offer.insert(2.2, "b", 1, DATABASE_TEST_FILE)
    assert_equal [[1, nil, "", ""], [2, 2.2, "b", 1]], Offer.select_all(DATABASE_TEST_FILE)
    
    assert_equal [[1, nil, "", ""]], Offer.select_by_id(1, DATABASE_TEST_FILE)
    assert_equal [[2, 2.2, "b", 1]], Offer.select_by_id(2, DATABASE_TEST_FILE)
    assert_equal [], Offer.select_by_id(3, database_file = DATABASE_TEST_FILE)
    
    Offer.update_mult(1.1, 1, DATABASE_TEST_FILE)
    assert_equal [[1, 1.1, "", ""], [2, 2.2, "b", 1]], Offer.select_all(DATABASE_TEST_FILE)
    Offer.update_description("a", 1, DATABASE_TEST_FILE)
    assert_equal [[1, 1.1, "a", ""], [2, 2.2, "b", 1]], Offer.select_all(DATABASE_TEST_FILE)
    Offer.update_global(0, 1, DATABASE_TEST_FILE)
    assert_equal [[1, 1.1, "a", 0], [2, 2.2, "b", 1]], Offer.select_all(DATABASE_TEST_FILE)
    
    Offer.delete(1, DATABASE_TEST_FILE)
    assert_equal [[2, 2.2, "b", 1]], Offer.select_all(DATABASE_TEST_FILE)
    Offer.delete(2, DATABASE_TEST_FILE)
    assert_equal [], Offer.select_all(DATABASE_TEST_FILE)
  end
  
  def test_order
    db = SQLite3::Database.open(DATABASE_TEST_FILE)
    db.execute("DELETE FROM \"Order\"")
    db.execute("DELETE FROM \"User\"")
    db.execute("DELETE FROM \"Flag\"")
    db.execute("DELETE FROM \"Location\"")
    db.close
    assert_equal [], Order.select_all(DATABASE_TEST_FILE)
    
    User.insert("hello", "a", "a", "a", DATABASE_TEST_FILE)
    User.insert("hello1", "b", "b", "b", DATABASE_TEST_FILE)
    result = User.select_all(DATABASE_TEST_FILE)
    user_id = result[0][0]
    user_id_2 = result[1][0]
    
    Flag.insert("a", "a", DATABASE_TEST_FILE)
    Flag.insert("b", "b", DATABASE_TEST_FILE)
    result = Flag.select_all(DATABASE_TEST_FILE)
    flag_id = result[0][0]
    flag_id_2 = result[1][0]
    
    Location.insert("a", DATABASE_TEST_FILE)
    Location.insert("b", DATABASE_TEST_FILE)
    result = Flag.select_all(DATABASE_TEST_FILE)
    loc_id = result[0][0]
    loc_id_2 = result[1][0]
    
    Order.insert(user_id, flag_id, loc_id, 35.1, DATABASE_TEST_FILE)
    assert_equal [[1, user_id, flag_id, loc_id, 35.1]], Order.select_all(DATABASE_TEST_FILE)
    Order.insert(user_id_2, flag_id_2, loc_id_2, 45.1, DATABASE_TEST_FILE)
    assert_equal [[1, user_id, flag_id, loc_id, 35.1], [2, user_id_2, flag_id_2, loc_id_2, 45.1]], Order.select_all(DATABASE_TEST_FILE)
    
    Order.update_user_id(user_id_2, 1, DATABASE_TEST_FILE)
    assert_equal [[1, user_id_2, flag_id, loc_id, 35.1], [2, user_id_2, flag_id_2, loc_id_2, 45.1]], Order.select_all(DATABASE_TEST_FILE)
    Order.update_flag_id(flag_id_2, 1, DATABASE_TEST_FILE)
    assert_equal [[1, user_id_2, flag_id_2, loc_id, 35.1], [2, user_id_2, flag_id_2, loc_id_2, 45.1]], Order.select_all(DATABASE_TEST_FILE)
    Order.update_loc_id(loc_id_2, 1, DATABASE_TEST_FILE)
    assert_equal [[1, user_id_2, flag_id_2, loc_id_2, 35.1], [2, user_id_2, flag_id_2, loc_id_2, 45.1]], Order.select_all(DATABASE_TEST_FILE)
    Order.update_loc_total( 36.1, 1, DATABASE_TEST_FILE)
    assert_equal [[1, user_id_2, flag_id_2, loc_id_2, 36.1], [2, user_id_2, flag_id_2, loc_id_2, 45.1]], Order.select_all(DATABASE_TEST_FILE)
    
    Order.delete(1, DATABASE_TEST_FILE)
    assert_equal [[2, user_id_2, flag_id_2, loc_id_2, 45.1]], Order.select_all(DATABASE_TEST_FILE)
    Order.delete(2, DATABASE_TEST_FILE)
    assert_equal [], Order.select_all(DATABASE_TEST_FILE)
    
    Order.insert(user_id, flag_id, loc_id, 35.1, DATABASE_TEST_FILE)
    assert_equal [[1, user_id, flag_id, loc_id, 35.1]], Order.select_all(DATABASE_TEST_FILE)
    User.delete(user_id, DATABASE_TEST_FILE)
    assert_equal [], Order.select_all(DATABASE_TEST_FILE)
    
    db = SQLite3::Database.open(DATABASE_TEST_FILE)
    db.execute("DELETE FROM \"User\"")
    db.execute("DELETE FROM \"Flag\"")
    db.execute("DELETE FROM \"Location\"")
    db.close
  end
  
  def test_pie
    db = SQLite3::Database.open(DATABASE_TEST_FILE)
    db.execute("DELETE FROM \"Pie\"")
    db.close
    assert_equal [], Pie.select_all(DATABASE_TEST_FILE)
    
    Pie.insert("", nil, 1.1, '', DATABASE_TEST_FILE)
    assert_equal [[1, "", nil, 1.1, ""]], Pie.select_all(DATABASE_TEST_FILE)
    Pie.insert("b", "b", 2.2, "b", DATABASE_TEST_FILE)
    assert_equal [[1, "", nil, 1.1, ""], [2, "b", "b", 2.2, "b"]], Pie.select_all(DATABASE_TEST_FILE)
    
    Pie.update_name("a", 1, DATABASE_TEST_FILE)
    assert_equal [[1, "a", nil, 1.1, ""], [2, "b", "b", 2.2, "b"]], Pie.select_all(DATABASE_TEST_FILE)
    Pie.update_description("a", 1, DATABASE_TEST_FILE)
    assert_equal [[1, "a", "a", 1.1, ""], [2, "b", "b", 2.2, "b"]], Pie.select_all(DATABASE_TEST_FILE)
    Pie.update_price(1.2, 1, DATABASE_TEST_FILE)
    assert_equal [[1, "a", "a", 1.2, ""], [2, "b", "b", 2.2, "b"]], Pie.select_all(DATABASE_TEST_FILE)
    Pie.update_picture("a", 1, DATABASE_TEST_FILE)
    assert_equal [[1, "a", "a", 1.2, "a"], [2, "b", "b", 2.2, "b"]], Pie.select_all(DATABASE_TEST_FILE)
    
    Pie.delete(1, DATABASE_TEST_FILE)
    assert_equal [[2, "b", "b", 2.2, "b"]], Pie.select_all(DATABASE_TEST_FILE)
    Pie.delete(2, DATABASE_TEST_FILE)
    assert_equal [], Pie.select_all(DATABASE_TEST_FILE)
  end
  
  def test_pie_order
    db = SQLite3::Database.open(DATABASE_TEST_FILE)
    db.execute("DELETE FROM \"Pie\"")
    db.execute("DELETE FROM \"Order\"")
    db.execute("DELETE FROM \"PieOrder\"")
    db.execute("DELETE FROM \"Flag\"")
    db.execute("DELETE FROM \"User\"")
    db.execute("DELETE FROM \"Location\"")
    db.close
    assert_equal [], PieOrder.select_all(DATABASE_TEST_FILE)
    
    User.insert("hello", "a", "a", "a", DATABASE_TEST_FILE)
    User.insert("hello1", "b", "b", "b", DATABASE_TEST_FILE)
    result = User.select_all(DATABASE_TEST_FILE)
    user_id = result[0][0]
    user_id_2 = result[1][0]
    
    Flag.insert("a", "a", DATABASE_TEST_FILE)
    Flag.insert("b", "b", DATABASE_TEST_FILE)
    result = Flag.select_all(DATABASE_TEST_FILE)
    flag_id = result[0][0]
    flag_id_2 = result[1][0]
    
    Location.insert("a", DATABASE_TEST_FILE)
    Location.insert("b", DATABASE_TEST_FILE)
    result = Flag.select_all(DATABASE_TEST_FILE)
    loc_id = result[0][0]
    loc_id_2 = result[1][0]

    Order.insert(user_id, flag_id, loc_id, 35.1, DATABASE_TEST_FILE)
    Order.insert(user_id_2, flag_id_2, loc_id_2, 45.1, DATABASE_TEST_FILE)
    result = Order.select_all(DATABASE_TEST_FILE)
    order_no = result[0][0]
    order_no_2 = result[1][0]

    Pie.insert("a", "a", 1.1, "a", DATABASE_TEST_FILE)
    Pie.insert("b", "b", 1.2, "b", DATABASE_TEST_FILE)
    result = Pie.select_all(DATABASE_TEST_FILE)
    pie_id = result[0][0]
    pie_id_2 = result[1][0]
    
    PieOrder.insert(order_no, pie_id, 1, DATABASE_TEST_FILE)
    assert_equal [[order_no, "#{pie_id}", 1]], PieOrder.select_all(DATABASE_TEST_FILE)
    PieOrder.insert(order_no_2, pie_id_2, 2, DATABASE_TEST_FILE)
    assert_equal [[order_no, "#{pie_id}", 1], [order_no_2, "#{pie_id_2}", 2]], PieOrder.select_all(DATABASE_TEST_FILE)
    
    PieOrder.update_quantity(3, order_no, pie_id, DATABASE_TEST_FILE)
    assert_equal [[order_no, "#{pie_id}", 3], [order_no_2, "#{pie_id_2}", 2]], PieOrder.select_all(DATABASE_TEST_FILE)
    
    PieOrder.delete(order_no, pie_id, DATABASE_TEST_FILE)
    assert_equal [[order_no_2, "#{pie_id_2}", 2]], PieOrder.select_all(DATABASE_TEST_FILE)
    PieOrder.delete(order_no_2, pie_id_2, DATABASE_TEST_FILE)
    assert_equal [], PieOrder.select_all(DATABASE_TEST_FILE)
    
    PieOrder.insert(order_no, pie_id, 1, DATABASE_TEST_FILE)
    assert_equal [[order_no, "#{pie_id}", 1]], PieOrder.select_all(DATABASE_TEST_FILE)
    PieOrder.insert(order_no_2, pie_id_2, 2, DATABASE_TEST_FILE)
    assert_equal [[order_no, "#{pie_id}", 1], [order_no_2, "#{pie_id_2}", 2]], PieOrder.select_all(DATABASE_TEST_FILE)
    
    Order.delete(order_no, DATABASE_TEST_FILE)
    assert_equal [[order_no_2, "#{pie_id_2}", 2]], PieOrder.select_all(DATABASE_TEST_FILE)
    User.delete(user_id_2, DATABASE_TEST_FILE)
    assert_equal [], PieOrder.select_all(DATABASE_TEST_FILE)
    
    db = SQLite3::Database.open(DATABASE_TEST_FILE)
    db.execute("DELETE FROM \"Pie\"")
    db.execute("DELETE FROM \"Order\"")
    db.execute("DELETE FROM \"Flag\"")
    db.execute("DELETE FROM \"User\"")
    db.execute("DELETE FROM \"Location\"")
    db.close
  end
  
  def test_promo_tweet
    db = SQLite3::Database.open(DATABASE_TEST_FILE)
    db.execute("DELETE FROM \"PromoTweet\"")
    db.close
    assert_equal [], PromoTweet.select_all(DATABASE_TEST_FILE)
    
    PromoTweet.insert(23452, DATABASE_TEST_FILE)
    assert_equal [[23452]], PromoTweet.select_all(DATABASE_TEST_FILE)
    PromoTweet.insert(675472, DATABASE_TEST_FILE)
    assert_equal [[23452], [675472]], PromoTweet.select_all(DATABASE_TEST_FILE)
    
    PromoTweet.delete(23452, DATABASE_TEST_FILE)
    assert_equal [[675472]], PromoTweet.select_all(DATABASE_TEST_FILE)
    PromoTweet.delete(675472, DATABASE_TEST_FILE)
    assert_equal [], PromoTweet.select_all(DATABASE_TEST_FILE)
  end
  
  def test_tweet
    db = SQLite3::Database.open(DATABASE_TEST_FILE)
    db.execute("DELETE FROM \"Tweet\"")
    db.close
    assert_equal [], Tweet.select_all(DATABASE_TEST_FILE)
    
    Tweet.insert(nil, DATABASE_TEST_FILE)
    assert_equal [[""]], Tweet.select_all(DATABASE_TEST_FILE)
    Tweet.insert(675472, DATABASE_TEST_FILE)
    assert_equal [[""], ["675472"]], Tweet.select_all(DATABASE_TEST_FILE)
    
    Tweet.delete(nil, DATABASE_TEST_FILE)
    assert_equal [["675472"]], Tweet.select_all(DATABASE_TEST_FILE)
    Tweet.delete(675472, DATABASE_TEST_FILE)
    assert_equal [], Tweet.select_all(DATABASE_TEST_FILE)
  end
  
  def test_user
    db = SQLite3::Database.open(DATABASE_TEST_FILE)
    db.execute("DELETE FROM \"User\"")
    db.close
    assert_equal [], User.select_all(DATABASE_TEST_FILE)
    
    User.insert("hello3", "", nil, '', DATABASE_TEST_FILE)
    assert_equal [["hello3", "", nil, ""]], User.select_all(DATABASE_TEST_FILE)
    assert_equal true, User.exists("hello3", DATABASE_TEST_FILE)
    assert_equal false, User.check_postcode("hello3", DATABASE_TEST_FILE)
    assert_equal false, User.check_house_no("hello3", DATABASE_TEST_FILE)
    assert_equal false, User.check_add_info("hello3", DATABASE_TEST_FILE)
    
    User.update_postcode("a","hello3", DATABASE_TEST_FILE)
    assert_equal [["hello3", "a", nil, ""]], User.select_all(DATABASE_TEST_FILE)
    assert_equal true, User.exists("hello3", DATABASE_TEST_FILE)
    assert_equal true, User.check_postcode("hello3", DATABASE_TEST_FILE)
    assert_equal false, User.check_house_no("hello3", DATABASE_TEST_FILE)
    assert_equal false, User.check_add_info("hello3", DATABASE_TEST_FILE)
    
    User.update_house_no("a","hello3", DATABASE_TEST_FILE)
    assert_equal [["hello3", "a", "a", ""]], User.select_all(DATABASE_TEST_FILE)
    assert_equal true, User.exists("hello3", DATABASE_TEST_FILE)
    assert_equal true, User.check_postcode("hello3", DATABASE_TEST_FILE)
    assert_equal true, User.check_house_no("hello3", DATABASE_TEST_FILE)
    assert_equal false, User.check_add_info("hello3", DATABASE_TEST_FILE)
    
    User.update_add_info("a","hello3", DATABASE_TEST_FILE)
    assert_equal [["hello3", "a", "a", "a"]], User.select_all(DATABASE_TEST_FILE)
    assert_equal true, User.exists("hello3", DATABASE_TEST_FILE)
    assert_equal true, User.check_postcode("hello3", DATABASE_TEST_FILE)
    assert_equal true, User.check_house_no("hello3", DATABASE_TEST_FILE)
    assert_equal true, User.check_add_info("hello3", DATABASE_TEST_FILE)

    User.delete("hello3", DATABASE_TEST_FILE)
    assert_equal [], User.select_all(DATABASE_TEST_FILE)
    assert_equal false, User.exists("hello3", DATABASE_TEST_FILE)
    assert_equal false, User.check_postcode("hello3", DATABASE_TEST_FILE)
    assert_equal false, User.check_house_no("hello3", DATABASE_TEST_FILE)
    assert_equal false, User.check_add_info("hello3", DATABASE_TEST_FILE)
    
    User.insert(nil, "", nil, '', DATABASE_TEST_FILE)
    assert_equal [["", "", nil, ""]], User.select_all(DATABASE_TEST_FILE)
    User.delete(nil, DATABASE_TEST_FILE)
    assert_equal [], User.select_all(DATABASE_TEST_FILE)
  end
  
  def test_user_offer
    db = SQLite3::Database.open(DATABASE_TEST_FILE)
    db.execute("DELETE FROM \"Offer\"")
    db.execute("DELETE FROM \"User\"")
    db.execute("DELETE FROM \"UserOffer\"")
    db.close
    assert_equal [], UserOffer.select_all(DATABASE_TEST_FILE)
    
    User.insert("hello", "a", "a", "a", DATABASE_TEST_FILE)
    User.insert("hello1", "b", "b", "b", DATABASE_TEST_FILE)
    result = User.select_all(DATABASE_TEST_FILE)
    user_id = result[0][0]
    user_id_2 = result[1][0]
    
    Offer.insert(1, "a", 1, DATABASE_TEST_FILE)
    Offer.insert(2, "b", 2, DATABASE_TEST_FILE)
    result = Offer.select_all(DATABASE_TEST_FILE)
    offer_id = result[0][0]
    offer_id_2 = result[1][0]
    
    UserOffer.insert(user_id, offer_id, DATABASE_TEST_FILE)
    assert_equal [[user_id, offer_id]], UserOffer.select_all(DATABASE_TEST_FILE)
    UserOffer.insert(user_id_2, offer_id_2, DATABASE_TEST_FILE)
    assert_equal [[user_id, offer_id], [user_id_2, offer_id_2]], UserOffer.select_all(DATABASE_TEST_FILE)
    assert_equal true, UserOffer.exists(user_id, offer_id, DATABASE_TEST_FILE)
    assert_equal false, UserOffer.exists(user_id_2, offer_id, DATABASE_TEST_FILE)
    assert_equal false, UserOffer.exists(user_id, offer_id_2, DATABASE_TEST_FILE)
    
    UserOffer.delete(user_id, offer_id, DATABASE_TEST_FILE)
    assert_equal [[user_id_2, offer_id_2]], UserOffer.select_all(DATABASE_TEST_FILE)
    assert_equal false, UserOffer.exists(user_id, offer_id, DATABASE_TEST_FILE)
    UserOffer.delete(user_id_2, offer_id_2, DATABASE_TEST_FILE)
    assert_equal [], UserOffer.select_all(DATABASE_TEST_FILE)
    
    UserOffer.insert(user_id, offer_id, DATABASE_TEST_FILE)
    assert_equal [[user_id, offer_id]], UserOffer.select_all(DATABASE_TEST_FILE)
    UserOffer.insert(user_id_2, offer_id_2, DATABASE_TEST_FILE)
    assert_equal [[user_id, offer_id], [user_id_2, offer_id_2]], UserOffer.select_all(DATABASE_TEST_FILE)
    
    User.delete(user_id, DATABASE_TEST_FILE)
    assert_equal [[user_id_2, offer_id_2]], UserOffer.select_all(DATABASE_TEST_FILE)
    Offer.delete(offer_id_2, DATABASE_TEST_FILE)
    assert_equal [], UserOffer.select_all(DATABASE_TEST_FILE)
    
    db = SQLite3::Database.open(DATABASE_TEST_FILE)
    db.execute("DELETE FROM \"Offer\"")
    db.execute("DELETE FROM \"User\"")
    db.close
  end
end
