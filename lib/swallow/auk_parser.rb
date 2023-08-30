require "time"
require_relative "ast"
require_relative "resource"
require_relative "constraint/constraint"

module Swallow
  class AUKParser
    attr_reader :ast

    def initialize
      @ast = AST.new
      @ast_timeslot_collection = TimeslotCollection.new
      @ast_nurse_collection = NurseCollection.new
    end

    def timeslot(&block)
      timeslot_initializer = TimeslotInitializer.new
      timeslot_initializer.instance_eval(&block)
      @ast << timeslot_initializer
      timeslot_initializer.timeslots.each { |t|
        @ast_timeslot_collection << t
      }
    end

#    def timeslots(&block)
#      timeslot_initializer = TimeslotInitializer.new
#      timeslot_initializer.instance_eval(&block)
#      @ast << timeslot_initializer
#    end

#    def timeslot(name, &block)
#      timeslot_initializer = @ast.nodes.find{|i|i.is_a? TimeslotInitializer}
#      timeslot = timeslot_initializer.timeslots.find{|i|i.name == name}
#      timeslot.instance_eval(&block)
#    end


    def nurse(name, &block)
      nurse = Nurse.new(name)
      nurse.instance_eval(&block)
      @ast << nurse
      @ast_nurse_collection << nurse
    end

    def at_most(num, &block)
      constraint = AtMost.new(num, @ast_timeslot_collection, @ast_nurse_collection)
      resources = constraint.instance_eval(&block)
      constraint.resources = resources
      #@cnf &= Ravensat::Claw.at_most(array, num)
      #XXX: constraint.is_a Array
      @ast << constraint
    end

    def at_least(num, &block)
      constraint = AtLeast.new(num, @ast_timeslot_collection, @ast_nurse_collection)
      resources = constraint.instance_eval(&block)
      constraint.resources = resources
      @ast << constraint
    end

    def exactly(num, &block)
      constraint = Exactly.new(num, @ast_timeslot_collection, @ast_nurse_collection)
      resources = constraint.instance_eval(&block)
      constraint.resources = resources
      @ast << constraint
    end

    alias parse instance_eval
  end
end
