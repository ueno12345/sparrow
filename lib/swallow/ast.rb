require "sycamore/extension"
require "ravensat"
require "csv"
# TODO: RubyTree検討
# NOTE: そもそも，Treeである必要があるか

module Swallow
  class AST < Tree
    def to_auk
      auk = ""
      nodes.each do |node|
        auk << node.to_auk
      end
      auk
    end

    def to_cnf
      ptable = PropTable.new(self)

      # Generate basic constraints
      # XXX: amoで計算爆発
      cnf = ptable.group_by { |i| i.room.name }.values.map do |e|
        Ravensat::RavenClaw.amo e.map(&:value)
      end.reduce(:&)

      nodes.each do |node|
        cnf &= node.to_cnf(ptable) # NOTE: Dependency Injection
      end
    end

    def to_csv
      csv = [] # CSV::Table
      nodes.each do |node|
        csv.append [node.name, node.to_csv.period] if node.to_csv
      end
      csv.to_csv #TODO: CSVクラスを使用することを検討
    end
  end
end
