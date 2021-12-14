require_relative "domain"

class Resource
  attr_reader :name

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

  def to_cnf(ptable); end
end

class PeriodInitializer < Resource
  attr_reader :periods

  def initialize(name = nil)
    super
    @periods = []
  end

  def nr_days_a_week(num)
    @domain.add(num, __method__)
    period_initialize
  end

  def nr_periods(num)
    @domain.add(num, __method__)
    period_initialize
  end

  private

  def period_initialize
    return unless @domain.include?(DomainNrDays) && @domain.include?(DomainNrPeriods)

    @domain.constraints.first.nr_days_a_week.to_i.times do |day|
      @domain.constraints.last.nr_periods.to_i.times do |period|
        @periods << Period.new("#{day + 1}-#{period + 1}")
      end
    end
  end
end

class Period < Resource
  def initialize(name = nil)
    super
  end

  def to_auk; end
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
