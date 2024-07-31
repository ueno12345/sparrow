class Array
  def to_collection
    Collection.new { |obj| obj.send(self) }
  end
end

class Collection < Array
  def &(other)
    # 後で考え直す
    # self と target がぐちゃぐちゃ（同じになっている）
    first.product other.last
  end

  # def *(other)
  #  self.select { |x| x.name.include?(other) }
  # end
end

class NurseCollection < Collection
end

class TimeslotCollection < Collection
end
