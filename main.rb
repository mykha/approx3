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
def compress(vectors)

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

f1 = lambda {|a,b,c, x| a*x**2+b*x+c}
f1 = [-> (x){x*x}, -> (x){x}, ->(x){1}]
transformer = lambda do |x, func, coefficients|
  y = 0
  func.each_with_index do |item, index|
    y = y + coefficients[index]*item[x]
  end
  return y
end

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
  #break if array.size==3
end

(0..2).each do
  vvv = shake(all_equations)
  almost_matrix = compress(vvv)
  puts almost_matrix.inspect
end

#d = solve(m)
d = solve_vectors(almost_matrix)
mm = almost_matrix
puts mm[1][0]*d[:x1] + mm[1][1]*d[:x2] + mm[1][2]*d[:x3] == mm[1][3]
puts d.inspect
data.each do |data_item|
  puts "x=#{data_item[:x]}; y=#{data_item[:y]}; y'=#{transformer[data_item[:x],f1, d.values]}"
end

#puts m.inspect
