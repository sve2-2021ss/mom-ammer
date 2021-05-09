# Analytics

## 🚀 Get Started
```sh
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn analytics:app --reload --root-path /api/v1
```

## ✨ Functionality
| Method 	| Route                       	| Description                                                              	|
|--------	|-----------------------------	|--------------------------------------------------------------------------	|
| POST   	| events/simulation?duration= 	| Starts the simulation which will send events in the predefined interval. 	|
| DELETE 	| events/simulation           	| Stops the simulation.                                                    	|
| POST   	| events                      	| Creates a new event which will be sent to the broker                     	|

![](.github/openapi.png)

## 💻 Implementation

The producer itself uses the `confluent-kafka` package and the provided `ccloud_lib.py` file. The actual sending of events can then be realized with the following lines:

```python
conf = ccloud_lib.read_ccloud_config("../librdkafka.config")
producer_conf = ccloud_lib.pop_schema_registry_params_from_config(conf)
producer = Producer(producer_conf)
ccloud_lib.create_topic(conf, TOPIC)
...
producer.produce(topic, key="key", value=value, on_delivery=acked)
```

## 🌐 Confluent

One advantage of Confluent is the Control Center which allows adding, viewing, editing, and deleting Apache Kafka topics with the topic management interface. The following screenshot shows the latest produced events and different metrics:

![](.github/events.png)

