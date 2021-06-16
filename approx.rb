require 'matrix'
require 'byebug'
m = Matrix[[2.0,4.0,1.0],[-1.0,-6.0,3.0], [7.0,-2.0,3.0]]
puts m.inspect
#byebug
fk = m[0, 0]
m.each_with_index do|el, row, col|
  #puts "#{el} at [#{row}][#{col}]"
  #byebug
  if col == 0
    fk = 1/el
  end
  m[row,col] = el * fk
end
puts m.inspect

m.each_with_index do|el, row, col|
  #byebug
  if row>0
    m[row,col]=m[row,col]-m[0,col]
  end 
end

puts m.inspect

