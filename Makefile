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
	@USER_NAME=$(USER_NAME); \
	USER_EMAIL=$(USER_EMAIL); \
	if [ -z "$$USER_NAME" ]; then \
		USER_NAME=$$(git config --global user.name || echo "CI User"); \
	fi; \
	if [ -z "$$USER_EMAIL" ]; then \
		USER_EMAIL=$$(git config --global user.email || echo "ci@example.com"); \
	fi; \
	git config --global user.name "$$USER_NAME"; \
	git config --global user.email "$$USER_EMAIL"; \
	git commit -am "Update with new results" || true; \
	git push --force origin HEAD:update || echo "No changes to push"