require 'matrix'
require 'byebug'

def solve(mx)
  dec={}
  #byebug
  (0..mx.row_count-2).each do |st| 
    fk = mx[st, st]
    mx.each_with_index do|el, row, col|
      #byebug
      if row >= st && col >= st
        if col == st 
            fk = 1/el
        end
        mx[row,col] = el * fk
      end
    end

    mx.each_with_index do|el, row, col|
      #byebug
      if row>st
        mx[row,col]=mx[row,col]-mx[st,col]
      end 
    end
    #byebug
    puts st;
  end
  dec[:x3]=mx[2,3]/mx[2,2]
  dec[:x2]=(mx[1,3]-mx[1,2]*dec[:x3])/mx[1,1]
  dec[:x1]=(mx[0,3]-mx[0,2]*dec[:x3]-mx[0,1]*dec[:x2]) / mx[0,0]
  return dec
end

m = Matrix[[2.0,4.0,1.0, 5.0],[-1.0,-6.0,3.0, 3.0], [7.0,-2.0,3.0, -4.0]]
puts m.inspect

puts solve(m)

puts m.inspect
