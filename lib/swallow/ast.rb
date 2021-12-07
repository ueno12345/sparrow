require "sycamore/extension"
# TODO: RubyTree検討

module Swallow
  class AST < Tree
    def to_auk
      auk = ""
      nodes.each do |node|
        auk << node.to_auk
      end
      auk
    end

    def to_dimacs(_prop_table)
      dimacs_cnf = "" # TODO: 基本となる制約（CNF）を初期値として代入
      nodes.each do |node|
        dimacs_cnf << node.to_dimacs_cnf
      end
    end
  end
end
