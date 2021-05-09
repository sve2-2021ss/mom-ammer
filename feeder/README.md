# Feeder

## 🚀 Get Started
```sh
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python3 feeder.py
```

## ✨ Functionality
The output of the feeder which shows all consumed records:

![](.github/feeder.png)

## 💻 Implementation

The consumer itself uses the `confluent-kafka` package and the provided `ccloud_lib.py` file. The actual receiving of events can then be realized with the following lines:

```python
conf = ccloud_lib.read_ccloud_config("../librdkafka.config")
consumer_conf = ccloud_lib.pop_schema_registry_params_from_config(conf)
consumer_conf['group.id'] = 'feeder_group_1'
consumer_conf['auto.offset.reset'] = 'earliest'
consumer = Consumer(consumer_conf)
consumer.subscribe([topic])
...
msg = consumer.poll(1.0)
```

## 🌐 Confluent

The Confluent Control Center also shows the different consumers and how many total messages are left:

![](.github/consumer.png)