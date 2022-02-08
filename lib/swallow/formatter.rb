require "ravensat"
require "nokogiri"

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
        csv.append [node.name] + node.domain_period.period if node.domain_period
      end
      # TODO: CSVクラスを使用することを検討
      csv.map(&:to_csv).reduce { |result, item| "#{result}#{item}\n" }.chomp
    end
  end

  class HTMLFormatter < Formatter
    def format(ast)
      # TODO: Nokogiriを使用する
      nr_periods = 8
      nr_days = 5
      days_table = %w[Mon Tue Wed Thu Fri]
      lec_periods = []

      ast.nodes.each do |node|
        next unless node.is_a? Lecture

        lecture = node.name
        period = node.domain_period.period if node.domain_period
        lec_periods.append [lecture, period].flatten
      end
      root = Nokogiri::HTML::DocumentFragment.parse("")
      Nokogiri::HTML::Builder.with(root) do |doc|
        doc.div.nav.index do
          doc.h1 "Time Table"
          doc.table do
            nr_periods.times do |pr|
              doc.tr do
                nr_days.times do |dy|
                  id = "#{days_table[dy]}#{pr + 1}"
                  td = []
                  lec_periods.each do |lec_pr|
                    td.append lec_pr.first if lec_pr.include? id
                  end
                  doc.td td, id: id
                end
              end
            end
          end
        end
      end
      root.to_html
    end
  end
end
