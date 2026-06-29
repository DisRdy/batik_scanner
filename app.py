from __future__ import annotations

import json
import os
from pathlib import Path
from typing import Any

import numpy as np
import tensorflow as tf
from flask import Flask, jsonify, request, send_from_directory
from flask_cors import CORS
from keras.applications.mobilenet_v2 import preprocess_input


ROOT_DIR = Path(__file__).resolve().parent
ARTIFACTS_DIR = ROOT_DIR / "artifacts"
IMAGE_SIZE = 224
DEFAULT_CLASS_NAMES = [
    "batik-bali",
    "batik-kawung",
    "batik-megamendung",
    "batik-parang",
]
MODEL_CANDIDATES = [
    ARTIFACTS_DIR / "batik_mobilenetv2_finetuned_best.keras",
    ARTIFACTS_DIR / "batik_mobilenetv2_finetuned_final.keras",
    ARTIFACTS_DIR / "batik_mobilenetv2_best.keras",
    ARTIFACTS_DIR / "batik_mobilenetv2_final.keras",
]


app = Flask(__name__)
app.config["MAX_CONTENT_LENGTH"] = 12 * 1024 * 1024
CORS(app)


def env_flag(name: str, default: bool) -> bool:
    value = os.environ.get(name)
    if value is None:
        return default
    return value.strip().lower() in {"1", "true", "yes", "on"}


def find_model_path() -> Path:
    configured_path = os.environ.get("MODEL_PATH")
    if configured_path:
        path = Path(configured_path)
        if not path.is_absolute():
            path = ROOT_DIR / path
        if not path.exists():
            raise FileNotFoundError(f"MODEL_PATH does not exist: {path}")
        return path

    for path in MODEL_CANDIDATES:
        if path.exists():
            return path

    keras_files = sorted(ARTIFACTS_DIR.glob("*.keras"), key=lambda item: item.stat().st_mtime, reverse=True)
    if keras_files:
        return keras_files[0]

    raise FileNotFoundError(f"No .keras model found in {ARTIFACTS_DIR}")


def load_class_names() -> list[str]:
    class_names_path = ARTIFACTS_DIR / "class_names.json"
    if class_names_path.exists():
        with class_names_path.open("r", encoding="utf-8") as handle:
            class_names = json.load(handle)
        if not isinstance(class_names, list) or not all(isinstance(name, str) for name in class_names):
            raise ValueError(f"Invalid class names file: {class_names_path}")
        return class_names
    return DEFAULT_CLASS_NAMES


MODEL_PATH = find_model_path()
CLASS_NAMES = load_class_names()
MODEL_INCLUDES_PREPROCESS = env_flag("MODEL_INCLUDES_PREPROCESS", True)
MODEL = tf.keras.models.load_model(MODEL_PATH, compile=False)


def preprocess_image(image_bytes: bytes) -> tf.Tensor:
    image = tf.io.decode_image(image_bytes, channels=3, expand_animations=False)
    image.set_shape([None, None, 3])
    image = tf.image.resize(image, [IMAGE_SIZE, IMAGE_SIZE])
    image = tf.cast(image, tf.float32)
    image = tf.expand_dims(image, axis=0)

    # The training script in this project saves preprocess_input inside the model.
    # Set MODEL_INCLUDES_PREPROCESS=false if you serve a model that expects external preprocessing.
    if not MODEL_INCLUDES_PREPROCESS:
        image = preprocess_input(image)
    return tf.convert_to_tensor(image, dtype=tf.float32)


def predict_batik(image_bytes: bytes) -> dict[str, Any]:
    batch = preprocess_image(image_bytes)
    predictions = MODEL.predict(batch, verbose=0)
    probabilities = np.asarray(predictions[0], dtype=np.float64)

    if len(probabilities) != len(CLASS_NAMES):
        raise ValueError(
            f"Model returned {len(probabilities)} classes, but {len(CLASS_NAMES)} class names are configured."
        )

    predicted_index = int(np.argmax(probabilities))
    confidence = float(probabilities[predicted_index])
    all_predictions = [
        {
            "class": class_name,
            "confidence": float(probability),
            "confidence_percent": round(float(probability) * 100, 2),
        }
        for class_name, probability in sorted(
            zip(CLASS_NAMES, probabilities, strict=True),
            key=lambda item: item[1],
            reverse=True,
        )
    ]

    return {
        "class": CLASS_NAMES[predicted_index],
        "confidence": confidence,
        "confidence_percent": round(confidence * 100, 2),
        "model": MODEL_PATH.name,
        "all_predictions": all_predictions,
    }


@app.get("/")
def index():
    return send_from_directory(ROOT_DIR, "index.html")


@app.post("/predict")
def predict():
    upload = request.files.get("image") or request.files.get("file")
    if upload is None and request.files:
        upload = next(iter(request.files.values()))

    if upload is None or upload.filename == "":
        return jsonify({"error": "Upload an image file using the 'image' form field."}), 400

    image_bytes = upload.read()
    if not image_bytes:
        return jsonify({"error": "Uploaded image is empty."}), 400

    try:
        return jsonify(predict_batik(image_bytes))
    except Exception as exc:
        return jsonify({"error": f"Prediction failed: {exc}"}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
