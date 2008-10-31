require "benchmark"

TIMES_TO_RUN = 20_000_000.freeze
RANGE = 1..TIMES_TO_RUN.freeze
ARRAY = RANGE.to_a.freeze


Benchmark.bm do |reporter|
  # Range
  reporter.report("RANGE for loop, #{TIMES_TO_RUN} times") do
    for x in RANGE; end
  end
  
  reporter.report("RANGE each loop, #{TIMES_TO_RUN} times") do
    RANGE.each { |x| }
  end
  
  # Array
  reporter.report("ARRAY for loop, #{TIMES_TO_RUN} times") do
    for x in ARRAY; end
  end
  
  reporter.report("ARRAY each loop, #{TIMES_TO_RUN} times") do
    ARRAY.each { |x| }
  end
end
