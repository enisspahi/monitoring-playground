build:
    ./gradlew build

run-app:
    just build
    java -Xmx1024m -XX:StartFlightRecording=filename=.out/recording.jfr -jar build/libs/monitoring-playground-0.0.1-SNAPSHOT.jar

download-pyroscope:
    @mkdir -p docker/grafana_pyroscope/.pyroscope
    @echo "Downloading pyroscope.jar"
    curl -sL -o docker/grafana_pyroscope/.pyroscope/pyroscope.jar https://github.com/grafana/pyroscope-java/releases/download/v2.1.0/pyroscope.jar
    ls -lh docker/grafana_pyroscope/.pyroscope/

provision-pyroscope-docker-compose:
    just build
    just download-pyroscope
    docker compose -f docker/grafana_pyroscope/docker-compose.yaml up -d --build

decomission-pyroscope-docker-compose:
    docker compose -f docker/grafana_pyroscope/docker-compose.yaml down

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
