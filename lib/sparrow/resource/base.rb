require_relative "../constraint/domain"

class Resource
  attr_reader :name
  attr_accessor :domain

  def initialize(name = nil)
    @name = name
    @domain = Domain.new
  end

  def block_name
    self.class.name.downcase
  end

  def to_auk
    <<~AUK
      #{block_name} #{@name ? "\"#{@name}\"" : nil} do
        #{@domain.to_auk}
      end

    AUK
  end

  def prun(ptable)
    @domain.prun(ptable, self)
  end

  def domain_exec(ptable)
    @domain.exec(ptable, self)
  end

  def to_cnf(ptable); end

  def domain_period; end

  def rem(comment)
    @domain.add(comment, __method__)
  end
end
