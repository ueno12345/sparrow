class Room < Resource
  def belongs_to(name)
    @belongs_to = name
  end

  def unavailable(*timeslots)
    @domain.add(timeslots, __method__)
  end
end
