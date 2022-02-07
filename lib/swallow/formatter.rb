require "ravensat"

module Swallow
  class Formatter
    def format(ast); end
  end

  class AUKFormatter < Formatter
    def format(ast)
      auk = ""
      ast.nodes.each do |node|
        auk << node.to_auk
      end
      auk
    end
  end

  class CNFFormatter < Formatter
    def format(ast)
      ptable = PropTable.new(ast)

      # Generate basic constraints
      # XXX: amoで計算爆発
      cnf = ptable.group_by { |i| i.room.name }.values.map do |e|
        Ravensat::RavenClaw.amo e.map(&:value)
      end.reduce(:&)

      ast.nodes.each do |node|
        cnf &= node.to_cnf(ptable) # NOTE: Dependency Injection
      end
    end
  end

  class CSVFormatter < Formatter
    def format(ast)
      csv = [] # CSV::Table
      ast.nodes.each do |node|
        csv.append [node.name] + node.to_csv.period if node.to_csv
      end
      # TODO: CSVクラスを使用することを検討
      csv.map(&:to_csv).reduce { |result, item| "#{result}#{item}\n" }.chomp
    end
  end

  class HTMLFormatter
    def format(ast)
      # TODO: Nokogiriを使用する
      html = ""
      ast.nodes.each do |node|
        next unless node.is_a? Lecture

        lecture = node.name
        period = node.to_csv.period if node.to_csv
        p [lecture, period]
      end
      html
    end
  end
end
