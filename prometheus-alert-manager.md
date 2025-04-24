---
marp: true
title: Alertmanager
description: Alertmanager
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

# Alertmanager

---

## What is Alertmanager?

- Handles alerts sent by Prometheus
- Features:
    - Deduplicating, Grouping, Routing
    - Silencing
- Notifications:
    - Email, Teams, Slack, PagerDuty, OpsGenie

---

## Running Alertmanager

- Precompiled binaries
```
alertmanager --config.file=<your_config_file>
```
- Docker image
```
docker run --name alertmanager -d -p 127.0.0.1:9093:9093 quay.io/prometheus/alertmanager
```
- Helm charts
```
helm install prometheus-local prometheus-community/prometheus -f <your values.yaml file>
```

---

# Demo

- Deploy `nginx` with monitoring enabled
```
helm upgrade --install nginx-local bitnami/nginx --set metrics.enabled=true
```

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

- [alertmanager](https://prometheus.io/docs/alerting/latest/alertmanager/)
- [Binary distributions](https://prometheus.io/download/)
- [Docker image](https://hub.docker.com/r/prom/alertmanager)
- [Helm chart](https://artifacthub.io/packages/helm/prometheus-community/prometheus)

---

# Q&A