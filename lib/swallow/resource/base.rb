require_relative "../constraint/domain"

class Resource
  attr_reader :name
  attr_writer :domain

  def initialize(name = nil)
    @name = name
    @domain = Domain.new
    @belongs_to = ""
  end

  def block_name
    self.class.name.downcase
  end

  def to_auk
    <<~AUK
      #{block_name} #{@name ? "\"#{@name}\"" : nil} do
        #{@domain.to_auk}
        #{@belongs_to.empty? ? nil : "belongs_to \"#{@belongs_to}\""}
      end

    AUK
  end

  def prun(ptable)
    @domain.prun(ptable, self)
  end

  def to_cnf(ptable); end

  def domain_period; end
end
