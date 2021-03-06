module Treetop
  module Compiler    
    class Sequence < ParsingExpression
      def compile(address, builder, parent_expression = nil)
        super
        begin_comment(self)
        use_vars :result, :start_index, :accumulator
        compile_sequence_elements(sequence_elements)
        builder.if__ "#{accumulator_var}.last" do
          assign_result "(#{node_class_name}).new(input, #{start_index_var}...index, #{accumulator_var})"
          extend_result sequence_element_accessor_module_name if sequence_element_accessor_module_name
          extend_result_with_inline_module
        end
        builder.else_ do
          reset_index
          assign_failure start_index_var
        end
        end_comment(self)
      end
      
      def node_class_name
        node_class_declarations.node_class_name || 'SyntaxNode'
      end
      
      def compile_sequence_elements(elements)
        obtain_new_subexpression_address
        elements.first.compile(subexpression_address, builder)
        accumulate_subexpression_result
        if elements.size > 1
          builder.if_ subexpression_success? do
            compile_sequence_elements(elements[1..-1])
          end
        end
      end
      
      def sequence_element_accessor_module
        @sequence_element_accessor_module ||= SequenceElementAccessorModule.new(sequence_elements)
      end
      
      def sequence_element_accessor_module_name
        sequence_element_accessor_module.module_name
      end
    end
    
    class SequenceElementAccessorModule
      include InlineModuleMixin   
      attr_reader :sequence_elements
      
      def initialize(sequence_elements)
        @sequence_elements = sequence_elements
      end
      
      def compile(index, builder, rule)
        super
        builder.module_declaration(module_name) do
          sequence_elements.each_with_index do |element, index|
            if element.label_name
              builder.method_declaration(element.label_name) do
                builder << "elements[#{index}]"
              end
              builder.newline unless index == sequence_elements.size - 1
            end
          end
        end
      end
    end
  end
end
