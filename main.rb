$LOAD_PATH << Dir.pwd
require './lib/approx'
require './lib/getdata'
ITERATIONS_TO_FIT = 1000

f1 = {terms: [-> (x,y){x*x/y}, -> (x,y){x/y}, ->(x,y){1/y}], equation: -> (a,b,c,x){a*x*x+b*x+c}} #parabola
f2 = {terms: [-> (x,y){1/y}, -> (x,y){1/(x*y)}, ->(x,y){1/(y*x*x)}], equation: -> (a,b,c,x){a + b/x + c/(x*x)}}
f3 = {terms: [-> (x,y){x*y}, -> (x,y){y}, ->(x,y){y/x}], equation: -> (a,b,c,x){x/(a*x*x+b*x+c)}}

functions = [f1, f2, f3]
#functions = [f2, f3]

data = data_from_file
best_solution = {}

#get a first approximation
all_equations = get_redundant_system(data, functions[0])
almost_matrix = compress(all_equations)
best_solution[:coefficients] = solve_vectors(almost_matrix)
best_solution[:function] = functions[0]
best_solution[:general_deviation] = general_deviation(data, functions[0], best_solution[:coefficients].values)

functions.each do |func|

  #search for approximation with minimum deviation
  for i in (0..ITERATIONS_TO_FIT)
    vvv = shake(all_equations)
    almost_matrix = compress(vvv)
    d = solve_vectors(almost_matrix)
    g_dev = general_deviation(data, func, d.values)
    if g_dev < best_solution[:general_deviation]
      best_solution[:coefficients] = solve_vectors(almost_matrix)
      best_solution[:function] = func
      best_solution[:general_deviation] = g_dev
    end
  end

end

d = best_solution[:coefficients]
puts d.inspect
puts best_solution[:general_deviation]
puts best_solution[:function].inspect
data.each do |data_item|
  puts "x=#{data_item[:x]}; y=#{data_item[:y]}; y'=#{best_solution[:function][:equation][d.values[0], d.values[1], d.values[2],data_item[:x]]}; deviation = #{deviation(data_item, best_solution[:function], d.values)}"
end

