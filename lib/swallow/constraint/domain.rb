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
    when :frequency
      constraint = DomainFrequency.new(domain)
    when :consecutive
      constraint = DomainConsecutive.new(domain)
    end

    @constraints << constraint
  end

  def remove(method_name)
    case method_name
    when :wday
      @constraints.delete_if{|constraint| constraint.is_a? DomainWday}
    when :period
      @constraints.delete_if{|constraint| constraint.is_a? DomainPeriod}
    when :unavailable
      @constraints.delete_if{|constraint| constraint.is_a? DomainUnavailable}
    when :rooms
      @constraints.delete_if{|constraint| constraint.is_a? DomainRooms}
    when :instructors
      @constraints.delete_if{|constraint| constraint.is_a? DomainInstructors}
    when :timeslots
      @constraints.delete_if{|constraint| constraint.is_a? DomainTimeslots}
    when :term
      @constraints.delete_if{|constraint| constraint.is_a? DomainTerm}
    when :frequency
      @constraints.delete_if{|constraint| constraint.is_a? DomainFrequency}
    when :consecutive
      @constraints.delete_if{|constraint| constraint.is_a? DomainConsecutive}
    end
  end

  def update(domain, method_name)
    remove(method_name)
    add(domain, method_name)
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

  def prun(ptable, parent)
    # require 'pry'
    # binding.pry
    case parent
    when Room
      ptable.reject!{|i| (parent.name == i.room.name) && @unavailable_timeslots.include?(i.timeslot.name)}
    when Instructor
      ptable.reject!{|i| (parent.name == i.instructor.name) && @unavailable_timeslots.include?(i.timeslot.name)}
    when TimeslotInitializer
      ptable.reject!{|i| @unavailable_timeslots.include?(i.timeslot.name)}
    end
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

class DomainFrequency < DomainComponent
  def initialize(frequency)
    @frequency = frequency
  end

  def to_auk
    <<~AUK
      frequency #{@frequency}
    AUK
  end
end

class DomainConsecutive < DomainComponent
  def initialize(consecutive)
    @consecutive = consecutive
  end

  def to_auk
    <<~AUK
      consecutive #{@consecutive}
    AUK
  end
end
