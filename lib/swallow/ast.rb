require "sycamore/extension"

module Swallow
  class AST
    # NOTE: ASTクラスはActiveRecordベースに作成
    def initialize
      @tree = Tree.new
    end

    def to_s
      # return Tree Structure as String
      @tree.to_s
    end

    def to_auk; end

    def to_dimacs_cnf; end

    def append(resource)
      @tree << resource
    end
  end
end
