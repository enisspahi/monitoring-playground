---
marp: true
title: Grafana Pyroscope
description: Continuos Profiling with Grafana Pyroscope
theme: uncover
paginate: true
_paginate: false
header: "**Enis Spahi** Short and Sweet"
style: |
  section {
    font-size: 30px;
  }
---

## Continuous Profiling with 
## Grafana Pyroscope

---

## OutOfMemoryError
# 😱

---

## Grafana Pyroscope

- Enables Cloud-native continuous profiling
- Native integration in Grafana
  - Datasource
  - Plugin
- No-code Java integration
  - Push via SDKs
  - Pull via Grafana Alloy (OpenTelemetry)
- Fourth pillar of Observability
  - Can combine profiling with tracing, metrics and logs

---

## Running Pyroscope

- Standalone Binary
- Docker
```
docker run --rm --name pyroscope --network=pyroscope-demo -p 4040:4040 grafana/pyroscope:latest
```
- Kubernetes or Helm charts

---

# Demo 1: Kubernetes (Helm)

Provision Grafana Pyroscope and a Demo Application
```
just provision-pyroscope-docker-compose
```


> ℹ️ Prerequisite: Just Command line runner (`brew install just`)

---

# Demo 2: Helm Installation

Provision Grafana Pyroscope
```
just provision-pyroscope-k8
```

Deploy Demo Application
```
just deploy-demo-app-k8
```

Port forwarding (Optional)
```
minikube service grafana -n pyroscope-test
minikube service demo-app -n pyroscope-test --url
```


---


# References

- [alertmanager](https://prometheus.io/docs/alerting/latest/alertmanager/)
- [Binary distributions](https://prometheus.io/download/)
- [Docker image](https://hub.docker.com/r/prom/alertmanager)
- [Helm chart](https://artifacthub.io/packages/helm/prometheus-community/prometheus)

---

# Q&A