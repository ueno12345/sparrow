require "time"
require_relative "ast"
require_relative "resource"
require_relative "constraint"

module Swallow
  class AUKParser
    attr_reader :ast

    def initialize
      @ast = AST.new
    end

    def period(&block)
      period_initializer = PeriodInitializer.new
      period_initializer.instance_eval(&block)
      @ast << period_initializer
    end

    def room(name, &block)
      room = Room.new name
      room.instance_eval(&block)
      @ast << room
    end

    def instructor(name, &block)
      instructor = Instructor.new name
      instructor.instance_eval(&block)
      @ast << instructor
    end

    def lecture(name, &block)
      lecture = Lecture.new name
      lecture.instance_eval(&block)
      @ast << lecture
    end

    def same_start(&block)
      constraint = SameStart.new
      constraint.instance_eval(&block)
      @ast << constraint
    end

    def same_time(&block)
      constraint = SameTime.new
      constraint.instance_eval(&block)
      @ast << constraint
    end

    def different_time(&block)
      constraint = DifferentTime.new
      constraint.instance_eval(&block)
      @ast << constraint
    end

    def same_days(&block)
      constraint = SameDays.new
      constraint.instance_eval(&block)
      @ast << constraint
    end

    def different_days(&block)
      constraint = DifferentDays.new
      constraint.instance_eval(&block)
      @ast << constraint
    end

    def same_weeks(&block)
      constraint = SameWeeks.new
      constraint.instance_eval(&block)
      @ast << constraint
    end

    def different_weeks(&block)
      constraint = DifferentWeeks.new
      constraint.instance_eval(&block)
      @ast << constraint
    end

    def same_room(&block)
      constraint = SameRoom.new
      constraint.instance_eval(&block)
      @ast << constraint
    end

    def different_room(&block)
      constraint = DifferentRoom.new
      constraint.instance_eval(&block)
      @ast << constraint
    end

    def overlap(&block)
      constraint = Overlap.new
      constraint.instance_eval(&block)
      @ast << constraint
    end

    def not_overlap(&block)
      constraint = NotOverlap.new
      constraint.instance_eval(&block)
      @ast << constraint
    end

    def same_attendees(&block)
      constraint = SameAttendees.new
      constraint.instance_eval(&block)
      @ast << constraint
    end

    def precedence(&block)
      constraint = Precedence.new
      constraint.instance_eval(&block)
      @ast << constraint
    end

    def work_day(&block)
      constraint = WorkDay.new
      constraint.instance_eval(&block)
      @ast << constraint
    end

    def min_gap(&block)
      constraint = MinGap.new
      constraint.instance_eval(&block)
      @ast << constraint
    end

    def max_days(&block)
      constraint = MaxDays.new
      constraint.instance_eval(&block)
      @ast << constraint
    end

    def max_day_load(&block)
      constraint = MaxDayLoad.new
      constraint.instance_eval(&block)
      @ast << constraint
    end

    def max_breaks(&block)
      constraint = MaxBreaks.new
      constraint.instance_eval(&block)
      @ast << constraint
    end

    def max_block(&block)
      constraint = MaxBlock.new
      constraint.instance_eval(&block)
      @ast << constraint
    end
  end
end
