class Array
  def to_collection
    Collection.new{|obj| obj.send(self)}
  end
end

class Collection < Array
    def &(target)
      a = self.product target

      b = a.to_collection
    return b
    end

#    def *(target)
#      self.select {|x| x.name.include?(target)}
#    end
  end

  class NurseCollection < Collection
  end

  class TimeslotCollection < Collection
end
