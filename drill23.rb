def num(a, b, c)
  ab = a + b
  if c <= 3
    puts ab / c
  else
    puts ab * c
  end
end

# 呼び出し例
num(1,5,3)