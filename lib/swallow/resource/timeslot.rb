class TimeslotInitializer < Resource
  attr_reader :timeslots

  # WTABLE = ["Mon", "Tue", "Wed", "Thu", "Fri"].freeze

  def initialize(name = nil)
    super
    @timeslots = []
  end

  def block_name
    "timeslot"
  end

  def days(*pdays)
    @pdays = pdays
    @domain.add(@pdays, __method__)
    timeslot_initialize
  end

  def period(*periods)
    @periods = periods
    @domain.add(@periods, __method__)
    timeslot_initialize
  end

#  def unavailable(*timeslots)
#    @domain.add(timeslots, __method__)
#  end
  # def nr_days_a_week(num)
  #   @domain.add(num, __method__)
  #   period_initialize
  # end

  # def nr_periods(num)
  #   @domain.add(num, __method__)
  #   period_initialize
  # end

  private

  def timeslot_initialize
    return unless @pdays && @periods

    @pdays.each do |day|
      @periods.each do |period|
        @timeslots << Timeslot.new("#{day}#{period}")
      end
    end
  end
end

class Timeslot < Resource
  def initialize(name = nil)
    super
  end

#  def frequency(num)
#    @domain.add(num, __method__)
#  end

#  def at_least(num)
#    @domain.add(num, __method__)
#  end

#  def at_most(num)
#    @domain.add(num, __method__)
#  end

  def to_auk; end
end
