require "time"
require_relative "ast"
require_relative "resource"
require_relative "constraint/constraint"

module Sparrow
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
      timeslot_initializer.timeslots.each do |t|
        @ast_timeslot_collection << t
      end
    end

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
