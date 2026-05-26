from __future__ import annotations

import argparse
import csv
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Sequence


IMAGE_EXTENSIONS = {".jpg", ".jpeg", ".png", ".bmp", ".webp"}
DEFAULT_CLASS_DIRS = (
    "batik-bali",
    "batik-megamendung",
    "batik-parang",
    "batik-kawung",
)


@dataclass(frozen=True)
class SplitItem:
    split: str
    class_index: int
    class_name: str
    tier: str
    path: Path


def looks_like_supported_image(path: Path) -> bool:
    try:
        header = path.read_bytes()[:16]
    except OSError:
        return False

    return (
        header.startswith(b"\xff\xd8\xff")
        or header.startswith(b"\x89PNG\r\n\x1a\n")
        or header.startswith(b"GIF87a")
        or header.startswith(b"GIF89a")
        or header.startswith(b"BM")
        or (header.startswith(b"RIFF") and header[8:12] == b"WEBP")
    )


def natural_key(path: Path) -> tuple[tuple[int, object], ...]:
    parts = re.split(r"(\d+)", path.stem.lower())
    key: list[tuple[int, object]] = []
    for part in parts:
        if part.isdigit():
            key.append((0, int(part)))
        elif part:
            key.append((1, part))
    key.append((1, path.suffix.lower()))
    return tuple(key)


def collect_images(class_dir: Path, validate_images: bool) -> tuple[list[Path], list[Path]]:
    if not class_dir.exists():
        raise FileNotFoundError(f"Folder kelas tidak ditemukan: {class_dir}")
    candidates = [
        path
        for path in class_dir.iterdir()
        if path.is_file() and path.suffix.lower() in IMAGE_EXTENSIONS
    ]
    images: list[Path] = []
    invalid_images: list[Path] = []
    for path in sorted(candidates, key=natural_key):
        if validate_images and not looks_like_supported_image(path):
            invalid_images.append(path)
        else:
            images.append(path)
    return images, invalid_images


def build_split(
    dataset_dir: Path,
    class_dirs: Sequence[str],
    train_count: int,
    val_count: int,
    test_count: int,
    strict_test_count: bool,
    validate_images: bool,
    dynamic_split: bool,
) -> tuple[list[SplitItem], list[dict[str, object]]]:
    split_items: list[SplitItem] = []
    summary: list[dict[str, object]] = []

    for class_index, class_name in enumerate(class_dirs):
        images, invalid_images = collect_images(dataset_dir / class_name, validate_images)
        effective_train_count = train_count
        effective_val_count = val_count
        effective_test_count = test_count
        tier = "fixed"
        if dynamic_split:
            if len(images) >= 80:
                effective_train_count = 60
                effective_val_count = 15
                effective_test_count = 15
                tier = "80+"
            elif len(images) >= 50:
                effective_train_count = 30
                effective_val_count = 10
                effective_test_count = 10
                tier = "50+"
            else:
                effective_train_count = 30
                effective_val_count = 10
                effective_test_count = 10
                tier = "<50"

        minimum_needed = effective_train_count + effective_val_count
        if len(images) < minimum_needed:
            raise ValueError(
                f"Kelas {class_name} hanya punya {len(images)} gambar; "
                f"butuh minimal {minimum_needed} untuk train+validation."
            )

        train_images = images[:effective_train_count]
        val_images = images[effective_train_count : effective_train_count + effective_val_count]
        remaining_images = images[effective_train_count + effective_val_count :]
        test_images = (
            remaining_images[-effective_test_count:]
            if len(remaining_images) >= effective_test_count
            else remaining_images
        )
        unused_images = remaining_images[: max(0, len(remaining_images) - len(test_images))]

        if strict_test_count and len(test_images) < effective_test_count:
            raise ValueError(
                f"Kelas {class_name} hanya punya {len(test_images)} gambar test tanpa overlap; "
                f"butuh {effective_test_count}."
            )

        for split_name, paths in (
            ("train", train_images),
            ("validation", val_images),
            ("test", test_images),
        ):
            split_items.extend(
                SplitItem(split_name, class_index, class_name, tier, path) for path in paths
            )

        summary.append(
            {
                "class_name": class_name,
                "tier": tier,
                "total_images": len(images) + len(invalid_images),
                "valid_images": len(images),
                "invalid_images": [
                    path.relative_to(dataset_dir).as_posix() for path in invalid_images
                ],
                "train": len(train_images),
                "validation": len(val_images),
                "test": len(test_images),
                "unused": len(unused_images),
                "warning": (
                    f"test set kurang dari {effective_test_count} karena total gambar kurang dari "
                    f"{effective_train_count + effective_val_count + effective_test_count}"
                    if len(test_images) < effective_test_count
                    else ""
                ),
            }
        )

    return split_items, summary


def write_manifest(split_items: Sequence[SplitItem], output_path: Path, root: Path) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=("split", "class_index", "class_name", "tier", "path"),
        )
        writer.writeheader()
        for item in split_items:
            writer.writerow(
                {
                    "split": item.split,
                    "class_index": item.class_index,
                    "class_name": item.class_name,
                    "tier": item.tier,
                    "path": item.path.relative_to(root).as_posix(),
                }
            )


def write_json(payload: object, output_path: Path) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(payload, indent=2), encoding="utf-8")


def write_history(histories: Sequence[tuple[int, dict[str, list[float]]]], output_path: Path) -> None:
    metric_names: list[str] = []
    for _, history in histories:
        for metric_name in history:
            if metric_name not in metric_names:
                metric_names.append(metric_name)

    with output_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["phase", "epoch", *metric_names])
        writer.writeheader()
        for phase, history in histories:
            rows = max((len(values) for values in history.values()), default=0)
            for index in range(rows):
                row = {"phase": phase, "epoch": index + 1}
                for metric_name in metric_names:
                    values = history.get(metric_name, [])
                    row[metric_name] = values[index] if index < len(values) else ""
                writer.writerow(row)


def import_tensorflow():
    try:
        import tensorflow as tf
    except ImportError as exc:
        raise SystemExit(
            "TensorFlow belum terpasang. Jalankan: "
            ".\\.venv\\Scripts\\python.exe -m pip install -r requirements.txt"
        ) from exc
    return tf


def make_dataset(tf, items: Sequence[SplitItem], image_size: int, batch_size: int, shuffle: bool, seed: int):
    paths = [str(item.path) for item in items]
    labels = [item.class_index for item in items]
    dataset = tf.data.Dataset.from_tensor_slices((paths, labels))

    def load_image(path, label):
        image = tf.io.read_file(path)
        image = tf.image.decode_image(image, channels=3, expand_animations=False)
        image.set_shape([None, None, 3])
        image = tf.image.resize(image, [image_size, image_size])
        image = tf.cast(image, tf.float32)
        return image, label

    if shuffle:
        dataset = dataset.shuffle(buffer_size=len(paths), seed=seed, reshuffle_each_iteration=True)
    return (
        dataset.map(load_image, num_parallel_calls=tf.data.AUTOTUNE)
        .batch(batch_size)
        .prefetch(tf.data.AUTOTUNE)
    )


def compile_model(tf, model, learning_rate: float) -> None:
    model.compile(
        optimizer=tf.keras.optimizers.Adam(learning_rate=learning_rate),
        loss=tf.keras.losses.SparseCategoricalCrossentropy(),
        metrics=["accuracy"],
    )


def build_model(tf, image_size: int, num_classes: int, weights: str | None, dropout: float, learning_rate: float):
    inputs = tf.keras.Input(shape=(image_size, image_size, 3), name="image")
    x = tf.keras.Sequential(
        [
            tf.keras.layers.RandomFlip("horizontal_and_vertical"),
            tf.keras.layers.RandomRotation(0.2),
            tf.keras.layers.RandomZoom(0.2),
            tf.keras.layers.RandomContrast(0.2),
            tf.keras.layers.RandomBrightness(0.2),
        ],
        name="augmentation",
    )(inputs)
    x = tf.keras.applications.mobilenet_v2.preprocess_input(x)

    base_model = tf.keras.applications.MobileNetV2(
        input_shape=(image_size, image_size, 3),
        include_top=False,
        weights=weights,
    )
    base_model.trainable = False

    x = base_model(x, training=False)
    x = tf.keras.layers.GlobalAveragePooling2D(name="avg_pool")(x)
    x = tf.keras.layers.Dropout(dropout, name="dropout")(x)
    outputs = tf.keras.layers.Dense(num_classes, activation="softmax", name="predictions")(x)
    model = tf.keras.Model(inputs, outputs, name="batik_mobilenetv2")
    compile_model(tf, model, learning_rate)
    return model, base_model


def make_callbacks(tf, checkpoint_path: Path, patience: int):
    return [
        tf.keras.callbacks.ModelCheckpoint(
            filepath=str(checkpoint_path),
            monitor="val_accuracy",
            mode="max",
            save_best_only=True,
        ),
        tf.keras.callbacks.EarlyStopping(
            monitor="val_accuracy",
            mode="max",
            patience=patience,
            restore_best_weights=True,
        ),
        tf.keras.callbacks.ReduceLROnPlateau(
            monitor="val_loss",
            factor=0.5,
            patience=2,
            min_lr=1e-7,
        ),
    ]


def compute_training_class_weights(train_items: Sequence[SplitItem], num_classes: int) -> dict[int, float]:
    try:
        import numpy as np
        from sklearn.utils.class_weight import compute_class_weight
    except ImportError as exc:
        raise SystemExit(
            "scikit-learn belum terpasang. Jalankan: "
            ".\\.venv\\Scripts\\python.exe -m pip install -r requirements.txt"
        ) from exc

    labels = np.array([item.class_index for item in train_items])
    classes = np.arange(num_classes)
    weights = compute_class_weight(class_weight="balanced", classes=classes, y=labels)
    return {int(class_index): float(weight) for class_index, weight in zip(classes, weights)}


def unfreeze_last_layers(base_model, layer_count: int) -> None:
    base_model.trainable = True
    for layer in base_model.layers[:-layer_count]:
        layer.trainable = False
    for layer in base_model.layers[-layer_count:]:
        layer.trainable = True


def save_evaluation_outputs(model, test_ds, class_names: Sequence[str], output_dir: Path) -> dict[str, object]:
    try:
        import matplotlib
        matplotlib.use("Agg")
        import matplotlib.pyplot as plt
        import numpy as np
        from sklearn.metrics import classification_report, confusion_matrix
    except ImportError as exc:
        raise SystemExit(
            "matplotlib dan scikit-learn belum terpasang. Jalankan: "
            ".\\.venv\\Scripts\\python.exe -m pip install -r requirements.txt"
        ) from exc

    y_true: list[int] = []
    y_pred: list[int] = []
    for images, labels in test_ds:
        probabilities = model.predict(images, verbose=0)
        y_true.extend(int(label) for label in labels.numpy().tolist())
        y_pred.extend(int(label) for label in np.argmax(probabilities, axis=1).tolist())

    labels = list(range(len(class_names)))
    matrix = confusion_matrix(y_true, y_pred, labels=labels)
    report_text = classification_report(
        y_true,
        y_pred,
        labels=labels,
        target_names=list(class_names),
        zero_division=0,
    )
    report_dict = classification_report(
        y_true,
        y_pred,
        labels=labels,
        target_names=list(class_names),
        zero_division=0,
        output_dict=True,
    )

    output_dir.mkdir(parents=True, exist_ok=True)
    (output_dir / "classification_report.txt").write_text(report_text, encoding="utf-8")

    figure, axis = plt.subplots(figsize=(8, 6))
    image = axis.imshow(matrix, interpolation="nearest", cmap="Blues")
    figure.colorbar(image, ax=axis)
    tick_marks = np.arange(len(class_names))
    axis.set_xticks(tick_marks)
    axis.set_yticks(tick_marks)
    axis.set_xticklabels(class_names, rotation=45, ha="right")
    axis.set_yticklabels(class_names)
    axis.set_ylabel("Actual")
    axis.set_xlabel("Predicted")
    axis.set_title("Confusion Matrix")

    threshold = matrix.max() / 2 if matrix.size and matrix.max() > 0 else 0
    for row_index in range(matrix.shape[0]):
        for col_index in range(matrix.shape[1]):
            axis.text(
                col_index,
                row_index,
                str(matrix[row_index, col_index]),
                ha="center",
                va="center",
                color="white" if matrix[row_index, col_index] > threshold else "black",
            )

    figure.tight_layout()
    figure.savefig(output_dir / "confusion_matrix.png", dpi=160)
    plt.close(figure)

    print("Classification report:")
    print(report_text)

    per_class_accuracy = {
        class_name: float(report_dict[class_name]["recall"]) for class_name in class_names
    }
    return {
        "per_class_accuracy": per_class_accuracy,
        "classification_report": report_dict,
    }


def evaluate_and_save(model, test_ds, class_names: Sequence[str], output_dir: Path) -> dict[str, object]:
    metrics = model.evaluate(test_ds, return_dict=True)
    metrics = {name: float(value) for name, value in metrics.items()}
    evaluation_outputs = save_evaluation_outputs(model, test_ds, class_names, output_dir)
    metrics.update(evaluation_outputs)
    write_json(metrics, output_dir / "test_metrics.json")
    return metrics


def filter_split(items: Sequence[SplitItem], split_name: str) -> list[SplitItem]:
    return [item for item in items if item.split == split_name]


def parse_args(argv: Sequence[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Train MobileNetV2 untuk klasifikasi batik Bali, Megamendung, Parang, dan Kawung."
    )
    parser.add_argument("--dataset-dir", type=Path, default=Path("dataset"))
    parser.add_argument("--output-dir", type=Path, default=Path("artifacts"))
    parser.add_argument("--class-dirs", nargs="+", default=list(DEFAULT_CLASS_DIRS))
    parser.add_argument("--train-count", type=int, default=30)
    parser.add_argument("--val-count", type=int, default=10)
    parser.add_argument("--test-count", type=int, default=10)
    parser.add_argument(
        "--dynamic-split",
        action=argparse.BooleanOptionalAction,
        default=True,
        help="Gunakan split dinamis berdasarkan jumlah gambar valid per kelas.",
    )
    parser.add_argument("--strict-test-count", action="store_true")
    parser.add_argument(
        "--no-validate-images",
        action="store_true",
        help="Jangan cek magic bytes file gambar sebelum membuat split.",
    )
    parser.add_argument("--split-only", action="store_true")
    parser.add_argument(
        "--evaluate-model",
        type=Path,
        default=None,
        help="Path model .keras yang akan dievaluasi pada test set tanpa training ulang.",
    )
    parser.add_argument("--image-size", type=int, default=224)
    parser.add_argument("--batch-size", type=int, default=16)
    parser.add_argument("--epochs", type=int, default=12)
    parser.add_argument("--finetune-epochs", type=int, default=10)
    parser.add_argument("--patience", type=int, default=4)
    parser.add_argument("--dropout", type=float, default=0.25)
    parser.add_argument("--learning-rate", type=float, default=0.0003)
    parser.add_argument("--seed", type=int, default=42)
    parser.add_argument(
        "--weights",
        choices=("imagenet", "none"),
        default="imagenet",
        help="Gunakan 'none' jika tidak ingin download pretrained ImageNet weights.",
    )
    return parser.parse_args(argv)


def main(argv: Sequence[str] | None = None) -> int:
    args = parse_args(sys.argv[1:] if argv is None else argv)
    root = Path.cwd()
    dataset_dir = args.dataset_dir.resolve()
    output_dir = args.output_dir.resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    split_items, summary = build_split(
        dataset_dir=dataset_dir,
        class_dirs=args.class_dirs,
        train_count=args.train_count,
        val_count=args.val_count,
        test_count=args.test_count,
        strict_test_count=args.strict_test_count,
        validate_images=not args.no_validate_images,
        dynamic_split=args.dynamic_split,
    )

    write_manifest(split_items, output_dir / "split_manifest.csv", root)
    write_json(summary, output_dir / "split_summary.json")
    write_json(list(args.class_dirs), output_dir / "class_names.json")

    print("Split dataset:")
    for item in summary:
        warning_parts = []
        if item["invalid_images"]:
            warning_parts.append(f"invalid image dilewati: {', '.join(item['invalid_images'])}")
        if item["warning"]:
            warning_parts.append(str(item["warning"]))
        warning = f" | WARNING: {'; '.join(warning_parts)}" if warning_parts else ""
        print(
            f"- {item['class_name']}: train={item['train']}, "
            f"validation={item['validation']}, test={item['test']}, "
            f"unused={item['unused']}, tier={item['tier']}{warning}"
        )

    if args.split_only:
        print(f"Manifest disimpan di: {output_dir / 'split_manifest.csv'}")
        return 0

    tf = import_tensorflow()
    tf.keras.utils.set_random_seed(args.seed)

    train_items = filter_split(split_items, "train")
    val_items = filter_split(split_items, "validation")
    test_items = filter_split(split_items, "test")

    train_ds = make_dataset(tf, train_items, args.image_size, args.batch_size, True, args.seed)
    val_ds = make_dataset(tf, val_items, args.image_size, args.batch_size, False, args.seed)
    test_ds = make_dataset(tf, test_items, args.image_size, args.batch_size, False, args.seed)

    if args.evaluate_model is not None:
        model = tf.keras.models.load_model(args.evaluate_model)
        metrics = evaluate_and_save(model, test_ds, args.class_dirs, output_dir)
        print(f"Evaluated model: {args.evaluate_model}")
        print(f"Test metrics: {metrics}")
        return 0

    model, base_model = build_model(
        tf=tf,
        image_size=args.image_size,
        num_classes=len(args.class_dirs),
        weights=None if args.weights == "none" else args.weights,
        dropout=args.dropout,
        learning_rate=args.learning_rate,
    )

    class_weight = compute_training_class_weights(train_items, len(args.class_dirs))
    print(f"Class weights: {class_weight}")

    checkpoint_path = output_dir / "batik_mobilenetv2_best.keras"
    callbacks = make_callbacks(tf, checkpoint_path, args.patience)

    history = model.fit(
        train_ds,
        validation_data=val_ds,
        epochs=args.epochs,
        callbacks=callbacks,
        class_weight=class_weight,
    )

    final_model_path = output_dir / "batik_mobilenetv2_final.keras"
    model.save(final_model_path)

    histories: list[tuple[int, dict[str, list[float]]]] = [(1, history.history)]
    finetuned_checkpoint_path = output_dir / "batik_mobilenetv2_finetuned_best.keras"
    finetuned_final_model_path = output_dir / "batik_mobilenetv2_finetuned_final.keras"

    if args.finetune_epochs > 0:
        unfreeze_last_layers(base_model, 30)
        compile_model(tf, model, args.learning_rate * 0.1)
        finetune_callbacks = make_callbacks(tf, finetuned_checkpoint_path, args.patience)
        finetune_history = model.fit(
            train_ds,
            validation_data=val_ds,
            epochs=args.finetune_epochs,
            callbacks=finetune_callbacks,
            class_weight=class_weight,
        )
        model.save(finetuned_final_model_path)
        histories.append((2, finetune_history.history))

    write_history(histories, output_dir / "training_history.csv")

    metrics = evaluate_and_save(model, test_ds, args.class_dirs, output_dir)

    print(f"Model terbaik: {checkpoint_path}")
    print(f"Model final: {final_model_path}")
    if args.finetune_epochs > 0:
        print(f"Model fine-tuned terbaik: {finetuned_checkpoint_path}")
        print(f"Model fine-tuned final: {finetuned_final_model_path}")
    print(f"Test metrics: {metrics}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
