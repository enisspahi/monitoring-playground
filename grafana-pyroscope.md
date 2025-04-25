---
marp: true
title: Grafana Pyroscope
description: Continuous Profiling with Grafana Pyroscope
theme: uncover
paginate: true
_paginate: false
header: "**Enis Spahi** Continuous Profiling with Grafana Pyroscope"
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

# Demo 1: Docker Compose

Provision Grafana Pyroscope and a Demo Application
```
just provision-pyroscope-docker-compose
```


> ℹ️ Prerequisite: Just Command line runner (`brew install just`)

---

# Demo 2: Kubernetes (Helm)

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

## Key takeaways

- Traditional profiling
  - Deeper insights but overhead in PROD
  - More suitable during development
- Continuous profiling
  - Cloud native
  - Some profile types not supported (Pyroscope Java)
  - Combinable with metrics, tracing 
- Tuning / JVM Ergonomics
  - Being conservative helps to discover performance issues
  - `-Xmx`, `-XX:MaxRAMPercentage`

---


# References

- [Grafana Pyroscope](https://grafana.com/docs/pyroscope/latest/)
- [Application Observability Code Challenge 1 by Cees Bos](https://openvalue.blog/posts/2025/01/17/aocc-challenge-01/)
- [Secrets of Performance Tuning Java on Kubernetes by Bruno Borges](https://youtu.be/wApqCjHWF8Q?si=xlPMICKCgGj9Tz0K)

---

# Q&A