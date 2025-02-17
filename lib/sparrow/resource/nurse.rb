class Nurse < Resource
  def timeslots(*timeslots)
    @domain.add(timeslots, __method__)
  end

  def ladder(num)
    @domain.add(num, __method__)
  end

  def groups(*groups)
    @domain.add(groups, __method__)
  end

  def team(team)
    @domain.add(team, __method__)
  end
end
