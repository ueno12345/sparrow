require "time"
require_relative "ast"
require_relative "resource"

module Swallow
  class AUKParser
    attr_reader :ast

    def initialize
      @ast = AST.new
    end

    def period(&block)
      period = Period.new
      period.instance_eval(&block)
      @ast << period
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
  end
end
