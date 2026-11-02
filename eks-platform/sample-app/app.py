import os
import time

from flask import Flask, jsonify, request, g
from prometheus_client import (
    Counter,
    Histogram,
    CONTENT_TYPE_LATEST,
    generate_latest,
)
from werkzeug.routing import RequestRedirect

app = Flask(__name__)

APP_NAME = os.getenv("APP_NAME", "devops-production-lab")
APP_ENV = os.getenv("APP_ENV", "dev")
APP_VERSION = os.getenv("APP_VERSION", "1.0.2")

REQUEST_COUNT = Counter(
    "http_requests_total",
    "Total HTTP requests",
    ["method", "endpoint", "status"]
)

REQUEST_LATENCY = Histogram(
    "http_request_duration_seconds",
    "HTTP request latency in seconds",
    ["method", "endpoint"],
    buckets=(
        0.005, 0.01, 0.025, 0.05, 0.1,
        0.2, 0.3, 0.5, 1.0, 2.5, 5.0
    )
)


@app.before_request
def start_timer():
    g.start_time = time.perf_counter()


@app.after_request
def record_metrics(response):
    # Do not count Prometheus scrapes as application traffic.
    if request.path == "/metrics":
        return response

    duration = time.perf_counter() - g.start_time

    # Use the URL rule instead of raw paths to avoid high-cardinality labels.
    endpoint = request.url_rule.rule if request.url_rule else "unmatched"

    REQUEST_COUNT.labels(
        method=request.method,
        endpoint=endpoint,
        status=str(response.status_code)
    ).inc()

    REQUEST_LATENCY.labels(
        method=request.method,
        endpoint=endpoint
    ).observe(duration)

    return response


@app.route("/")
def home():
    return jsonify({
        "message": "DevOps Production Lab Application",
        "app_name": APP_NAME,
        "environment": APP_ENV,
        "version": APP_VERSION,
        "status": "running"
    })


@app.route("/health")
def health():
    return jsonify({"status": "healthy"}), 200


@app.route("/ready")
def ready():
    return jsonify({"status": "ready"}), 200


@app.route("/metrics")
def metrics():
    return app.response_class(
        generate_latest(),
        mimetype=CONTENT_TYPE_LATEST
    )


# Lab-only endpoints used to generate test metrics.
@app.route("/demo-error")
def demo_error():
    return jsonify({"error": "simulated server error"}), 503


@app.route("/demo-slow")
def demo_slow():
    time.sleep(0.5)
    return jsonify({"status": "slow response simulated"}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)