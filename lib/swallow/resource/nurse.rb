class Nurse < Resource
  def timeslots(*timeslots)
    @domain.add(timeslots, __method__)
  end

  #  def domain_timeslot
  #    @domain.constraints.select { |i| i.is_a?(DomainTimeslots) }.first # NOTE: DomainPeriodにマッチする要素はただ一つになる前提
  #  end

  #  def unavailable(*timeslots)
  #    @domain.add(timeslots, __method__)
  #  end

  def ladder(num)
    @domain.add(num, __method__)
  end

  def groups(*groups)
    @domain.add(groups, __method__)
  end

  def team(team)
    @domain.add(team, __method__)
  end

  def domain_exec(ptable, node)
    # Ravensat::Claw.exactly_one(ptable.select do |i|
    #   timeslots.uniq.include? i.timeslot.name
    # end.select { |j| nurses.uniq.include? j.nurse.name }.map(&:value))
    return @domain.exec(ptable, self) if node.domain.constraints.empty?

    nodes = ptable.select do |i|
      (node.name == i.nurse.name) && (node.domain.constraints.first.timeslots.any? do |timeslot|
                                        timeslot == i.timeslot.name
                                      end)
    end.map(&:value).map { |value| [value] }

    nodes.each do |n|
      Ravensat::Claw.exactly_one(n)
    end
  end
end
