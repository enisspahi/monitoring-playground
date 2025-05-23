---
marp: true
title: OpenTelemetry
description: OpenTelemetry
theme: uncover
paginate: true
_paginate: false
header: "**Enis Spahi** OpenTelemetry"
style: |
  section {
    font-size: 26px;
  }

---

# OpenTelemetry

---

### Observability Ecosystem

![width:800px](docs/observability_without_otlp.png)

---

## OpenTelemetry

OpenTelemetry is a set of standardized APIs, tools, and libraries for instrumenting applications to provide observability through metrics, logs, and traces.

---

## OpenTelemetry

* Standardized metrics, logs and traces
* Federated by Cloud Native Computing Foundation (CNCF)
* Language SDKs:
  * Instrument your application and emit Metrics, Logs, Traces as signals
  * Java SDKs:
    * [Java Instrumentation Agent](https://github.com/open-telemetry/opentelemetry-java-instrumentation)
    * [Spring Boot Starter](https://opentelemetry.io/docs/zero-code/java/spring-boot-starter/)
    * [Quarkus OpenTelemetry extension](https://quarkus.io/guides/opentelemetry)
* OpenTelemetry Collector:
  * Receives, processes and exports telemetry data to a backend
  * Runnable as Binary, Docker image, Kubernetes Operator, Grafana Alloy
  * Usually provided by monitoring-as-a-service providers such as Grafana Cloud, Datadog, etc

---

# Demo 1

1. Provision an observability stack and a Demo Application
```
just provision-opentelemetry-docker-compose
```

2. Observe `http://localhost:3000/`

3. Simulate successful aggregation of 1000000 smart meter values
```
curl -L -X POST 'http://localhost:8080/smartMeters/randomSmartMeterValues?meterCount=1000000'
curl -L 'http://localhost:8080/smartMeters/sum'
```


> ℹ️ Prerequisite: Just Command line runner (`brew install just`)

---

# Demo 1 (Stack)

![width:800px](docs/OpenTelemetry.drawio.svg)

---

# If I have been using Prometheus

- `UP` metric not available
  - A [Health Check Extension](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/extension/healthcheckv2extension/README.md) as a replacement
- [Histograms](https://opentelemetry.io/docs/specs/otel/compatibility/prometheus_and_openmetrics/) have different semantics
  - OpenTelemetry implements Exponential (Native) Histograms
  - Prometheus native histograms are in progress and can be enabled with `--enable-feature=native-histograms`

---

# How to migrate to OpenTelemetry?

1. OpenTelemetry Collector: Add Prometheus receiver (drop-in-replacement) 
```
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318
  prometheus:
    config:
      scrape_configs:
        - job_name: 'demo-app'
          static_configs:
            - targets: ['demo-app:8080']
```
2. Prometheus: Switch scrape target from direct to OpenTelemetry collector
```
scrape_configs:
  - job_name: 'otel-collector'
    static_configs:
      - targets: ["opentelemetry-collector:8889"]
```
3. Application: Switch to OpenTelemetry Java Agent (or other SDKs)

---

# References

- [OpenTelemetry](https://opentelemetry.io/docs/)
- [Grafana docs](https://grafana.com/docs/)
- [Observability Toolkit by Cees Bos](https://github.com/cbos/observability-toolkit)
