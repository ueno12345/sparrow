require "sycamore/extension"
require "csv"
require_relative "formatter"
# TODO: RubyTree検討
# NOTE: そもそも，Treeである必要があるか

module Swallow
  class AST < Tree
    def to_auk
      auk_formatter = AUKFormatter.new
      auk_formatter.format self
    end

    def to_cnf(ptable)
      cnf_formatter = CNFFormatter.new
      cnf_formatter.format(self, ptable)
    end

    def to_csv
      csv_formatter = CSVFormatter.new
      csv_formatter.format self
    end

    def to_html
      html_formatter = HTMLFormatter.new
      html_formatter.format self
    end

    def to_json
      json_formatter = JSONFormatter.new
      json_formatter.format self
    end
  end
end
