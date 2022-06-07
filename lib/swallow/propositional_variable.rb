require "ravensat"
require "forwardable"

module Swallow
  class PropTable
    extend Forwardable

    def_delegators :@table, :select, :to_a, :group_by

    def initialize(resources)
      @table = []
      # preprocessing
      periods = []
      rooms = []
      instructors = []
      lectures = []

      resources.nodes.each do |resource|
        case resource
        when PeriodInitializer # HACK: AST全体にComposite patternを適用する？
          periods = resource.periods
        when Room
          rooms << resource
        when Instructor
          instructors << resource
        when Lecture
          lectures << resource
        end
      end

      # create table
      # HACK: Array, Enumeratableのメソッドを使って読みやすく書けそう
      periods.each do |period|
        rooms.each do |room|
          instructors.each do |instructor|
            lectures.each do |lecture|
              @table << PropVar.new(period, room, instructor, lecture)
            end
          end
        end
      end
    end
  end

  class PropVar
    attr_reader :value, :period, :room, :instructor, :lecture

    def initialize(period, room, instructor, lecture)
      @value = Ravensat::VarNode.new
      @period = period
      @room = room
      @instructor = instructor
      @lecture = lecture
    end
  end
end
