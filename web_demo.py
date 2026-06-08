from pathlib import Path
import json
import io

from flask import Flask, render_template, request, redirect, url_for
import tensorflow as tf

ROOT = Path(__file__).resolve().parent
MODEL_PATH = ROOT / "artifacts" / "batik_mobilenetv2_best.keras"
CLASS_NAMES_PATH = ROOT / "artifacts" / "class_names.json"
IMAGE_SIZE = 224

app = Flask(__name__)

if not MODEL_PATH.exists():
    raise FileNotFoundError(
        f"Saved model not found at {MODEL_PATH}. Run train_mobilenetv2.py first."
    )

model = tf.keras.models.load_model(str(MODEL_PATH))

if CLASS_NAMES_PATH.exists():
    class_names = json.loads(CLASS_NAMES_PATH.read_text())
else:
    class_names = [f"class_{i}" for i in range(model.output_shape[-1])]


def prepare_image(image_bytes: bytes) -> tf.Tensor:
    image = tf.io.decode_image(image_bytes, channels=3, expand_animations=False)
    image = tf.image.resize(image, [IMAGE_SIZE, IMAGE_SIZE])
    image = tf.cast(image, tf.float32)
    image = tf.keras.applications.mobilenet_v2.preprocess_input(image)
    return tf.expand_dims(image, axis=0)


@app.route("/", methods=["GET", "POST"])
def index():
    prediction = None
    probabilities = None
    filename = None

    if request.method == "POST":
        file = request.files.get("image")
        if file and file.filename:
            image_bytes = file.read()
            input_tensor = prepare_image(image_bytes)
            preds = model.predict(input_tensor)
            preds = preds[0].tolist()
            top_index = int(tf.argmax(preds, axis=-1).numpy())
            prediction = class_names[top_index] if top_index < len(class_names) else str(top_index)
            probabilities = [
                {"label": class_names[i] if i < len(class_names) else str(i), "score": float(pred)}
                for i, pred in enumerate(preds)
            ]
            filename = file.filename

    return render_template(
        "index.html",
        prediction=prediction,
        probabilities=probabilities,
        filename=filename,
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
