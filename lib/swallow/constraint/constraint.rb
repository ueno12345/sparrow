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

    Ravensat::Claw.commander_at_most_k(ptable.select do |i|
                                         timeslots.uniq.include? i.timeslot.name
                                       end.select { |j| nurses.uniq.include? j.nurse.name }.map(&:value), @num)
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

    Ravensat::Claw.at_least_k(ptable.select do |i|
                                timeslots.uniq.include? i.timeslot.name
                              end.select { |j| nurses.uniq.include? j.nurse.name }.map(&:value), @num)
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

  #  def method_missing(method, *args)
  #    expression = method.to_s
  #
  #    # パターン1: 数字のみ（例: 20240901）
  #    if expression =~ /(\d+)/
  #      date = Regexp.last_match(1)
  #      Collection.new(@timeslot_collection.select { |t| t.include?(date) })
  #
  #    # パターン2: 数字とキーワード（例: 20240901*day）
  #    elsif expression =~ /(\d+)\*(\w+)/
  #      date = Regexp.last_match(1)
  #      keyword = Regexp.last_match(2)
  #      Collection.new(@timeslot_collection.select { |t| t.include?(date) && t.include?(keyword) })
  #
  #    # パターン3: キーワードと数字（例: day*20240901）
  #    elsif expression =~ /(\w+)\*(\d+)/
  #      keyword = Regexp.last_match(1)
  #      date = Regexp.last_match(2)
  #      Collection.new(@timeslot_collection.select { |t| t.include?(date) && t.include?(keyword) })
  #
  #    else
  #      super
  #    end
  #  end

  def filter_by_keyword(keyword)
    if keyword == "any"
      @timeslot_collection
    else
      collection = []
      @timeslot_collection.each do |t_collection|
        collection << t_collection if t_collection.name.include?(keyword)
      end
      collection
    end
  end

  def any
    filter_by_keyword("any")
  end

  def day
    filter_by_keyword("day")
  end

  def sem
    filter_by_keyword("sem")
  end

  def ngt
    filter_by_keyword("ngt")
  end

  #  def any
  #    @timeslot_collection
  #  end
  #
  #  def day
  #    collection = []
  #    @timeslot_collection.each do |t_collection|
  #      collection << t_collection if t_collection.name.include?("day")
  #    end
  #    collection
  #  end
  #
  #  def sem
  #    collection = []
  #    @timeslot_collection.each do |t_collection|
  #      collection << t_collection if t_collection.name.include?("sem")
  #    end
  #    collection
  #  end
  #
  #  def ngt
  #    collection = []
  #    @timeslot_collection.each do |t_collection|
  #      collection << t_collection if t_collection.name.include?("ngt")
  #    end
  #    collection
  #  end
end

class NurseParser < NurseCollection
  def initialize(n_collection)
    @nurse_collection = n_collection
  end

  def any
    @nurse_collection
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
