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
    # 再帰的な呼び出しを避け、selfとotherを直接結合して処理
    Collection.new(super(other).uniq) # super を使って親クラスの + を呼び出す
  end

  def *(other)
    raise TypeError, "Argument must be a Collection or Array" unless other.is_a?(Collection) || other.is_a?(Array)

    # 配列の共通部分
    Collection.new(to_a & other.to_a)
  end
end

class NurseCollection < Collection
end

class TimeslotCollection < Collection
end
