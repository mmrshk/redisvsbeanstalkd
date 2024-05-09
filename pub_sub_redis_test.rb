require 'redis'
require 'benchmark'

# Create a Redis client
redis = Redis.new(host: 'redis_rdb', port: 6379)
count = 100000  # Number of messages to publish

subscriber = nil
publisher = nil

subscriber_time = Benchmark.measure do
  subscriber = Thread.new do
    redis.subscribe('channel') do |on|
      on.message do |channel, message|
        puts "Received message '#{message}' on channel '#{channel}'"
      end
    end
  end
end


# Publish messages to the channel
publisher_time = Benchmark.measure do
  publisher = Thread.new do
    count.times do |i|
      message = "Message #{i+1}"
      redis.publish('channel', message)
      puts "Published message '#{message}' to channel 'channel'"
    end
  end
end

# Wait for threads to finish
publisher.join
subscriber.kill

# Output benchmark results
puts "Benchmark Results:"
puts "Subscribe time (average): #{subscriber_time} seconds"
puts "Publish time (average): #{publisher_time} seconds"
