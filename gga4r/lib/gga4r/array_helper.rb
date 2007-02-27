class Array
  
  # Shuffles the array modifying its order.
  def shuffle!
    size.downto(1) { |n| push delete_at(rand(n)) }
    self
  end
  
  # Yeilds given bloc using arrays items pair by pair.
  # e.g.
  # <code>
  # ["a","b","c","d"].each_pair do |first, second|
  #  puts second + " - " + second
  # end
  # </code>
  # will print:
  # b - a
  # c - d
  # 
  def each_pair
    num = self.size/2
    (0..num-1).collect do |index|
      yield self[index*2], self[(index*2)+1]
    end
  end
  
  # Splits the array into two parts first from position
  # 0 to "position" and second from position "position+1" to
  # last position.
  # Returns two new arrays.
  def split(position)
   return self[0..position], self[position+1..-1]
  end
  
end
