class DomainComponent
  def initialize; end

  def to_auk; end
end

class Domain < DomainComponent
  def initialize
    @constraints = []
  end

  def add(domain)
    @constraints << domain
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

class DomainByPeriod < DomainComponent
  def initialize(nr_days_a_week: nil, nr_periods: nil, period: nil, term: nil, start_time: nil, end_time: nil)
    @nr_days_a_week = nr_days_a_week
    @nr_periods = nr_periods
    @period = period
    @term = term
    @start_time = start_time
    @end_time = end_time
  end
end

class DomainByRoom
  def initialize(rooms: nil)
    @rooms = rooms
  end
end

class DomainByInstructor
  def initialize(instructors: nil)
    @instructors = instructors
  end
end
