require 'matrix'
m = Matrix[[3,2,4],[-3,2,4],[-2,-5,7]]
puts m.determinant
puts m.inspect
#приводим к единице
m.each_with_index do |el, row, col|
    if col == 0
        fk = 1/el 
    else
        el = el*fk
    end 
end
puts m.inspect