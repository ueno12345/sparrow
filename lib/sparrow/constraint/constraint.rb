require "active_support/all"
require_relative "collection"

class Constraint
  def initialize
    @timeslot
    @nurse
  end

  def timeslot(*ts)
    @timeslot = ts
  end

  def nurse(*nr)
    @nurse = nr
  end

  def to_auk
    ""
  end

  def domain_period; end

  def domain_exec(_ptable)
    Ravensat::InitialNode.new
  end

  def prun(ptable); end

  alias name class
end

class AtMost < Constraint
  attr_accessor :resources

  def initialize(num, ast_timeslot_collection, ast_nurse_collection)
    @num = num
    @resources = Collection.new
    @timeslot_collection = ast_timeslot_collection
    @nurse_collection = ast_nurse_collection
  end

  def timeslot(&block)
    timeslot = TimeslotParser.new(@timeslot_collection)
    @resources << timeslot.instance_eval(&block)
  end

  def nurse(&block)
    nurse = NurseParser.new(@nurse_collection)
    @resources << nurse.instance_eval(&block)
  end

  def exec(ptable)
    timeslots = []
    nurses = []

    @resources.each do |resource|
      resource.each do |res|
        case res
        when Timeslot
          timeslots << res.name
        when Nurse
          nurses << res.name
        end
      end
    end
    timeslots.uniq!
    nurses.uniq!

    Ravensat::Claw.commander_at_most_k(ptable.select { |i| timeslots.include? i.timeslot.name }.select { |j| nurses.include? j.nurse.name }.map(&:value), @num)
  end
end

class AtLeast < Constraint
  attr_accessor :resources

  def initialize(num, ast_timeslot_collection, ast_nurse_collection)
    @num = num
    @resources = Collection.new
    @timeslot_collection = ast_timeslot_collection
    @nurse_collection = ast_nurse_collection
  end

  def timeslot(&block)
    timeslot = TimeslotParser.new(@timeslot_collection)
    @resources << timeslot.instance_eval(&block)
  end

  def nurse(&block)
    nurse = NurseParser.new(@nurse_collection)
    @resources << nurse.instance_eval(&block)
  end

  def exec(ptable)
    timeslots = []
    nurses = []

    @resources.each do |resource|
      resource.each do |res|
        case res
        when Timeslot
          timeslots << res.name
        when Nurse
          nurses << res.name
        end
      end
    end
    timeslots.uniq!
    nurses.uniq!
    Ravensat::Claw.at_least_k(ptable.select { |i| timeslots.include? i.timeslot.name }.select { |j| nurses.include? j.nurse.name }.map(&:value), @num)
  end
end

class Exactly < Constraint
  attr_accessor :resources

  def initialize(num, ast_timeslot_collection, ast_nurse_collection)
    @num = num
    @resources = Collection.new
    @timeslot_collection = ast_timeslot_collection
    @nurse_collection = ast_nurse_collection
  end

  def timeslot(&block)
    timeslot = TimeslotParser.new(@timeslot_collection)
    TimeslotParser.new(@timeslot_collection)
    @resources << timeslot.instance_eval(&block)
  end

  def nurse(&block)
    nurse = NurseParser.new(@nurse_collection)
    @resources << nurse.instance_eval(&block)
  end

  def exec(ptable)
    timeslots = []
    nurses = []

    @resources.each do |resource|
      resource.each do |res|
        case res
        when Timeslot
          timeslots << res.name
        when Nurse
          nurses << res.name
        end
      end
    end
    timeslots.uniq!
    nurses.uniq!

    Ravensat::Claw.exactly_k(ptable.select { |i| timeslots.include? i.timeslot.name }.select { |j| nurses.include? j.nurse.name }.map(&:value), @num)
  end
end

class TimeslotParser < TimeslotCollection
  def initialize(t_collection)
    @timeslot_collection = t_collection
  end

  def day(date = nil)
    filter_by_date_and_keyword("day", date)
  end

  def sem(date = nil)
    filter_by_date_and_keyword("sem", date)
  end

  def ngt(date = nil)
    filter_by_date_and_keyword("ngt", date)
  end

  def any(date = nil)
    TimeslotCollection.new(
      @timeslot_collection.select do |timeslot|
        date.nil? || timeslot.name.include?(date.to_s)
      end
    )
  end

  private

  def filter_by_date_and_keyword(keyword, date = nil)
    TimeslotCollection.new(
      @timeslot_collection.select do |timeslot|
        timeslot.name.include?(keyword) && (date.nil? || timeslot.name.include?(date.to_s))
      end
    )
  end
end

class NurseParser < NurseCollection
  def initialize(n_collection)
    @nurse_collection = n_collection
  end

  def any
    @nurse_collection
  end

  def group(group_name = nil)
    NurseCollection.new(
      @nurse_collection.select do |nurse|
        nurse.domain.constraints.any? do |constraint|
          constraint.is_a?(DomainGroups) && constraint.groups.include?(group_name)
        end
      end
    )
  end

  def ladder(num = nil)
    NurseCollection.new(
      @nurse_collection.select do |nurse|
        nurse.domain.constraints.any? do |constraint|
          constraint.is_a?(DomainLadder) && constraint.ladder == num
        end
      end
    )
  end

  def team(team = nil)
    NurseCollection.new(
      @nurse_collection.select do |nurse|
        nurse.domain.constraints.any? do |constraint|
          constraint.is_a?(DomainTeam) && constraint.team == team
        end
      end
    )
  end

  def name(nurse_name)
    NurseCollection.new(
      @nurse_collection.select do |nurse|
        nurse.name.include?(nurse_name)
      end
    )
  end
end
