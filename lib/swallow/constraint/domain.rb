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
    when :days
      constraint = DomainDays.new(domain)
    when :period
      constraint = DomainPeriod.new(domain)
    #    when :unavailable
    #      constraint = DomainUnavailable.new(domain)
    when :group
      constraint = DomainGroup.new(domain)
    when :ladder
      constraint = DomainLadder.new(domain)
    when :timeslots
      constraint = DomainTimeslots.new(domain)
    when :rem
      constraint = DomainRem.new(domain)
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
    when :group
      @constraints.delete_if{|constraint| constraint.is_a? DomainGroup}
    when :ladder
      @constraints.delete_if{|constraint| constraint.is_a? DomainLadder}
    when :timeslots
      @constraints.delete_if{|constraint| constraint.is_a? DomainTimeslots}
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

class DomainGroup < DomainComponent
  attr_reader :groups

  def initialize(groups)
    @groups = groups
  end

  def to_auk
    <<~AUK
      group #{@groups.map { |i| %("#{i}") }.join(",")}
    AUK
  end
end

class DomainLadder < DomainComponent
  attr_reader :ladder

  def initialize(ladder)
    @ladder_level = ladder
  end

  def to_auk
    <<~AUK
      ladder #{@ladder_level}
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

  # def prun(ptable, parent)
  #   ptable.reject!{|i| (parent.name == i.nurse.name) && !(@timeslots.any? { |timeslot| timeslot == i.timeslot.name })}
  #   # ptable.reject!{|i| (parent.name == i.nurse.name) && !@timeslots.include?(i.timeslot.name)}
  #   # ptable.select{|i| (parent.name == i.nurse.name) && (@timeslots.any? { |timeslot| timeslot == i.timeslot.name })}
  # end
end

# class DomainUnavailable < DomainComponent
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
# end

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
