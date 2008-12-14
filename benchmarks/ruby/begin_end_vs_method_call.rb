require "benchmark"

NUM_TIMES = 10_000_000

class Foo
  def non_inlined
    foo = non_inlined_method
  end
  
  def inlined
    foo = begin
      "a string"
    end
  end

  def non_inlined_method
    "a string"
  end
end

obj = Foo.new

Benchmark.bm do |reporter|
  reporter.report("calling a non-inlined method #{NUM_TIMES} times") do
    1.upto(NUM_TIMES) do
      obj.non_inlined
    end
  end
  
  reporter.report("calling an inlined method:   #{NUM_TIMES} times") do
    1.upto(NUM_TIMES) do
      obj.inlined
    end
  end
end
