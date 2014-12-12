class UniqueArray
  def initialize(arr)
    uniq(arr)
  end

  def uniq(arr)
    track = Hash.new
    arr.each_with_index do |num, index|
      unless track[num]
        track[num] = Array.new
      end
      track[num].push(index)
    end
    track.each do |key, value|
       puts "number: #{key} at index #{value}" if value.count == 1
    end
  end
end

UniqueArray.new([1, 2, 3, 4, 5, 5, 6, 7, 7, 7, 5, 6, 2, 1, 5, 9])
