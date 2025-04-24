---
marp: true
title: Prometheus Service Discovery
description: Prometheus Service Discovery
theme: uncover
paginate: true
_paginate: false
header: "**Enis Spahi** Short and Sweet"
style: |
  section {
    font-size: 30px;
  }
---

## Short and sweet

# Prometheus: Service Discovery

---

## Challenge

- Pull based scraping
```
scrape_configs:
  - job_name: 'serviceA'
    metrics_path: /metrics
    static_configs:
      - targets: [ '<serviceA_host>:8080' ]
```
* Works well for:
  - Static targets, Black box monitoring...
* Dynamic targets?
  - K8s, Cloud...
  
---

## `service-discovery` to the rescue

- `kubernetes_sd_config`
  - Takes advantage of `__meta_kubernetes_*`
```
scrape_configs:
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
```
- Cloud providers: 
  - `azure_sd_config`, `ec2_sd_config`, etc
- SD middleware: 
  - `consul_sd_config`, `eureka_sd_config`, etc
- [Full list of supported SD mechanisms](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)

---

## Configuration

- When using precompiled binaries
```
./prometheus --config.file=<your_prometheus.yml>
```
- When using Docker
```
docker run \
    -p 9090:9090 \
    -v <your_prometheus.yml>:/etc/prometheus/prometheus.yml \
    prom/prometheus
```
- When using helm charts
```
helm install prometheus-local prometheus-community/prometheus -f <your values.yaml file>
```

---

# Demo

- Deploy `demo-app` service
```
helm upgrade --install demo-app helm/demo-app/
```

- Provision prometheus stack
```
helm upgrade --install prometheus-local helm/prometheus/ 
```

---

# References

- [Prometheus configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)
- [Binary distributions](https://prometheus.io/download/)
- [Docker image](https://hub.docker.com/r/prom/prometheus)
- [Helm chart](https://artifacthub.io/packages/helm/prometheus-community/prometheus)

---

# Q&A