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
            unless el==0 
              fk = 1/el 
            else  
              fk = 0 
            end
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
    #puts st;
  end
  dec[:x3]=mx[2,3]/mx[2,2]
  dec[:x2]=(mx[1,3]-mx[1,2]*dec[:x3])/mx[1,1]
  dec[:x1]=(mx[0,3]-mx[0,2]*dec[:x3]-mx[0,1]*dec[:x2]) / mx[0,0]
  return dec
end

def solve_vectors(mx)

  mx[0] /= mx[0][0]
  mx[1] -= mx[0] * mx[1][0]
  mx[2] -= mx[0] * mx[2][0]

  mx[1] /= mx[1][1]
  mx[2] -= mx[1] * mx[2][1]

  mx[2] /= mx[2][2]

  mx[1] -= mx[2] * mx[1][2]
  mx[0] -= mx[2] * mx[0][2]

  mx[0] -= mx[1] * mx[0][1]

  dec = mx.map{ |vector| vector.to_a }.transpose[-1]

  return {x1: dec[0], x2: dec[1], x3: dec[2]}
end
#test example
=begin
m = Matrix[[2,4.0,1, 5.0],[-1.0,-6.0,3.0, 3.0], [7.0,-2.0,3.0, -4.0]]
puts m.inspect
m.map!(&:to_f)
puts m.inspect
puts solve(m)
puts m.inspect
=end
