class Lecture < Resource
  def rooms(*rooms)
    @domain.add(rooms, __method__)
  end

  def instructors(*instructors)
    @domain.add(instructors, __method__)
  end

  def timeslots(*timeslots)
    @domain.add(timeslots, __method__)
  end

  def frequency(num)
    @domain.add(num, __method__)
  end

  def consecutive(num)
    @domain.add(num, __method__)
  end

  # def term(term)
  #   @domain.add(term, __method__)
  # end

  def belongs_to(name)
    @belongs_to = name
  end

  def domain_period
    @domain.constraints.select { |i| i.is_a?(DomainPeriod) }.first # NOTE: DomainPeriodにマッチする要素はただ一つになる前提
  end
end
