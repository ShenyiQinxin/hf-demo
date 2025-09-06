venv:
	rm -rf .venv
	python3 -m venv .venv
	
install:
	pip install --upgrade pip && pip install -r requirements.txt


test:
	python -m pytest -vvv --cov=hello --cov=greeting \
		--cov=smath --cov=web tests
	python -m pytest --nbval notebook.ipynb #tests the jupyter notebook
	

debug:
	python -m pytest -vv --pdb # Debugger is invoked








	
