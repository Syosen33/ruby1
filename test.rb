def multiplication(num1, num2)
  puts "#{num1}と#{num2}をかけた答えは#{num1 * num2}です！"
end

puts "最初の数字を入力してください"

num1 = gets.to_i

puts "2番目の数字を入力してください"

num2 = gets.to_i

multiplication(num1, num2)