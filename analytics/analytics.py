import json
import random
import uuid
from datetime import datetime
from enum import Enum

import uvicorn
from confluent_kafka import Producer
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

import ccloud_lib
from timer import RepeatedTimer

SIMULATION_INTERVAL = 3
TOPIC = "events"

tags_metadata = [
  {
    "name": "events",
    "description": "Operations with events. The **simulation** logic is also here.",
  }
]


class EventType(Enum):
  START_SESSION = 1
  END_SESSION = 2
  REVENUE = 3


class Event(BaseModel):
  device_id: str
  event_type: str
  created_on: str


def acked(err, msg):
  global delivered_records
  """Delivery report handler called on
  successful or failed delivery of message
  """
  if err is not None:
    print("Failed to deliver message: {}".format(err))
  else:
    delivered_records += 1
    print("Produced record to topic {} partition [{}] @ offset {}"
          .format(msg.topic(), msg.partition(), msg.offset()))


def send_event():
  producer.produce(TOPIC, key="analytics-0",
                   value=json.dumps({"device_id": str(uuid.uuid1()),
                                     "event_type": random.choice(
                                         list(EventType)).name,
                                     "created_on": str(datetime.now())
                                     }),
                   on_delivery=acked)


app = FastAPI(title="Brokerlytics", openapi_tags=tags_metadata)
timer = RepeatedTimer(send_event)

conf = ccloud_lib.read_ccloud_config("../librdkafka.config")
producer_conf = ccloud_lib.pop_schema_registry_params_from_config(conf)
producer = Producer(producer_conf)
ccloud_lib.create_topic(conf, TOPIC)


@app.post("/events/simulation", tags=["events"], status_code=200)
def start_simulation(interval: int):
  if timer.running:
    raise HTTPException(status_code=400, detail="Simulation already started")

  timer.start(interval)


@app.delete("/events/simulation", tags=["events"], status_code=200)
def stop_simulation():
  if not timer.running:
    raise HTTPException(status_code=400,
                        detail="No simulation running at the moment")

  timer.stop()


@app.post("/events", tags=["events"], status_code=201)
def create_event(event: Event):
  producer.send('events', event)


if __name__ == "__main__":
  uvicorn.run(app, host="0.0.0.0", port=8000)
