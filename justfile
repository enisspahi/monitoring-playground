build:
    ./gradlew build

run-app:
    just build
    java -Xmx1024m -XX:StartFlightRecording=filename=.out/recording.jfr -jar build/libs/monitoring-playground-0.0.1-SNAPSHOT.jar

download-pyroscope PYROSCOPE_AGENT_DIR:
    @mkdir -p docker/grafana_pyroscope/.pyroscope
    @echo "Downloading pyroscope.jar"
    curl -sL -o {{PYROSCOPE_AGENT_DIR}}/.pyroscope/pyroscope.jar https://github.com/grafana/pyroscope-java/releases/download/v2.1.2/pyroscope.jar
    ls -lh {{PYROSCOPE_AGENT_DIR}}/.pyroscope/

download-opentelemetry:
    @mkdir -p docker/opentelemetry/.otel
    @echo "Downloading opentelemetry-javaagent.jar"
    curl -sL -o docker/opentelemetry/.otel/opentelemetry-javaagent.jar https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v2.16.0/opentelemetry-javaagent.jar
    ls -lh docker/opentelemetry/.otel/

download-pyroscope-otel:
    @mkdir -p docker/opentelemetry/.pyroscope-otel
    @echo "Downloading pyroscope-otel.jar"
    curl -sL -o docker/opentelemetry/.pyroscope-otel/pyroscope-otel.jar https://github.com/grafana/otel-profiling-java/releases/download/v0.10.3/pyroscope-otel.jar
    ls -lh docker/opentelemetry/.pyroscope-otel/

provision-pyroscope-docker-compose:
    just build
    just download-pyroscope docker/grafana_pyroscope
    docker compose -f docker/grafana_pyroscope/docker-compose.yaml create
    docker compose -f docker/grafana_pyroscope/docker-compose.yaml up -d --build

decomission-pyroscope-docker-compose:
    docker compose -f docker/grafana_pyroscope/docker-compose.yaml down

provision-opentelemetry-docker-compose:
    just build
    just download-opentelemetry
    just download-pyroscope-otel
    #just download-pyroscope docker/opentelemetry
    docker compose -f docker/opentelemetry/docker-compose.yaml create
    docker compose -f docker/opentelemetry/docker-compose.yaml up -d --build

decomission-opentelemetry-docker-compose:
    docker compose -f docker/opentelemetry/docker-compose.yaml down

provision-pyroscope-k8:
    kubectl get namespace pyroscope-test >/dev/null 2>&1 || kubectl create namespace pyroscope-test
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update
    helm upgrade -i -n pyroscope-test pyroscope grafana/pyroscope
    helm upgrade -i -n pyroscope-test --reuse-values grafana grafana/grafana --values helm/pyroscope/values-grafana.yaml

decomission-pyroscope-k8:
    helm uninstall -n pyroscope-test pyroscope
    helm uninstall -n pyroscope-test grafana

deploy-demo-app-k8:
    eval $(minikube docker-env)
    docker build -f Dockerfile -t demo-app .
    helm upgrade -i -n pyroscope-test demo-app helm/demo-app

decomission-demo-app-k8:
    helm uninstall -n pyroscope-test demo-app
