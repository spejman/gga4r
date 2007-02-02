class Array
  def shuffle!
    size.downto(1) { |n| push delete_at(rand(n)) }
    self
  end
  
  def each_pair
    num = self.size/2
    (0..num-1).collect do |index|
      yield self[index*2], self[(index*2)+1]
    end
  end
  
  def split(position)
   return self[0..position], self[position+1..-1]
  end
  
end
