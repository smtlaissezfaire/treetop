require "benchmark"
require File.dirname(__FILE__) + "/../../lib/treetop"

NUM_ELEMENTS = 20_000_000.freeze
SYNTAX_NODE = Treetop::Runtime::SyntaxNode.new("foo", 0)
ARRAY = (1..NUM_ELEMENTS).map { |num| SYNTAX_NODE }

Benchmark.bm do |reporter|
  reporter.report("Initialize with #{NUM_ELEMENTS} elements of base syntax node element") do
    Treetop::Runtime::SyntaxNode.new("foo", 0, ARRAY)
  end
end
