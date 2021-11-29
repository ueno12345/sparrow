class DomainComponent
  def initialize; end

  def to_auk; end
end

class Domain < DomainComponent
  def initialize
    @constraints = []
  end

  def add(*domain, method_name)
    case method_name
    when :nr_days_a_week
      constraint = DomainNrDays.new(domain.first)
    when :nr_periods
      constraint = DomainNrPeriods.new(domain.first)
    when :unavailable
      constraint = DomainUnavailable.new(domain.first, domain.last)
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
end

class DomainTerm < DomainComponent
end

class DomainUnavailable < DomainComponent
  attr_reader :start_time, :end_time

  def initialize(start_time, end_time)
    @start_time = start_time
    @end_time = end_time
  end

  def to_auk
    <<~AUK
      unavailable start_time: #{@start_time},
                  end_time: #{@end_time}
    AUK
  end
end

class DomainByRoom < DomainComponent
  def initialize(rooms: nil)
    @rooms = rooms
  end
end

class DomainByInstructor < DomainComponent
  def initialize(instructors: nil)
    @instructors = instructors
  end
end
