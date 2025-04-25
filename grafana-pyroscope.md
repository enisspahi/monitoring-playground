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

A Smart Meter Aggregator faces OutOfMemoryError while calculating smart meter sum.
We will troubleshoot this using Traditional and Continuous Profiling using Grafana Pyroscope.

---

## Grafana Pyroscope

- Is a Profiling Backend
- Native integration in Grafana ecosystem
  - Datasource
  - Plugin
- Enables Cloud-native continuous profiling
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
```
helm upgrade -i -n pyroscope-test pyroscope grafana/pyroscope
```

---

# Demo 0: Traditional Profiling 

1. Start application with Flight recorder.
```
just run-app
```

2. Simulate successful aggregation of 1000000 smart meter values.
```
curl -L -X POST 'http://localhost:8080/smartMeters/randomSmartMeterValues?meterCount=1000000'
curl -L 'http://localhost:8080/smartMeters/sum'
```

3. Simulate OutOfMemoryError during aggregation of 100000000 smart meter values.
```
curl -L -X POST 'http://localhost:8080/smartMeters/randomSmartMeterValues?meterCount=100000000'
curl -L 'http://localhost:8080/smartMeters/sum'
```

4. Observe `recording.jfr` using JDK Mission Control.

> ℹ️ Prerequisite: Just Command line runner (`brew install just`)
> ℹ️ Prerequisite: JDK Mission Control installation

---

# Demo 1: Docker Compose

1. Provision Grafana Pyroscope and a Demo Application
```
just provision-pyroscope-docker-compose
```

2. Observe Profiling `http://localhost:3000/a/grafana-pyroscope-app`

3. Simulate successful aggregation of 1000000 smart meter values
```
curl -L -X POST 'http://localhost:8080/smartMeters/randomSmartMeterValues?meterCount=1000000'
curl -L 'http://localhost:8080/smartMeters/sum'
```

4. Simulate OutOfMemoryError during aggregation of 100000000 smart meter values
```
curl -L -X POST 'http://localhost:8080/smartMeters/randomSmartMeterValues?meterCount=100000000'
curl -L 'http://localhost:8080/smartMeters/sum'
```

---

# Demo 2: Kubernetes (Helm)

> ⚠️️ This Demo has some failures and is working partially.

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
kubectl -n pyroscope-test port-forward svc/grafana 3000:80
kubectl -n pyroscope-test port-forward svc/demo-app 8080:8080 
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