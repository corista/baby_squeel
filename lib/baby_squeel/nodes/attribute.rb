require 'baby_squeel/nodes/node'

module BabySqueel
  module Nodes
    class Attribute < Node
      def initialize(parent, name)
        @parent = parent
        @name = name
        super(parent._table[name])
      end

      def in(rel)
        if rel.is_a? ::ActiveRecord::Relation
          ::Arel::Nodes::In.new(self, Arel.sql(rel.to_sql))
        else
          super
        end
      end

      def _arel
        if @parent.kind_of? BabySqueel::Association
          join_expression = @parent._arel
          table = join_expression.find_alias(@parent)
          table ? table[@name] : super
        else
          super
        end
      end
    end
  end
end
