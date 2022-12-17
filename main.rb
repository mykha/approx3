$LOAD_PATH << Dir.pwd
require './lib/approx'
require './lib/getdata'

ITERATIONS_TO_FIT = 1000

f1 = { terms: [->(x, y) { x * x / y }, ->(x, y) { x / y }, ->(_x, y) { 1 / y }], equation: lambda { |a, b, c, x|
  a * x * x + b * x + c
} } # parabola
f2 = { terms: [->(_x, y) { 1 / y }, ->(x, y) { 1 / (x * y) }, lambda { |x, y|
  1 / (y * x * x)
}], equation: lambda { |a, b, c, x|
                a + b / x + c / (x * x)
              } }
f3 = { terms: [->(x, y) { x * y }, ->(_x, y) { y }, ->(x, y) { y / x }], equation: lambda { |a, b, c, x|
  x / (a * x * x + b * x + c)   
} }

functions = [f1, f2, f3]
# functions = [f2, f3]

if ARGV.count == 0
  data = data_from_public
else
  data = data_from_file ARGV[0]
end
best_solution = {}

# get a first approximation
all_equations = get_redundant_system(data, functions[0])
almost_matrix = compress(all_equations)
best_solution[:coefficients] = solve_vectors(almost_matrix)
best_solution[:function] = functions[0]
best_solution[:general_deviation] = general_deviation(data, functions[0], best_solution[:coefficients].values)

functions.each_with_index do |func, f_ind|

  #puts f_ind
  # search for approximation with minimum deviation
  for i in (0..ITERATIONS_TO_FIT)
    vvv = shake(all_equations)
    almost_matrix = compress(vvv)
    d = solve_vectors(almost_matrix)
    g_dev = general_deviation(data, func, d.values)
    next unless g_dev < best_solution[:general_deviation]

    best_solution[:coefficients] = d
    best_solution[:function] = func
    best_solution[:general_deviation] = g_dev
  end
end

d = best_solution[:coefficients]
puts 'Approximation of an array of points' 
puts data.inspect
puts 'by functions:'
puts '1. Y = A*x*x + B*x + C'
puts '2. Y = A + B/x + C/(x*x)'
puts '3. Y = x/ (A*x*x + B*x + C)'
puts "Function number #{functions.map.with_index do |e, i|
  i+1 if e == best_solution[:function]
end.compact} has the best result"
puts "MIN Deviation #{best_solution[:general_deviation]}"
puts 'Equation coefficients:'
puts "A = #{d[:x1]}, B = #{d[:x2]}, C = #{d[:x3]},"
# puts best_solution[:general_deviation]
# puts best_solution[:function].inspect
puts 'Result of approximation by poins:'
data.each do |data_item|
  puts "x=#{data_item[:x]}; y=#{data_item[:y]}; y'=#{best_solution[:function][:equation][d.values[0], d.values[1],
                                                                                         d.values[2], data_item[:x]]}; deviation = #{deviation(
                                                                                           data_item, best_solution[:function], d.values
                                                                                         )}"
end
