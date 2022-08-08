class Room < Resource
  def belongs_to(name)
    @belongs_to = name
  end

  def unavailable(start_time: nil, end_time: nil)
    @domain.add(Time.parse(start_time), Time.parse(end_time), __method__)
  end
end
