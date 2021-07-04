def data_from_file
  m = Dir.entries "./public"
  data = []
  m.each do |fname|
    #if fname[-4..fname.size] == ".txt"
     if fname[-5..fname.size] == "2.txt"
      input = File.open "./public/"+fname, "r"
      while (line = input.gets)
        coup = line.split " "
        if coup[0]
          data << { :x => coup[0].to_f, :y => coup[1].to_f }
        end
      end
      # to skip nil values
      data.select! {|item| item[:x] != nil }
      #puts data.inspect
      return data
    end
  end
end
