
require_relative 'PieApp/app.rb'
require "sqlite3"

desc "Restore the state of the db"
task :wipedb do
  puts "Wiping the database"
  File.delete("./DB.sqlite") if File.exist?("./DB.sqlite")
  db = SQLite3::Database.new "./DB.sqlite"
  db.execute('CREATE TABLE \'Admin\' ( \'AdminID\' INTEGER, \'Username\' TEXT, \'Hash\' TEXT, \'Salt\' TEXT, PRIMARY KEY(\'AdminID\') )')
  db.execute('CREATE TABLE \'Flag\' ( \'FlagID\' INTEGER NOT NULL, \'Description\' TEXT, \'Colour\' TEXT, PRIMARY KEY(\'FlagID\') )')
  db.execute('CREATE TABLE \'Location\' ( \'LocID\' INTEGER NOT NULL, \'Name\' TEXT, PRIMARY KEY(\'LocID\') )')
  db.execute('CREATE TABLE "Offer" ( \'OfferID\' INTEGER NOT NULL, \'Mult\' REAL, \'Description\' TEXT, \'Global\' INTEGER, PRIMARY KEY(\'OfferID\') )')
  db.execute('CREATE TABLE "Order" ( \'OrderNo\' INTEGER NOT NULL, \'UserID\' TEXT, \'FlagID\' INTEGER, \'LocID\' INTEGER, \'Total\' REAL, FOREIGN KEY(\'UserID\') REFERENCES \'User\'(\'UserID\'), FOREIGN KEY(\'LocID\') REFERENCES \'Location\'(\'LocID\'), FOREIGN KEY(\'FlagID\') REFERENCES \'Flag\'(\'FlagID\'), PRIMARY KEY(\'OrderNo\') )')
  db.execute('CREATE TABLE \'Pie\' ( \'PieID\' INTEGER NOT NULL, \'Name\' TEXT, \'Description\' TEXT, \'Price\' REAL, \'Picture\' TEXT, PRIMARY KEY(\'PieID\') )')
  db.execute('CREATE TABLE "PieOrder" ( \'OrderNo\' INTEGER, \'PieID\' TEXT, \'Quantity\' INTEGER, FOREIGN KEY(\'PieID\') REFERENCES \'Pie\'(\'PieID\'), PRIMARY KEY(\'OrderNo\',\'PieID\'), FOREIGN KEY(\'OrderNo\') REFERENCES \'Order\'(\'OrderNo\') )')
  db.execute('CREATE TABLE \'PromoTweet\' ( \'TweetID\' INTEGER, PRIMARY KEY(\'TweetID\') )')
  db.execute('CREATE TABLE \'Tweet\' ( \'TweetID\' TEXT NOT NULL, PRIMARY KEY(\'TweetID\') )')
  db.execute('CREATE TABLE "User" ( \'UserID\' TEXT NOT NULL, \'Postcode\' TEXT, \'HouseNo\' TEXT, \'AddInfo\' TEXT, PRIMARY KEY(\'UserID\') )')
  db.execute('CREATE TABLE "UserOffer" ( \'UserID\' TEXT, \'OfferID\' INTEGER, PRIMARY KEY(\'UserID\',\'OfferID\'), FOREIGN KEY(\'UserID\') REFERENCES \'User\'(\'UserID\'), FOREIGN KEY(\'OfferID\') REFERENCES \'Flag\'(\'FlagID\') )')
  db.execute('INSERT INTO location VALUES (0, \'Leeds\')')
  db.execute('INSERT INTO location VALUES (1, \'Sheffield\')')
  db.execute('INSERT INTO Admin VALUES (0, \'admin\', \'c5cef3fd06042e36b416739e716deb8ba5331824d0af3e48537e84c68e8ff8ad\', \'1c250b6aadc554037a81c0a68d06b8f6\')')
  db.execute('INSERT INTO Flag VALUES (0, \'Recieved\', \'9b9b9b\')')
  db.execute('INSERT INTO Flag VALUES (1, \'Needs Detail\', \'c10000\')')
  db.execute('INSERT INTO Flag VALUES (2, \'Processing\', \'bb5100\')')
  db.execute('INSERT INTO Flag VALUES (3, \'Delivering\', \'bbbb00\')')
  db.execute('INSERT INTO Flag VALUES (4, \'Amend\', \'00a3a0\')')
  db.execute('INSERT INTO Flag VALUES (5, \'Completed\', \'00c903\')')
  db.execute('INSERT INTO Pie VALUES (0, \'Lamb Hotpot\', \'Enjoy this lovely lamb Hotpot (Leeds only)\', 3.30, \'\')')
  db.execute('INSERT INTO Pie VALUES (1, \'Beef pie\', \'It is made of beef\', 2.00, \'\')')
  db.execute('INSERT INTO Pie VALUES (2, \'Lamb pie\', \'This one has lamb\', 2.20, \'\')')
  db.execute('INSERT INTO Pie VALUES (3, \'Chicken pie\', \'Dont be a chicken, get this pie!\', 2.10, \'\')')
  db.execute('INSERT INTO Pie VALUES (4, \'Cherry pie\', \'For the sweeter tooth\', 3.00, \'\')')
end


desc "Run the Sinatra app locally"
task :run do
  Sinatra::Application.run!
end
