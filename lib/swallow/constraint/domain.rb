class DomainComponent
  def initialize; end

  def to_auk; end

  def prun(ptable, parent); end
  def exec(ptable, parent); end
end

class DomainExecutor < DomainComponent
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
    when :days
      constraint = DomainDays.new(domain)
    when :period
      constraint = DomainPeriod.new(domain)
#    when :unavailable
#      constraint = DomainUnavailable.new(domain)
    when :timeslots
      constraint = DomainTimeslots.new(domain)
#    when :term
#      constraint = DomainTerm.new(domain)
#    when :frequency
#      constraint = DomainFrequency.new(domain)
#    when :consecutive
#      constraint = DomainConsecutive.new(domain)
    when :rem
      constraint = DomainRem.new(domain)
#    when :at_least
#      constraint = DomainAtLeast.new(domain)
#    when :at_most
#      constraint = DomainAtMost.new(domain)
    end

    @constraints << constraint
  end

  def remove(method_name)
    case method_name
    when :days
      @constraints.delete_if{|constraint| constraint.is_a? DomainDays}
    when :period
      @constraints.delete_if{|constraint| constraint.is_a? DomainPeriod}
#    when :unavailable
#      @constraints.delete_if{|constraint| constraint.is_a? DomainUnavailable}
    when :timeslots
      @constraints.delete_if{|constraint| constraint.is_a? DomainTimeslots}
#    when :term
#      @constraints.delete_if{|constraint| constraint.is_a? DomainTerm}
#    when :frequency
#      @constraints.delete_if{|constraint| constraint.is_a? DomainFrequency}
#    when :consecutive
#      @constraints.delete_if{|constraint| constraint.is_a? DomainConsecutive}
#    when :at_least
#      @constraints.delete_if{|constraint| constraint.is_a? DomainAtLeast}
#    when :at_most
#      @constraints.delete_if{|constraint| constraint.is_a? DomainAtMost}
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

  def exec(ptable, parent)
    cnf = Ravensat::InitialNode.new
    @constraints.select{|d| d.is_a? DomainExecutor}.each do |constraint|
      cnf &= constraint.exec(ptable, parent)
    end
    cnf
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

class DomainDays < DomainComponent
  attr_reader :pdays

  def initialize(pdays)
    @pdays = pdays
  end

  def to_auk
    <<~AUK
      days #{@pdays.map { |i| %("#{i}") }.join(",")}
    AUK
  end
end

class DomainPeriod < DomainComponent
  attr_reader :periods

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
    if @timeslots.blank?
      ""
    else
      <<~AUK
        timeslots #{@timeslots.map { |i| %("#{i}") }.join(",")}
      AUK
    end
  end

  def prun(ptable, parent)
    ptable.reject!{|i| (parent.name == i.nurse.name) && !@timeslots.include?(i.timeslot.name)}
  end
end

#class DomainTerm < DomainComponent
#  attr_reader :term

#  def initialize(term)
#    @term = term
#  end

#  def to_auk
#    <<~AUK
#      term #{@term}
#    AUK
#  end
#end

#class DomainUnavailable < DomainComponent
#  attr_reader :unavailable_timeslots

#  def initialize(unavailable_timeslots)
#    @unavailable_timeslots = unavailable_timeslots
#  end

#  def to_auk
#    <<~AUK
#      unavailable #{@unavailable_timeslots.map { |i| %("#{i}") }.join(",")}
#    AUK
#  end

#  def prun(ptable, parent)
    # require 'pry'
    # binding.pry

#    case parent
#    when TimeslotInitializer
#      ptable.reject!{|i| @unavailable_timeslots.include?(i.timeslot.name)}
#    end
#  end
#end

#class DomainFrequency < DomainExecutor
#  def initialize(frequency)
#    @frequency = frequency
#  end

#  def to_auk
#    <<~AUK
#      frequency #{@frequency}
#    AUK
#  end

#  def exec(ptable, parent)
#    cnf = Ravensat::InitialNode.new

#    cnf &= Ravensat::Claw.exactly_k(ptable.select{|i| i.nurse.name == parent.name}.map(&:value), @frequency)
#    cnf
#  end

#  def exec(ptable, parent)
#    cnf = Ravensat::InitialNode.new
#    cnf &= Ravensat::Claw.exactly_k(ptable.select{|i| i.nurse.name == parent.name || i.timeslot.name == parent.name}.map(&:value), @frequency)
    #cnf &= Ravensat::Claw.at_most_k(ptable.select{|i| i.nurse.name == parent.name || i.timeslot.name == parent.name}.map(&:value), @frequency)
#    cnf
#  end
#end

#class DomainConsecutive < DomainExecutor
#  def initialize(consecutive)
#    @consecutive = consecutive
#  end

#  def to_auk
#    <<~AUK
#      consecutive #{@consecutive}
#    AUK
#  end

#  def exec(ptable, parent)
#    c_vars = []
#    cnf = Ravensat::InitialNode.new
#    ptable.select{|i| i.nurse.name == parent.name}.map(&:value).each_cons(@consecutive) do |node_group|
#      c = Ravensat::VarNode.new
#      c_vars.append c
#      cnf &= node_group.map{|node| node | ~c}.reduce(:&)
#    end
#    cnf &= Ravensat::Claw.commander_amo(c_vars)
#    cnf &= Ravensat::Claw.alo(c_vars)
#    cnf
#  end
#end

class DomainRem < DomainComponent
  def initialize(comment)
    @comment = comment
  end

  def to_auk
    <<~AUK
      rem "#{@comment}"
    AUK
  end
end

#class DomainAtLeast < DomainExecutor
#  def initialize(at_least)
#    @at_least = at_least
#  end

#  def to_auk
#    <<~AUK
#      at_least #{@at_least}
#    AUK
#  end

#  def exec(ptable, parent)
#    cnf = Ravensat::InitialNode.new
#    cnf &= Ravensat::Claw.at_least_k(ptable.select{|i| i.nurse.name == parent.name}.map(&:value), @at_least)
#    cnf
#  end

#  def exec(ptable, parent)
#    cnf = Ravensat::InitialNode.new
#    cnf &= Ravensat::Claw.at_least_k(ptable.select{|i| i.nurse.name == parent.name || i.timeslot.name == parent.name}.map(&:value), @at_least)
#    cnf
#  end
#end

#class DomainAtMost < DomainExecutor
#  def initialize(at_most)
#    @at_most = at_most
#  end

#  def to_auk
#    <<~AUK
#      at_most #{@at_most}
#    AUK
#  end

#  def exec(ptable, parent)
#    cnf = Ravensat::InitialNode.new
#    cnf &= Ravensat::Claw.commander_at_most_k(ptable.select{|i| i.nurse.name == parent.name}.map(&:value), @at_most)
#    cnf
#  end

#  def exec(ptable, parent)
#    cnf = Ravensat::InitialNode.new
#    cnf &= Ravensat::Claw.commander_at_most_k(ptable.select{|i| i.nurse.name == parent.name || i.timeslot.name == parent.name}.map(&:value), @at_most)
#    cnf
#  end
#end
