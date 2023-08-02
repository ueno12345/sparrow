require "active_support/all"
require_relative "collection"

class Constraint
#  def initialize
#    @nurses
#  end

#  def nurses(*nrs)
#    @nurses = nrs
#  end

#  def to_auk
#    <<~AUK
#      #{self.class.name.underscore} do
#        nurses #{@nurses.map { |i| %("#{i}") }.join(",")}
#      end
#
#    AUK
# end

#  def domain_period; end

  def domain_exec(_ptable)
    Ravensat::InitialNode.new
  end

  def prun(ptable); end

  alias name class
end


#class SameStart < Constraint
#end

#class SameTime < Constraint
#end

#class DifferentTime < Constraint
#end

#class SameDays < Constraint
#end

#class DifferentDays < Constraint
#end

#class SameWeeks < Constraint
#end

#class DifferentWeeks < Constraint
#end

#class SameRoom < Constraint
#end

#class DifferentRoom < Constraint
#end

#class Overlap < Constraint
#  def exec(ptable)
    # ptable.group_by(&:period).values.map do |e|
    #   e.select { |i| @nurses.include? i.nurse.name }.map(&:value)
    # end.reduce(:&)
#  end
#end
# cnf &= ptable.group_by{|i| i.nurse.name}.values.map do |e|
#   Ravensat::Claw.alo e.map(&:value)
# end.reduce(:&)

#class NotOverlap < Constraint
#  def exec(ptable)
#    ptable.group_by { |i| i.timeslot.name }.values.map do |e|
#      Ravensat::Claw.commander_amo e.select { |i| @nurses.include? i.nurse.name }.map(&:value)
#    end.reduce(:&)
#  end
#end

#class SameAttendees < Constraint
#end

#class Precedence < Constraint
#end

#class WorkDay < Constraint
#end

#class MinGap < Constraint
#end

#class MaxDays < Constraint
#end

#class MaxDayLoad < Constraint
#end

#class MaxBreaks < Constraint
#end

#class MaxBlock < Constraint
#end

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
      #timeslot の集合
      ########
      @resources << timeslot.instance_eval(&block)
    end

    def nurse(&block)
      nurse = NurseParser.new(@nurse_collection)
      ########
      #nurse の集合
      ########
      @resources << nurse.instance_eval(&block)
      #binding.irb
    end

    def exec(ptable)
#    ptable.group_by { |i| i.timeslot.name }.values.map do |e|
#      Ravensat::Claw.commander_at_most_k(e.select { |i| @nurses.include? i.nurse.name }.map(&:value), @num)
#    end.reduce(:&)
#    end
#      Ravensat::Claw.commander_at_most_k(ptable, @num)
#      Ravensat::Claw.commander_at_most_k(@resources, @num)


#####
# @resourse は timeslot と nurse の二次元配列になっている
# ptable?にする？
#####

#       @resources.each do |t|
#         t.map do |e|
#           #####
#           # e が timeslotクラスになっている
#           # ptable?にする？
#           #####
#           Ravensat::Claw.commander_at_most_k(ptable, @num)
#         end

      # Ravensat::Claw.commander_at_most_k(ptable, @num)

      # ptable.map do |e|
      #   Ravensat::Claw.commander_at_most_k e.map(&:value)
      # end.reduce(:&)

      Ravensat::Claw.commander_at_most_k(ptable.map(&:value), @num)
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
      Ravensat::Claw.at_least_k(ptable.map(&:value), @num)
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
      #binding.irb
    end

    def exec(ptable)
      Ravensat::Claw.exactly_k(ptable.map(&:value), @num)
    end
  end

  class TimeslotParser < TimeslotCollection
    def initialize(t_collection)
    @timeslot_collection = t_collection
    end

    def any
      # p @timeslot_collection
      return @timeslot_collection
    end

#    def day
#
#    end
#
#    def sem
#
#    end
#
#    def ngt
#    end
  end


  class NurseParser < NurseCollection
    def initialize(n_collection)
    @nurse_collection = n_collection
    end

    def any
      return @nurse_collection
    end

  # def ladder
  #  LadderLevel.new(@nurse_collection)
  # end

#    def name
#      Name.new(@nurse_collection)
#    end
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
