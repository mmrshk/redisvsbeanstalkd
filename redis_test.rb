require 'redis'
require 'benchmark'

redis = Redis.new(host: 'redis_no_persistence', port: 6379)
count = 1000

write_time = Benchmark.measure do
  count.times do |i|
    key = "key_#{i}"
    value = "value_#{i}"
    redis.set(key, value)
    puts "Wrote key: #{key}, value: #{value}"
  end
end

read_time = Benchmark.measure do
  count.times do |i|
    key = "key_#{i}"
    value = redis.get(key)
    puts "Read key: #{key}, value: #{value}"
  end
end

puts "Execution time write: #{write_time.real} seconds"
puts "Execution time read: #{read_time.real} seconds"
