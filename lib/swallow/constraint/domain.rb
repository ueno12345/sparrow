class DomainComponent
  def initialize; end

  def to_auk; end

  def prun(ptable, parent); end
end

class Domain < DomainComponent
  attr_reader :constraints

  def initialize
    @constraints = []
  end

  def include?(constraint)
    @constraints.reduce(false) do |result, item|
      result ||= (constraint === item)
    end
  end

  def add(domain, method_name)
    case method_name
    # when :nr_days_a_week
    #   constraint = DomainNrDays.new(domain.first)
    # when :nr_periods
    #   constraint = DomainNrPeriods.new(domain.first)
    when :wday
      constraint = DomainWday.new(domain)
    when :period
      constraint = DomainPeriod.new(domain)
    when :unavailable
      constraint = DomainUnavailable.new(domain)
    when :rooms
      constraint = DomainRooms.new(domain)
    when :instructors
      constraint = DomainInstructors.new(domain)
    when :timeslots
      constraint = DomainTimeslots.new(domain)
    when :term
      constraint = DomainTerm.new(domain)
    end

    @constraints << constraint
  end

  def remove(domain)
    @constraints.delete(domain)
  end

  def to_auk
    auk = ""
    @constraints.each do |constraint|
      auk << constraint.to_auk
    end
    auk
  end

  def prun(ptable, parent)
    @constraints.each do |constraint|
      constraint.prun(ptable, parent)
    end
  end
end

# class DomainNrDays < DomainComponent
#   attr_reader :nr_days_a_week

#   def initialize(nr_days_a_week)
#     @nr_days_a_week = nr_days_a_week
#   end

#   def to_auk
#     <<~AUK
#       nr_days_a_week #{@nr_days_a_week}
#     AUK
#   end
# end

# class DomainNrPeriods < DomainComponent
#   attr_reader :nr_periods

#   def initialize(nr_periods)
#     @nr_periods = nr_periods
#   end

#   def to_auk
#     <<~AUK
#       nr_periods #{@nr_periods}
#     AUK
#   end
# end

class DomainWday < DomainComponent
  attr_reader :wdays

  def initialize(wdays)
    @wdays = wdays
  end

  def to_auk
    <<~AUK
      wday #{@wdays.map { |i| %("#{i}") }.join(",")}
    AUK
  end
end

class DomainPeriod < DomainComponent
  def initialize(periods)
    @periods = periods
  end

  def to_auk
    <<~AUK
      period #{@periods.map { |i| %("#{i}") }.join(",")}
    AUK
  end
end

class DomainTimeslots < DomainComponent
  attr_reader :timeslots

  def initialize(timeslots)
    @timeslots = timeslots
  end

  def to_auk
    <<~AUK
      timeslots #{@timeslots.map { |i| %("#{i}") }.join(",")}
    AUK
  end

  def prun(ptable, parent)
    ptable.reject!{|i| (parent.name == i.lecture.name) && !@timeslots.include?(i.timeslot.name)}
  end
end

class DomainTerm < DomainComponent
  attr_reader :term

  def initialize(term)
    @term = term
  end

  def to_auk
    <<~AUK
      term #{@term}
    AUK
  end
end

class DomainUnavailable < DomainComponent
  attr_reader :unavailable_timeslots

  def initialize(unavailable_timeslots)
    @unavailable_timeslots = unavailable_timeslots
  end

  def to_auk
    <<~AUK
      unavailable #{@unavailable_timeslots.map { |i| %("#{i}") }.join(",")}
    AUK
  end
end

class DomainRooms < DomainComponent
  def initialize(rooms)
    @rooms = rooms
  end

  def to_auk
    <<~AUK
      rooms #{@rooms.map { |i| %("#{i}") }.join(",")}
    AUK
  end

  def prun(ptable, parent)
    ptable.reject!{|i| (parent.name == i.lecture.name) && !@rooms.include?(i.room.name)}
  end
end

class DomainInstructors < DomainComponent
  def initialize(instructors)
    @instructors = instructors
  end

  def to_auk
    <<~AUK
      instructors #{@instructors.map { |i| %("#{i}") }.join(",")}
    AUK
  end

  def prun(ptable, parent)
    ptable.reject!{|i| (parent.name == i.lecture.name) && !@instructors.include?(i.instructor.name)}
  end
end
