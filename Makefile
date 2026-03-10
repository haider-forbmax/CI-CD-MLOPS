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

hf-login:
	git pull origin update
	git switch update

push-hub:
	HF_TOKEN=$(HF) python -m huggingface_hub._snapshot_download upload kingabzpro/Drug-Classification ./APP --repo-type=space --commit-message="Sync App files"
	HF_TOKEN=$(HF) python -c "from huggingface_hub import HfApi; api = HfApi(token='$(HF)'); api.upload_folder(folder_path='./Model', repo_id='kingabzpro/Drug-Classification', repo_type='space', commit_message='Sync Model')"
	HF_TOKEN=$(HF) python -c "from huggingface_hub import HfApi; api = HfApi(token='$(HF)'); api.upload_folder(folder_path='./Results', repo_id='kingabzpro/Drug-Classification', repo_type='space', commit_message='Sync Metrics')"

deploy: install hf-login push-hub