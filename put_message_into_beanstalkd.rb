require 'beanstalk-client'
require 'benchmark'

beanstalk = Beanstalk::Pool.new(['beanstalkd:11300'])
count = 1000

write_time = Benchmark.measure do
  # Write messages to Beanstalkd
  count.times do |i|
    message = "message_#{i}"
    beanstalk.put(message)
    puts "Wrote message: #{message}"
  end
end

read_time = Benchmark.measure do
  # Read messages from Beanstalkd
  count.times do |i|
    # Watch the default tube
    beanstalk.watch('default')

    # Reserve a job (message) from the queue
    job = beanstalk.reserve

    # Print the message
    puts "Read message: #{job.body}"

    # Delete the job from the queue
    job.delete

    # Close the connection
    beanstalk.close
  end
end

puts "Execution time write: #{write_time.real} seconds"
puts "Execution time read: #{read_time.real} seconds"
