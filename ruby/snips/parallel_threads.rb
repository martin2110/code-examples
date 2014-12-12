def Exception.ignoring_exceptions
  begin
    yield
  rescue Exception => e
    STDERR.puts e.message
  end
end

module Enumerable
  def in_parallel_n(n)
    todo = Queue.new
    ts = (1..n).map{
      Thread.new{
        while x = todo.deq
          Exception.ignoring_exceptions{ yield(x[0]) }
        end
      }
    }
    each{|x| todo << [x]}
    n.times{ todo << nil }
    ts.each{|t| t.join}
  end
end

['echo A ; sleep 4', 'echo B; sleep 2', 'echo C ;sleep 2', 'echo D; sleep 4' ].in_parallel_n(2){|i|
  system(i)
}
