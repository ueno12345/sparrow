require_relative "domain"

class Resource
  def initialize(name = nil)
    @name = name
    @domain = Domain.new
    @belongs_to = ""
  end

  def to_auk
    <<~AUK
      #{self.class.name.downcase} #{@name ? "\"#{@name}\"" : nil} do
        #{@domain.to_auk}
        #{@belongs_to.empty? ? nil : "belongs_to \"#{@belongs_to}\""}
      end

    AUK
  end
end

class Period < Resource
  def nr_days_a_week(num)
    @domain.add(num, __method__)
  end

  def nr_periods(num)
    @domain.add(num, __method__)
  end
end

class Room < Resource
  def belongs_to(name)
    @belongs_to = name
  end

  def unavailable(start_time: nil, end_time: nil)
    @domain.add(Time.parse(start_time), Time.parse(end_time), __method__)
  end
end

class Instructor < Resource
  def belongs_to(name)
    @belongs_to = name
  end

  def unavailable(start_time: nil, end_time: nil)
    @domain.add(Time.parse(start_time), Time.parse(end_time), __method__)
  end
end

class Lecture < Resource
  def rooms(*rooms)
    @domain.add(rooms, __method__)
  end

  def instructors(*instructors)
    @domain.add(instructors, __method__)
  end

  def period(*period)
    @domain.add(period, __method__)
  end

  def term(term)
    @domain.add(term, __method__)
  end

  def belongs_to(name)
    @belongs_to = name
  end
end
