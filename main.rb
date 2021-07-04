$LOAD_PATH << Dir.pwd
require './lib/approx'
require './lib/getdata'

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

def general_deviation (data, func, coefficients)
  dev = 0
  data.each do |data_item|
    y = func[:equation][coefficients[0], coefficients[1], coefficients[2],data_item[:x]]
    dev += (y - data_item[:y]).abs
  end
  return dev
end
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
def deviation (data_item, func, coefficients)
  y = func[:equation][coefficients[0], coefficients[1], coefficients[2], data_item[:x]]
  return (y - data_item[:y]).abs
end

f1 = lambda {|a,b,c, x| a*x**2+b*x+c}
f1 = {terms: [-> (x,y){x*x/y}, -> (x,y){x/y}, ->(x,y){1/y}], equation: -> (a,b,c,x){a*x*x+b*x+c}}
f2 = {terms: [-> (x,y){x*y}, -> (x,y){y}, ->(x,y){y/x}], equation: -> (a,b,c,x){x/(a*x*x+b*x+c)}}
f3 = [-> (x){1/(x*x)}, -> (x){1/x}, ->(x){1}]
functions = [f1,f2]

arr=[]
array = []
almost_matrix = []
i=-1
data = data_from_file
all_equations = []
data.each do |data_item|
  f1[:terms].each_with_index do |item, index|
    arr[index] = item[data_item[:x], data_item[:y]]
  end
  arr[3] = 1
  all_equations[i+=1] = Vector[*arr.map!(&:to_f)]
end

almost_matrix = compress(all_equations)
best_solution = solve_vectors(almost_matrix)
min_dev = general_deviation(data, f1, best_solution.values)
for i in (0..500)
  vvv = shake(all_equations)
  almost_matrix = compress(vvv)
  d = solve_vectors(almost_matrix)
  g_dev = general_deviation(data, f1, d.values)
  if g_dev < min_dev
    best_solution = d
    min_dev = g_dev
  end
end

#d = solve(m)
#d = solve_vectors(almost_matrix)
#mm = almost_matrix
#puts mm[1][0]*d[:x1] + mm[1][1]*d[:x2] + mm[1][2]*d[:x3] == mm[1][3]
d = best_solution
puts d.inspect
puts min_dev
data.each do |data_item|
  puts "x=#{data_item[:x]}; y=#{data_item[:y]}; y'=#{f1[:equation][d.values[0], d.values[1], d.values[2],data_item[:x]]}; deviation = #{deviation(data_item, f1, d.values)}"
end

#puts m.inspect
