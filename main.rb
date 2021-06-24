$LOAD_PATH << Dir.pwd
require './lib/approx'

m = Matrix[["1",1,"1",1],[1,1,1,1],[-2,-5,7,8]]
#puts m.determinant
m.map!(&:to_f)
puts solve(m).inspect
#приводим к единице

puts m.inspect