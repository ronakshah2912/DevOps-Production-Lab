import os
from flask import Flask, jsonify

app = Flask(__name__)

APP_NAME = os.getenv("APP_NAME", "devops-production-lab")
APP_ENV = os.getenv("APP_ENV", "dev")
APP_VERSION = os.getenv("APP_VERSION", "1.0.0")


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
    return jsonify({
        "status": "healthy"
    }), 200


@app.route("/ready")
def ready():
    return jsonify({
        "status": "ready"
    }), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)