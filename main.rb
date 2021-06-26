$LOAD_PATH << Dir.pwd
require './lib/approx'
require './lib/getdata'

f1 = lambda {|a,b,c, x| a*x**2+b*x+c}
f1 = [-> (x){x*x}, -> (x){x}, ->(x){1}]
puts f1[0].(22)
arr=[]
array = []
i=-1
d = data_from_file
d.each do |data_item|
  f1.each_with_index do |item, index|
    arr[index] = item[data_item[:x]]
  end
  arr[3] = data_item[:y]
  array[i+=1] = Array.new(arr)
  break if array.size==3
end

#array = [[1,2,-3,-2],[3,4,-5,-3],[2,4,1,-2]]
m = Matrix[*array]
#puts m.determinant
m.map!(&:to_f)
#byebug
# puts solve(m).inspect
d = solve(m)
mm = Matrix[*array]
puts mm[1,0]*d[:x1] + mm[1,1]*d[:x2] + mm[1,2]*d[:x3] == mm[1,3]

#puts m.inspect
