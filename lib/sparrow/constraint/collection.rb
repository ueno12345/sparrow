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
    Collection.new(super(other).uniq)
  end

  def *(other)
    raise TypeError, "Argument must be a Collection or Array" unless other.is_a?(Collection) || other.is_a?(Array)

    Collection.new(to_a & other.to_a)
  end
end

class NurseCollection < Collection
end

class TimeslotCollection < Collection
end
