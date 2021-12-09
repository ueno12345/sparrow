class DomainComponent
  def initialize; end

  def to_auk; end
end

class Domain < DomainComponent
  def initialize
    @constraints = []
  end

  def include?(constraint)
    @constraints.reduce(false) do |result, item|
      result ||= (constraint === item)
    end
  end

  def add(*domain, method_name)
    case method_name
    when :nr_days_a_week
      constraint = DomainNrDays.new(domain.first)
    when :nr_periods
      constraint = DomainNrPeriods.new(domain.first)
    when :unavailable
      constraint = DomainUnavailable.new(domain.first, domain.last)
    when :rooms
      constraint = DomainRooms.new(domain.first)
    when :instructors
      constraint = DomainInstructors.new(domain.first)
    when :period
      constraint = DomainPeriod.new(domain.first)
    when :term
      constraint = DomainTerm.new(domain.first)
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
end

class DomainNrDays < DomainComponent
  attr_reader :nr_days_a_week

  def initialize(nr_days_a_week)
    @nr_days_a_week = nr_days_a_week
  end

  def to_auk
    <<~AUK
      nr_days_a_week #{@nr_days_a_week}
    AUK
  end
end

class DomainNrPeriods < DomainComponent
  attr_reader :nr_periods

  def initialize(nr_periods)
    @nr_periods = nr_periods
  end

  def to_auk
    <<~AUK
      nr_periods #{@nr_periods}
    AUK
  end
end

class DomainPeriod < DomainComponent
  attr_reader :period

  def initialize(period)
    @period = period
  end

  def to_auk
    <<~AUK
      period #{@period.map { |i| %("#{i}") }.join(",")}
    AUK
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
  attr_reader :start_time, :end_time

  def initialize(start_time, end_time)
    @start_time = start_time
    @end_time = end_time
  end

  def to_auk
    <<~AUK
      unavailable start_time: "#{@start_time.strftime("%Y/%m/%d %H:%M")}",
                  end_time: "#{@end_time.strftime("%Y/%m/%d %H:%M")}"
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
end
