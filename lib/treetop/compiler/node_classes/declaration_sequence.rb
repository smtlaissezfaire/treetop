module Treetop
  module Compiler
    class DeclarationSequence < Runtime::SyntaxNode

      def compile(builder)
        define_root_method(builder) unless rules.empty?
        define_each_declaration(builder)
      end
      
      def rules
        declarations.select { |declaration| declaration.instance_of?(ParsingRule) }
      end

    private

      def define_root_method(builder)
        builder.method_declaration("root") do
          builder << "@root || :#{rules.first.name}"
        end
        builder.newline
      end

      def define_each_declaration(builder)
        declarations.each do |declaration|
          declaration.compile(builder)
          builder.newline
        end
      end
    end
  end
end
