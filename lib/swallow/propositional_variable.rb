require "ravensat"
require "forwardable"

module Swallow
  class PropTable
    extend Forwardable
    include Enumerable

    def_delegators :@table, :each, :size, :reject!

    def initialize(resources)
      @table = []
      # preprocessing
      timeslots = []
      rooms = []
      instructors = []
      lectures = []

      resources.nodes.each do |resource|
        case resource
        when TimeslotInitializer # HACK: AST全体にComposite patternを適用する？
          timeslots = resource.timeslots
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
      timeslots.each do |timeslot|
        rooms.each do |room|
          instructors.each do |instructor|
            lectures.each do |lecture|
              @table << PropVar.new(timeslot, room, instructor, lecture)
            end
          end
        end
      end
    end
  end

  class PropVar
    attr_reader :value, :timeslot, :room, :instructor, :lecture

    def initialize(timeslot, room, instructor, lecture)
      @value = Ravensat::VarNode.new
      @timeslot = timeslot
      @room = room
      @instructor = instructor
      @lecture = lecture
    end
  end
end
