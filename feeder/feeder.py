import csv
import json

from confluent_kafka import Consumer
from pydantic import BaseSettings

import ccloud_lib

TOPIC = "events"


class Settings(BaseSettings):
  events_file_path: str

  class Config:
    env_file = '.env'
    env_file_encoding = 'utf-8'


settings = Settings()

conf = ccloud_lib.read_ccloud_config("../librdkafka.config")
consumer_conf = ccloud_lib.pop_schema_registry_params_from_config(conf)
consumer_conf['group.id'] = 'feeder_group_1'
consumer_conf['auto.offset.reset'] = 'earliest'
consumer = Consumer(consumer_conf)
consumer.subscribe([TOPIC])

try:
  while True:
    msg = consumer.poll(1.0)
    if msg is None:
      continue
    elif msg.error():
      print('error: {}'.format(msg.error()))
    else:
      record_key = msg.key()
      record_value = msg.value()
      data = json.loads(record_value)
      with open(settings.events_file_path, mode='a') as events_file:
        events_writer = csv.writer(events_file, delimiter=',', quotechar='"',
                                   quoting=csv.QUOTE_MINIMAL)
        events_writer.writerow(
            [data["device_id"], data["event_type"], data["created_on"]])
      print(f"Consumed record with key {record_key} and value {record_value}")
except KeyboardInterrupt:
  pass
finally:
  consumer.close()
