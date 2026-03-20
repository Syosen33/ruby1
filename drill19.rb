def array123(nums)
  if nums.include?(1) && nums.include?(2) && nums.include?(3)
    puts "True"
else
puts "False"
end
end

# 呼び出し例
array123([1, 1, 2, 3, 1]) 
array123([1, 2, 4, ]) 
array123([1, 1, 2, 1, 4, 3]) 