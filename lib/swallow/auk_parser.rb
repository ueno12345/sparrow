require 'time'
require_relative 'ast'
require_relative 'resource'

module Swallow
  class AUKParser
    def initialize
      @ast = AST.new
    end

    def period(&block)
      period = Period.new
      period.instance_eval &block
      @ast.append period
    end

    def room(name, &block)
      room = Room.new name
      room.instance_eval &block
      @ast.append room
    end

    def instructor(name, &block)
      instructor = Instructor.new name
      instructor.instance_eval &block
      @ast.append instructor
    end

    def lecture(name, &block)
      lecture = Lecture.new name
      lecture.instance_eval &block
      @ast.append lecture
    end
  end
end
