class Array
  def to_collection
    Collection.new { |obj| obj.send(self) }
  end
end

class Collection < Array
  def &(other)
    first.product other.last
  end

  def +(other)
    Collection.new((self + other).uniq)
  end

  def *(other)
    if other.is_a?(Numeric)
      Collection.new(select { |item| item.include?(other.to_s) })
    else
      Collection.new(self & other)
    end
  end
end

class NurseCollection < Collection
end

class TimeslotCollection < Collection
end
