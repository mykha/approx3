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
    y = @transformer[data_item[:x], func, coefficients]
    dev += (y - data_item[:y]).abs
  end
  return dev
end
def max_deviation (data, func, coefficients)
  y = @transformer[data[0][:x], func, coefficients]
  dev = (y - data[0][:y]).abs
  data.each do |data_item|
    y = @transformer[data_item[:x], func, coefficients]
    new_dev = (y - data_item[:y]).abs
    dev = new_dev if new_dev < dev
  end
  return dev
end
def deviation (data_item, func, coefficients)
  y = @transformer[data_item[:x], func, coefficients]
  return (y - data_item[:y]).abs
end

f1 = lambda {|a,b,c, x| a*x**2+b*x+c}
f1 = [-> (x){x*x}, -> (x){x}, ->(x){1}]


arr=[]
array = []
almost_matrix = []
i=-1
data = data_from_file
all_equations = []
data.each do |data_item|
  f1.each_with_index do |item, index|
    arr[index] = item[data_item[:x]]
  end
  arr[3] = data_item[:y]
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
  puts "x=#{data_item[:x]}; y=#{data_item[:y]}; y'=#{@transformer[data_item[:x],f1, d.values]}; deviation = #{deviation(data_item, f1, d.values)}"
end

#puts m.inspect
