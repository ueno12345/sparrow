require "ravensat"
require "nokogiri"
require "rufo"

module Sparrow
  class Formatter
    def format(ast)
      # 例外処理を書く
    end
  end

  class AUKFormatter < Formatter
    def format(ast)
      auk = ""
      ast.nodes.each do |node|
        auk << node.to_auk
      end
      formatter = Rufo::Formatter.new(auk)
      formatter.format
      formatter.result
    end
  end

  class CNFFormatter < Formatter
    def format(ast, ptable)
      cnf = Ravensat::InitialNode.new

      ptable.each do |i|
        nurse = i.nurse
        timeslot_name = i.timeslot.name
        if nurse.domain.constraints.any? { |constraint| constraint.is_a?(DomainTimeslots) && constraint.timeslots.include?(timeslot_name) }
          cnf &= Ravensat::Claw.exactly_one([i.value])
        end
      end

      ast.nodes.each do |node|
        cnf &= node.exec(ptable) if node.is_a? Constraint
      end
      cnf
    end
  end

  class CSVFormatter < Formatter
    def format(ast)
      csv = [] # CSV::Table
      ast.nodes.each do |node|
        csv.append [node.name] + node.domain_timeslot.period if node.domain_timeslot
      end
      # TODO: CSVクラスを使用することを検討
      csv.map(&:to_csv).reduce { |result, item| "#{result}#{item}\n" }.chomp
    end
  end

  class JSONFormatter < Formatter
    def format(ast)
      n_timeslots = []
      n_nurses = []
      c_nurses = []
      nrs_periods = []

      ast.nodes.each do |node|
        next unless node.is_a? TimeslotInitializer

        node.timeslots.each do |timeslot|
          n_timeslots << timeslot.name
        end
      end

      ast.nodes.each do |node|
        next unless node.is_a? Nurse

        n_nurses << node.name
        nurse = node.name
        node.domain.constraints.each do |constraint|
          next unless constraint.is_a?(DomainTimeslots)

          constraint.timeslots.each do |timeslot|
            c_nurses = timeslot
            nrs_periods.append([nurse, c_nurses])
          end
        end
      end
      shift_json = []

      nrs_periods.uniq.each do |data|
        split_date = data[1].match(/(\d+)(\D+)/)
        date = Date.parse(split_date[1])
        shift_type = case split_date[2]
                     when "day"
                       "日勤"
                     when "sem"
                       "準夜勤"
                     when "ngt"
                       "深夜勤"
                     else
                       "休み"
                     end

        shift_json << { "name" => data[0], "date" => date, "shift_type" => shift_type }
      end
      # range を取得
      dates = n_timeslots.map {|date| date.match(/\d{8}/)[0]}.uniq
      dates.sort!
      date_range = { "start" => dates.first, "end" => dates.last }
      # shift とrange の情報を持ったjson
      json = { "shifts" => shift_json, "date_range" => date_range }

      JSON.generate(json)
    end
  end

  class HTMLFormatter < Formatter
    def format(ast)
      n_timeslots = []
      n_nurses = []
      c_nurses = []
      nrs_periods = []

      ast.nodes.each do |node|
        next unless node.is_a? TimeslotInitializer

        node.timeslots.each do |timeslot|
          n_timeslots << timeslot.name
        end
      end
      ast.nodes.each do |node|
        next unless node.is_a? Nurse

        n_nurses << node.name
        nurse = node.name
        node.domain.constraints.each do |constraint|
          next unless constraint.is_a?(DomainTimeslots)

          constraint.timeslots.each do |timeslot|
            c_nurses = timeslot
            nrs_periods.append([nurse, c_nurses])
          end
        end
      end

      root = Nokogiri::HTML::DocumentFragment.parse("")
      Nokogiri::HTML::Builder.with(root) do |doc|
        doc.link rel: "stylesheet", href: "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css"
        doc.div.nav.index do
          doc.h1 "Work Schedule"
          doc.table class: "table table-bordered" do
            doc.tr do
              doc.th nil
              n_timeslots.map { |ts| ts[/\d+/] }.uniq.sort.each do |timeslot|
                doc.th timeslot
              end
            end
            n_nurses.each do |nurse|
              doc.tr do
                doc.th nurse
                n_timeslots.map { |ts| ts[/\d+/] }.uniq.sort.each do |timeslot|
                  td = []
                  if nrs_periods.include?([nurse, timeslot + "day"])
                    td.append "日"
                  elsif nrs_periods.include?([nurse, timeslot + "sem"])
                    td.append "準"
                  elsif nrs_periods.include?([nurse, timeslot + "ngt"])
                    td.append "深"
                  else
                    td.append "休"
                  end
                  doc.td td.join("<br>"), id: "id_#{nurse}_#{timeslot}"
                end
              end
            end
          end
        end
      end
      CGI.unescapeHTML root.to_html
    end
  end
end
