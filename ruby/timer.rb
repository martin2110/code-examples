require 'timeout'
def stopwatch
  Timeout.timeout(5) do
    start = Time.now
    yield
    @time = (Time.now - start).round(2)
  end
end

stopwatch do
  sleep(10)
end
puts @time
