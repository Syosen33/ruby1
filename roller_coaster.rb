ride_count = 0
friends = []

puts "お友達お名前は？"
friends << gets.chomp
puts "お友達の身長は？"
friends << gets.to_i
ride_count += 1

puts "お友達の名前は？"
friends << gets.chomp
puts "お友達の身長は？"
friends << gets.to_i
ride_count += 1

puts "お友達の名前は？"
friends << gets.chomp
puts "お友達の身長は？"
friends << gets.to_i
ride_count += 1

puts "乗車するのは#{ride_count}人です"