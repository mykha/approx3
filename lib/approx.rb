require 'matrix'
require 'byebug'
#solves the system of algebraic equations (3) by the Gauss method using indexes
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

#solves the system of algebraic equations (3) by the Gauss method using vectors
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

#swaps equations randomly
def shake (vectors)

  new_vectors = []

  #array containing the remaining indices that can be used to randomly place the vector
  variants = []
  vectors.each_index{|ind| variants[ind] = ind}

  vectors.each do |v|

    new_vector_index = variants[rand(0..variants.size-1)]
    new_vectors[new_vector_index] = v
    variants.delete(new_vector_index)
  end

  return new_vectors
end

#makes three equations from the redundant system of equations
def compress (vectors)
  size = vectors.size
  part = size/3
  first = Vector[*[0,0,0,0]]
  second = Vector[*[0,0,0,0]]
  third = Vector[*[0,0,0,0]]
  equation = []
  vectors.each do |item|
    if vectors.index(item) < part
      first += item
    end
    if vectors.index(item) >= part && vectors.index(item) < part*2
      second += item
    end
    if vectors.index(item)  >= part*2
      third += item
    end
  end
  equation.append(first, second, third)
end

#calculates the total deviation between the data and the values of the resulting function
# data - approximated data
# func[:equation] - function that approximates the data y = f(A,B,C,x)
# coefficients - A,B,C coefficients
def general_deviation (data, func, coefficients)
  dev = 0
  data.each do |data_item|
    y = func[:equation][coefficients[0], coefficients[1], coefficients[2],data_item[:x]]
    dev += (y - data_item[:y]).abs
  end
  return dev
end

#calculates the MAX deviation between the data and the values of the resulting function
def max_deviation (data, func, coefficients)
  y = func[:equation][coefficients[0], coefficients[1], coefficients[2], data[0][:x]]
  dev = (y - data[0][:y]).abs
  data.each do |data_item|
    y = func[:equation][coefficients[0], coefficients[1], coefficients[2], data_item[:x]]
    new_dev = (y - data_item[:y]).abs
    dev = new_dev if new_dev < dev
  end
  return dev
end

#calculates the local deviation at a specific point (between the given value y and the calculated value of the function f=(A,B,C,x))
def deviation (data_item, func, coefficients)
  y = func[:equation][coefficients[0], coefficients[1], coefficients[2], data_item[:x]]
  return (y - data_item[:y]).abs
end

#get a redundant system of equations from all given data
def get_redundant_system (data, func)
  all_equations = []
  data.each do |data_item|
    arr=[]
    func[:terms].each_with_index do |item, index|
      #arr[index] = item[data_item[:x], data_item[:y]]
      arr << item[data_item[:x], data_item[:y]]
    end
    arr << 1
    all_equations << Vector[*arr.map!(&:to_f)]
  end
  return all_equations
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
