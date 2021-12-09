require "sycamore/extension"
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

    def to_cnf(ptable)
      cnf = Ravensat::PropLogic # TODO: 基本となる制約（CNF）を初期値として代入
      nodes.each do |node|
        cnf &= node.to_cnf(ptable) # NOTE: Dependency Injection
      end
    end
  end
end
