install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

format:
	black *.py

train:
	python train.py

eval:
	echo "## Model Metrics" > report.md
	cat ./Results/metrics.txt >> report.md
	echo '\n## Confusion Matrix Plot' >> report.md
	echo '![Confusion Matrix](./Results/model_results.png)' >> report.md
	cml comment create report.md

update-branch:
	@if [ -z "$(USER_NAME)" ] || [ -z "$(USER_EMAIL)" ]; then \
		echo "Error: USER_NAME and USER_EMAIL must be provided"; \
		echo "Usage: make update-branch USER_NAME='Your Name' USER_EMAIL='your@email.com'"; \
		exit 1; \
	fi
	git config --global user.name $(USER_NAME)
	git config --global user.email $(USER_EMAIL)
	git commit -am "Update with new results"
	git push --force origin HEAD:update