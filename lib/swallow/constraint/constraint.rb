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
    # 割当が決まったから制約はなくてもよいのでは
    # <<~AUK
    #   #{self.class.name.underscore} #{@num} do
    #     timeslot {#{@timeslot}} & nurse {#{@nurse}}
    #   end
    #
    # AUK
  end

  def domain_period; end

  def domain_exec(_ptable, _node)
    Ravensat::InitialNode.new
  end

  def prun(ptable); end

  alias name class
end

# class Overlap < Constraint
#  def exec(ptable)
# ptable.group_by(&:period).values.map do |e|
#   e.select { |i| @nurses.include? i.nurse.name }.map(&:value)
# end.reduce(:&)
#  end
# end
# cnf &= ptable.group_by{|i| i.nurse.name}.values.map do |e|
#   Ravensat::Claw.alo e.map(&:value)
# end.reduce(:&)

# class NotOverlap < Constraint
#  def exec(ptable)
#    ptable.group_by { |i| i.timeslot.name }.values.map do |e|
#      Ravensat::Claw.commander_amo e.select { |i| @nurses.include? i.nurse.name }.map(&:value)
#    end.reduce(:&)
#  end
# end

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
    ########
    # timeslot の集合
    ########
    @resources << timeslot.instance_eval(&block)
  end

  def nurse(&block)
    nurse = NurseParser.new(@nurse_collection)
    ########
    # nurse の集合
    ########
    @resources << nurse.instance_eval(&block)
    # binding.irb
  end

  #     def exec(ptable)
  # #    ptable.group_by { |i| i.timeslot.name }.values.map do |e|
  # #      Ravensat::Claw.commander_at_most_k(e.select { |i| @nurses.include? i.nurse.name }.map(&:value), @num)
  # #    end.reduce(:&)
  # #    end
  # #      Ravensat::Claw.commander_at_most_k(ptable, @num)
  # #      Ravensat::Claw.commander_at_most_k(@resources, @num)
  #
  #
  # #####
  # # @resourse は timeslot と nurse の二次元配列になっている
  # # ptable?にする？
  # #####
  #
  # #       @resources.each do |t|
  # #         t.map do |e|
  # #           #####
  # #           # e が timeslotクラスになっている
  # #           # ptable?にする？
  # #           #####
  # #           Ravensat::Claw.commander_at_most_k(ptable, @num)
  # #         end
  #
  #       # Ravensat::Claw.commander_at_most_k(ptable, @num)
  #
  #       # ptable.map do |e|
  #       #   Ravensat::Claw.commander_at_most_k e.map(&:value)
  #       # end.reduce(:&)
  #
  #       Ravensat::Claw.commander_at_most_k(ptable.map(&:value), @num)
  #     end
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

    if @num == 1
      Ravensat::Claw.commander_at_most_one(ptable.select do |i|
        timeslots.uniq.include? i.timeslot.name
      end.select { |j| nurses.uniq.include? j.nurse.name }.map(&:value))
    else
      Ravensat::Claw.commander_at_most_k(ptable.select do |i|
        timeslots.uniq.include? i.timeslot.name
      end.select { |j| nurses.uniq.include? j.nurse.name }.map(&:value), @num)
    end
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

    if @num == 1
      Ravensat::Claw.at_least_one(ptable.select do |i|
        timeslots.uniq.include? i.timeslot.name
      end.select { |j| nurses.uniq.include? j.nurse.name }.map(&:value))
    else
      Ravensat::Claw.at_least_k(ptable.select do |i|
        timeslots.uniq.include? i.timeslot.name
      end.select { |j| nurses.uniq.include? j.nurse.name }.map(&:value), @num)
    end
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
    @resources << timeslot.instance_eval(&block)
  end

  def nurse(&block)
    nurse = NurseParser.new(@nurse_collection)
    @resources << nurse.instance_eval(&block)
  end

  def exec(ptable)
    # ptable.group_by { |i| i.timeslot.name }.values.map do |e|
    #   Ravensat::Claw.commander_at_most_one e.select { |i| @lectures.include? i.lecture.name }.map(&:value)
    # end.reduce(:&)

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

    Ravensat::Claw.exactly_k(ptable.select do |i|
                               timeslots.uniq.include? i.timeslot.name
                             end.select { |j| nurses.uniq.include? j.nurse.name }.map(&:value), @num)
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
          constraint.is_a?(DomainGroup) && constraint.group.include?(group_name)
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

  def name(nurse_name)
    NurseCollection.new(
      @nurse_collection.select do |nurse|
        nurse.name.include?(nurse_name)
      end
    )
  end

  #
  #    def team
  #      Team.new(@nurse_collection)
  #    end
  #
  #    def group
  #      Group.new(@nurse_collection)
  #    end
end

#  class LadderLevel
#    def initialize(nurses)
#      @nurses = nurses
#    end
#    def >=(num)
#      @nurses.select{|i| i>=num}
#    end
#  end
#
#  class Name
#    def initialize(nurses)
#      @nurses = nurses
#    end
#    def ==(select_name)
#      case select_name
#      when Array
#        ret_arr = []
#        name_table = {asan: 0, bsan: 1}
#        select_name.each do |e|
#          ret_arr.append @nurses[name_table[e.to_sym]]
#        end
#        return ret_arr
#      when String
#      end
#    @nurses.select{}
#    end
#  end
#
#  class Team
#
#  end
#
#  class Group
#
#  end
