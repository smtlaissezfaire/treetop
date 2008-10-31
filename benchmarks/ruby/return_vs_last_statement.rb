require "benchmark"

NUM_TIMES = 10_000_000

Benchmark.bm do |reporter|
  reporter.report("returning nil #{NUM_TIMES} with 'return nil'") do
    def foo
      return nil
    end
    
    1.upto(NUM_TIMES) { foo }
  end
  
  reporter.report("returning nil #{NUM_TIMES} with 'nil'") do
    def foo
      nil
    end
    
    1.upto(NUM_TIMES) { foo }
  end
  
  reporter.report("returning nil #{NUM_TIMES} with empty last statement") do
    def foo
    end
    
    1.upto(NUM_TIMES) { foo }
  end
end
