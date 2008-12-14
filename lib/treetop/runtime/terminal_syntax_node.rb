module Treetop
  module Runtime
    class TerminalSyntaxNode < SyntaxNode

      def initialize(input, interval)
        super(input, interval, [])
      end

      def terminal?
        true
      end

      def nonterminal?
        false
      end

      def text_value
        @input
      end

      def empty?
        @emtpy ||= @input.empty?
      end

      def inspect(indent="")
	indent+
	  self.class.to_s.sub(/.*:/,'') +
	  " offset=#{interval.first}" +
	  " #{text_value.inspect}"
      end
    end
  end
end
