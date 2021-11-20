class Resource
  def initialize(name = nil)
    @name = name
    @domain = Domain.new
    @belongs_to = ""
  end

  def to_auk
    <<-AUK
    #{self.class.name.downcase} "#{@name}" do
      #{@belongs_to.empty? ? nil : "belongs_to #{@belongs_to}"}
    end

    AUK
  end
end

class Period < Resource
  def nr_days_a_week(num)
    @domain.by_period.nr_days_a_week = num
  end

  def nr_periods(num)
    @domain.by_period.nr_periods = num
  end
end

class Room < Resource
  def belongs_to(name)
    @belongs_to = name
  end

  def unavaibale(start_time: nil, end_time: nil)
    @domain.by_period.start_time = Time.parse start_time
    @domain.by_period.end_time = Time.parse end_time
  end
end

class Instructor < Resource
  def belongs_to(name)
    @belongs_to = name
  end

  def unavaibale(start_time: nil, end_time: nil)
    @domain.by_period.start_time = Time.parse start_time
    @domain.by_period.end_time = Time.parse end_time
  end
end

class Lecture < Resource
  def rooms(*rooms)
    @domain.by_room.rooms = rooms
  end

  def instructors(*instructors)
    @domain.by_instructor.instructors = instructors
  end

  def period(*period)
    @domain.by_period.period = period
  end

  def term(term)
    @domain.by_period.term = term
  end

  def belongs_to(name)
    @belongs_to = name
  end
end

class Domain
  attr_reader :by_period, :by_room, :by_instructor

  def initialize
    # @@nr_resources = 0
    # NOTE:Class Var を使わないような設計をする
    @constraints = []
    @by_period = DomainByPeriod.new
    @by_room = DomainByRoom.new
    @by_instructor = DomainByInstructor.new
  end
end

class DomainByPeriod
  attr_accessor :nr_days_a_week, :nr_periods, :unavailable, :term, :period, :start_time, :end_time
end

class DomainByRoom
  attr_accessor :rooms
end

class DomainByInstructor
  attr_accessor :instructors
end
