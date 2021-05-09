bootstrap: bootstrap-analytics bootstrap-feeder bootstrap-visualization

run: run-analytics run-feeder run-visualization

bootstrap-analytics:
	cd ./analytics && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt

bootstrap-feeder:
	cd ./feeder && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt

bootstrap-visualization:
	cd ./visualization && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt

run-analytics:
	cd ./analytics && uvicorn analytics:app --reload --root-path /api/v1

run-feeder:
	cd ./feeder && python3 feeder.py

run-visualization:
	cd ./visualization && streamlit run visualization.py
