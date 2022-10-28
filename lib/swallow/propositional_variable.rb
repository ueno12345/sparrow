# coding: utf-8
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
      nurses = []

      resources.nodes.each do |resource|
        case resource
        when TimeslotInitializer # HACK: AST全体にComposite patternを適用する？
          timeslots = resource.timeslots
        when Nurse
          nurses << resource
        end
      end

      # create table
      # HACK: Array, Enumeratableのメソッドを使って読みやすく書けそう
      timeslots.each do |timeslot|
        nurses.each do |nurse|
          @table << PropVar.new(timeslot, nurse)
        end
      end
    end
  end

  class PropVar
    attr_reader :value, :timeslot, :nurse

    def initialize(timeslot, nurse)
      @value = Ravensat::VarNode.new
      @timeslot = timeslot
      @nurse = nurse
    end
  end
end
