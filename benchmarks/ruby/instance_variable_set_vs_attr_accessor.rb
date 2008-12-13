class Foo
  attr_writer :one

  def two=(s)
    @two = s
  end

  attr_reader :one, :two, :three
end


require "benchmark"

TIMES_TO_RUN = 1000000.freeze
RANGE = 1..TIMES_TO_RUN.freeze
ARRAY = RANGE.to_a.freeze


Benchmark.bmbm do |reporter|
  reporter.report("assignment through attr_writer, running #{TIMES_TO_RUN} times") do
    RANGE.each do
      obj = Foo.new
      obj.one = "hello"
    end
  end

  reporter.report("assignment through custom writer, running #{TIMES_TO_RUN} times") do
    RANGE.each do
      obj = Foo.new
      obj.two = "hello"
    end
  end

  reporter.report("assignment through instance_variable_set, running #{TIMES_TO_RUN} times") do
    RANGE.each do
      obj = Foo.new
      obj.instance_variable_set :"@three", "hello"
    end
  end

  reporter.report("assignment through instance eval, assigning the var directly, running #{TIMES_TO_RUN} times") do
    RANGE.each do
      obj = Foo.new
      obj.instance_eval do
        @four = "hello"
      end
    end
  end
end
