require 'time'
require 'pry'

module Swallow
  class AUKParser
    def initialize
      @resources = []
    end

    def period(&block)
      period = Period.new
      period.instance_eval &block
      @resources.append period
    end

    def room(name, &block)
      room = Room.new name
      room.instance_eval &block
      @resources.append room
    end

    def instructor(name, &block)
      instructor = Instructor.new name
      instructor.instance_eval &block
      @resources.append instructor
    end

    def lecture(name, &block)
      lecture = Lecture.new name
      lecture.instance_eval &block
      @resources.append lecture
    end
  end

  class Resource
    def initialize(name=nil)
      @name = name
      @domain = Domain.new
      @belongs_to
    end
  end

  class Period < Resource
    def nr_days_a_week(num)
      @domain.by_period.nr_days_a_week = num
    end

    def nr_periods(num)
      @domain.by_period.nr_periods = num
    end
  end

  class Room < Resource
    def belongs_to(name)
      @belongs_to = name
    end

    def unavaibale(start_time: nil, end_time: nil)
      @domain.by_period.start_time = Time.parse start_time
      @domain.by_period.end_time = Time.parse end_time
    end
  end

  class Instructor < Resource
    def belongs_to(name)
      @belongs_to = name
    end

    def unavaibale(start_time: nil, end_time: nil)
      @domain.by_period.start_time = Time.parse start_time
      @domain.by_period.end_time = Time.parse end_time
    end
  end

  class Lecture < Resource
    def rooms(*rooms)
      @domain.by_room.rooms = rooms
    end

    def instructors(*instructors)
      @domain.by_instructor.instructors = instructors
    end

    def period(*period)
      @domain.by_period.period = period
    end

    def term(term)
      @domain.by_period.term = term
    end

    def belongs_to(name)
      @belongs_to = name
    end
  end

  class Domain
    attr_reader :by_period
    attr_reader :by_room
    attr_reader :by_instructor
    def initialize
      @@nr_resources
      @constraints = []
      @by_period = DomainByPeriod.new
      @by_room = DomainByRoom.new
      @by_instructor = DomainByInstructor.new
    end
  end

  class DomainByPeriod
    attr_accessor :nr_days_a_week
    attr_accessor :nr_periods

    attr_accessor :unavailable
    attr_accessor :term
    attr_accessor :period
    attr_accessor :start_time
    attr_accessor :end_time
  end

  class DomainByRoom
    attr_accessor :rooms
  end

  class DomainByInstructor
    attr_accessor :instructors
  end

end
# parser = AUKParser.new
# parser.instance_eval File.read(ARGV[0])
# binding.pry
