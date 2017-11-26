require 'digest/sha1'

Invent.delete_all
User.delete_all

users = [["mengwang", "mengwang", "Meng", "Wang"],
         ["userX", "userX", "Jack", "Chen"]]

users.each do |entry|
  user = User.new
  user.username = entry[0]
  user.password = entry[1]
  user.first_name = entry[2]
  user.last_name = entry[3]
  user.api_key = Digest::SHA1.hexdigest(user.username)
  user.save
end

puts "There are now #{User.count} users"



invents = [["A123", "In Stock", 600],
              ["A123", "Shipped", 300],
              ["A123", "Preparing for Shipment", 50],
              ["A123", "Returned in Good Condition", 40],
              ["A123", "Returned in Bad Condition",10],
              ["B987", "In Stock", 981],
              ["B987", "Shipped", 19]]


invents.each do |entry|
  invent = Invent.new
  invent.user_id = 1
  invent.sku = entry[0]
  invent.status = entry[1]
  invent.qty = entry[2]
  invent.save
end

puts "There are now #{Invent.count} invents rows"
