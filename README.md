# Redis VS Beanstalkd

```
docker-compose exec ruby_app ruby /scripts/put_message_into_beanstalkd.rb
docker-compose exec ruby_app ruby /scripts/redis_test.rb
```


# Comparison of Beanstalkd and Redis

|                | Beanstalkd                                            | Redis RDB (save every 1 sec) | Redis RDB (save every 900 sec) | Redis (AOF) | Redis (no perisistance)|
|----------------|-------------------------------------------------------|-----------------------|--------------------------------|-----------|-|
| Read (1000)    | 0.31240408400026354                                   | 0.07293295799991029               |0.08627608299957501|0.07085516699953587| 0.07068204200004402|
| Read (10000)   | 3.030736875999537                                     | 0.891405375999966               |0.9264851249999992|0.971050708999428|0.7403629590007768|
| Read (100000)  | Fails to read (command was executed approx for 14sec) | 7.503849419999824               |7.345335752999745|7.610267711999768|7.411969378000322|
| Write (1000)   | 0.07317079200038279                                   | 0.06761579199974221                    |0.09655762500005949|0.19100258300022688|0.0834398750002947|
| Write (10000)  | 0.6748607500003345                                    | 0.7451700840001649              |0.7430313750001005|1.9541286670000773|0.7383083329996225|
| Write (100000) | 6.718112670000664                                     | 7.453999336000379               |7.85212825400049|17.347652258999915|8.186447586999748|

Beanstalkd read for 100.000 of messages
![Screenshot 2024-05-09 at 15.49.27.png](..%2F..%2F..%2FDesktop%2FScreenshot%202024-05-09%20at%2015.49.27.png)

# Redis PubSub:

## Benchmark Results for (1000):
Subscribe time (average): 0.000026 seconds
Publish time (average): 0.000015 seconds

## Benchmark Results for (10000):
Subscribe time (average):  0.000031 seconds
Publish time (average):  0.000016 seconds

## Benchmark Results for (100000):
Subscribe time (average): 0.000035 seconds
Publish time (average):  0.000019 seconds

Looking at this data we can say that time slightly increases.
g
---

Based on the provided data, we can make the following observations:

# Read Operations:
- Beanstalkd generally performs better than Redis RDB with a save interval of 1 second, especially for smaller read operations.
- Redis RDB with a save interval of 1 second performs slightly better than Redis RDB with a save interval of 900 seconds for smaller read operations.
- Redis with append-only file (AOF) and Redis with no persistence have similar read performance, and both are slower compared to Redis RDB with shorter save intervals.

# Write Operations:
- Beanstalkd performs similarly to Redis RDB with a save interval of 1 second for smaller write operations.
- Redis RDB with a save interval of 1 second performs slightly better than Redis RDB with a save interval of 900 seconds for smaller write operations.
- Redis with append-only file (AOF) has significantly slower write performance compared to other configurations, especially for larger write operations.

# Overall:
- Beanstalkd generally performs well for both read and write operations, especially for smaller operations.
- Redis with append-only file (AOF) has slower performance compared to Redis with RDB persistence, especially for write operations, likely due to the additional disk I/O overhead.
- Redis with no persistence performs similarly to Redis with longer RDB save intervals for both read and write operations.
