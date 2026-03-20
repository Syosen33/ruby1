def police_trouble(a, b)
  if (a&&b) ||(!a && !b)
      puts "tTue"
  else
    puts "False"
  end
end

# 呼び出し例
police_trouble(true, true) 
police_trouble(false, false)
police_trouble(true, false)