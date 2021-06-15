m = Dir.entries "./"
data=[]
m.each do |fname|
  if fname[-4..fname.size]== ".txt"
    input = File.open fname, "r"
    while (line = input.gets)
      coup = line.split " "
      if coup[0]
      
      data << {:x => coup[0].to_f, :y => coup[1].to_f}
      end
    end
    data.select! do |item|
      item[:x]!=nil
    end
    puts data.inspect
    exit
  end
end
