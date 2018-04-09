### Example

Given the environment seen here, the following configuration will be written to the Kafka broker properties.

```
KAFKA_ADVERTISED_PORT:PLAINTEXT://192.168.90.28:30092
```

The resulting configuration:

```
advertised.listeners=PLAINTEXT://192.168.90.28:30092 
```