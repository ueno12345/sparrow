# coding: utf-8
class Nurse < Resource
#  def timeslots(*timeslots)
#    @domain.add(timeslots, __method__)
#  end

#  def frequency(num)
#    @domain.add(num, __method__)
#  end

#  def consecutive(num)
#    @domain.add(num, __method__)
#  end

#  def at_least(num)
#    @domain.add(num, __method__)
#  end

#  def at_most(num)
#    @domain.add(num, __method__)
#  end

  # def term(term)
  #   @domain.add(term, __method__)
  # end

#  def belongs_to(name)
#    @belongs_to = name
#  end

#  def domain_timeslot
#    @domain.constraints.select { |i| i.is_a?(DomainTimeslots) }.first # NOTE: DomainPeriodにマッチする要素はただ一つになる前提
#  end

#  def unavailable(*timeslots)
#    @domain.add(timeslots, __method__)
#  end

  def team(str)
    @domain.add(str, __method__)
  end

  def ladder(num)
    @domain.add(num, __method__)
  end

  def group(*groups)
    @domain.add(groups, __method__)
  end

end
