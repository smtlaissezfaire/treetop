module Treetop
  module Compiler
    class ParsingRule < Runtime::SyntaxNode

      def compile(builder)
        compile_inline_module_declarations(builder)
        generate_method_definition(builder)
      end
      
      def compile_inline_module_declarations(builder)
        parsing_expression.inline_modules.each_with_index do |inline_module, i|
          inline_module.compile(i, builder, self)
          builder.newline
        end
      end
      
      def generate_method_definition(builder)
        builder.reset_addresses
        expression_address = builder.next_address
        result_var = "r#{expression_address}"
        
        builder.method_declaration(method_name) do
          builder.assign 'start_index', 'index'
          builder.assign "#{node_cache_name}", "node_cache[:#{name}]"
          generate_cache_lookup(builder) do
            builder.newline
            parsing_expression.compile(expression_address, builder)
            builder.newline
            generate_cache_storage(builder, result_var)
            builder.newline
            builder << result_var
          end
        end
      end
      
      def generate_cache_lookup(builder, &blk)
        builder.if__ "#{node_cache_name}.has_key?(index)" do
          builder.assign 'cached', "#{node_cache_name}[index]"
          builder << '@index = cached.interval.end if cached'
          builder << 'cached'
        end

        builder.else_(&blk)
      end
      
      def generate_cache_storage(builder, result_var)
        builder.assign "#{node_cache_name}[start_index]", result_var
      end
      
      def method_name
        "_nt_#{name}"
      end

      def node_cache_name
        "node_cache_#{name}"
      end
      
      def name
        nonterminal.text_value
      end
    end
  end
end
