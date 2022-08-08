class PeriodInitializer < Resource
  attr_reader :periods

  WTABLE = ["Mon", "Tue", "Wed", "Thu", "Fri"].freeze

  def initialize(name = nil)
    super
    @periods = []
  end

  def block_name
    "initialize"
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
        @periods << Period.new("#{WTABLE[day]}#{period + 1}")
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
