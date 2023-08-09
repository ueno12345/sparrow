class Array
  def to_collection
    Collection.new{|obj| obj.send(self)}
  end
end

class Collection < Array
    def &(target)
      # 後で考え直す
      # self と target がぐちゃぐちゃ（同じになっている）
      a = self.first.product target.last
      #b = a.to_collection
    return a
    end

#    def *(target)
#      self.select {|x| x.name.include?(target)}
#    end
  end

  class NurseCollection < Collection
  end

  class TimeslotCollection < Collection
end
