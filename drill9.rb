input = gets.to_i

if input <= 0
  puts "0以下の数字です"
elsif input <= 10
  puts "10以下の数字です"
else
  puts "10より大きい数字です"
end