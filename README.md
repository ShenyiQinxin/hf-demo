
---
title: Demo 
emoji: ♻️
colorFrom: pink
colorTo: pink
sdk: gradio
sdk_version: "4.44.1"
app_file: app.py
pinned: false
license: cc
---



# 🤗 Hugging Face Summarizer Demo

[![Hugging Face Spaces](https://img.shields.io/badge/%F0%9F%A4%97%20HuggingFace-Spaces-blue)](https://huggingface.co/spaces/macolulu/demo)

![Docker](https://img.shields.io/badge/Docker-ready-blue?logo=docker)
![Kubernetes](https://img.shields.io/badge/Kubernetes-deployable-326CE5?logo=kubernetes)
![Gradio](https://img.shields.io/badge/Gradio-UI-green?logo=python)

A minimal **text summarization demo** using Hugging Face 🤗 `transformers` + Gradio. Runs locally, in Docker, or on Kubernetes.


## 📦 Features

* Summarization pipeline (T5 or BART depending on framework)
* Simple Gradio UI: paste text → get summary
* Dockerized with non-root user & healthcheck
* Ready to deploy to Kubernetes / Rancher

---

## 🖥️ Preparation (Local Dev)

```sh
# 1. Remove the old virtual env folder
rm -rf .venv

# 2. Recreate a fresh one
python3 -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate

# or
make venv

# 3. Upgrade pip tooling
pip install -U pip

# 4. Install deps from requirements.txt
pip install -r requirements.txt

# or
make install
```

If you change dependencies in `requirements.txt`:

```sh
make install
```

Run the app locally:

```sh
python app.py
```

Gradio will print a local URL (e.g., [http://127.0.0.1:7860](http://127.0.0.1:7860)).

---

## 🐳 Local Docker Workflow

### Step 1: Build

```sh
docker build -t hf-demo:local .
```

### Step 2: Run in background (detached)

```sh
docker run -d -p 8080:8080 --name hf-demo hf-demo:local
```

* `-d` = detached (runs in the background)
* `-p 8080:8080` = publish container port → host port
* `--name hf-demo` = give the container a name

👉 Now your app is live at [http://localhost:8080](http://localhost:8080) and your terminal is free.

### Step 3: Logs

```sh
docker logs -f hf-demo
```

* `-f` = follow logs like `tail -f`
* Shows Gradio server logs

### Step 4: Debug inside container

```sh
docker exec -it hf-demo bash
```

* `-it` = interactive shell
* `bash` = start a shell inside container

Use `exit` to leave — app keeps running.

### Step 5: Stop & clean up

```sh
docker stop hf-demo
```

```sh
docker rm hf-demo
```

```sh
# (optional) remove image
docker rmi hf-demo:local
```

---

## 🖥️ Colima Setup (Optional: Build Docker on macOS without Docker Desktop)

```sh
# Check your Mac’s CPU, RAM, and disk
sysctl -n hw.ncpu && \
echo "$(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 )) GB" && \
df -h /

# Lightweight profile (2 CPU, 4 GB RAM)
colima start dev --cpu 2 --memory 4 --disk 20

# Heavy ML profile (6 CPU, 16 GB RAM)
colima start ml --cpu 6 --memory 16 --disk 80

# Manage profiles
colima list
colima stop <dev/ml>
colima start dev/ml
colima status ml

# Set current context
docker context ls
docker context use colima-ml
```

---
## 😈 Actions Local Dryrun
```sh
brew install act

act workflow_dispatch -W .github/workflows/build-and-push.yml \
  --container-architecture linux/amd64 \
  -P ubuntu-latest=ghcr.io/catthehacker/ubuntu:act-latest \
  --container-daemon-socket /var/run/docker.sock \
  -s GITHUB_TOKEN=ghp_your_PAT_with_write_packages

```

---
## 👩🏾‍🔬 Test the image
```sh
# Pull the image from the registry
docker image pull ghcr.io/shenyiqinxin/hugging-face-demo:main

# Run
docker run --rm -d -p 8080:8080/tcp ghcr.io/shenyiqinxin/hugging-face-demo:main 
# If the docker responded a container ID, then you are ready to test
http://localhost:8080/
```
---



## ☸️ Kubernetes Deployment

Manifests are in `k8s/`.

Deploy:

```sh
kubectl apply -f k8s/namespace.yaml 
kubectl -n hf-demo apply -f k8s/
```

- If issue happens, re-validate and test:

```sh
# sanity-check the tag is multi-arch
docker buildx imagetools inspect ghcr.io/shenyiqinxin/hugging-face-demo:main

# Point the Deployment at the fresh image and force a rollout
kubectl -n hf-demo set image deploy/hugging-face-demo \  app=ghcr.io/shenyiqinxin/hugging-face-demo:main
kubectl -n hf-demo rollout status deploy/hugging-face-demo
kubectl -n hf-demo get pods -o wide

# Test via your Ingress host
kubectl -n hf-demo get ingress
```

- Test the endpoint:

```sh

open http://hf-demo.local
curl -I http://hf-demo.local/
```

- More Operations:
```sh
# Tail logs:
kubectl -n hf-demo logs deploy/hugging-face-demo -f

# Watch events for debugging:
kubectl -n hf-demo get events --sort-by=.lastTimestamp | tail -20

# Check ingress routing:
kubectl -n hf-demo describe ingress hugging-face-demo

# Scale 
kubectl -n hf-demo scale deploy/hugging-face-demo --replicas=2
```
---


## 💜 Git Issues
```
git rm --cached path/to/file
```
---

## 📂 Repo Structure

```
.
├── app.py              # Gradio app
├── requirements.txt    # Python dependencies
├── Dockerfile          # Container build recipe
├── Makefile            # Helper tasks
├── k8s/                # Kubernetes manifests
└── flagged/            # Gradio flagged data
```

---

## ⚖️ License

cc © 2025 
