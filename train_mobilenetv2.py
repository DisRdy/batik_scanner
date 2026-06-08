from __future__ import annotations

import argparse
import csv
import imghdr
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
    path: Path


def natural_key(path: Path) -> tuple[object, ...]:
    parts = re.split(r"(\d+)", path.stem.lower())
    key: list[object] = []
    for part in parts:
        if part.isdigit():
            key.append(int(part))
        elif part:
            key.append(part)
    key.append(path.suffix.lower())
    return tuple(key)


def is_valid_image(path: Path) -> bool:
    try:
        return imghdr.what(path) is not None
    except OSError:
        return False


def collect_images(class_dir: Path) -> list[Path]:
    if not class_dir.exists():
        raise FileNotFoundError(f"Folder kelas tidak ditemukan: {class_dir}")
    images = [
        path
        for path in class_dir.iterdir()
        if path.is_file() and path.suffix.lower() in IMAGE_EXTENSIONS
    ]
    valid_images = []
    invalid_images = []
    for path in sorted(images, key=natural_key):
        if is_valid_image(path):
            valid_images.append(path)
        else:
            invalid_images.append(path)

    if invalid_images:
        invalid_names = ", ".join(p.name for p in invalid_images)
        print(
            f"WARNING: Mengabaikan {len(invalid_images)} file tidak valid di {class_dir.name}: {invalid_names}"
        )

    return valid_images


def build_split(
    dataset_dir: Path,
    class_dirs: Sequence[str],
    train_count: int,
    val_count: int,
    test_count: int,
    strict_test_count: bool,
) -> tuple[list[SplitItem], list[dict[str, object]]]:
    split_items: list[SplitItem] = []
    summary: list[dict[str, object]] = []

    for class_index, class_name in enumerate(class_dirs):
        images = collect_images(dataset_dir / class_name)
        minimum_needed = train_count + val_count
        if len(images) < minimum_needed:
            raise ValueError(
                f"Kelas {class_name} hanya punya {len(images)} gambar; "
                f"butuh minimal {minimum_needed} untuk train+validation."
            )

        train_images = images[:train_count]
        val_images = images[train_count : train_count + val_count]
        remaining_images = images[train_count + val_count :]
        test_images = remaining_images[-test_count:] if len(remaining_images) >= test_count else remaining_images
        unused_images = remaining_images[: max(0, len(remaining_images) - len(test_images))]

        if strict_test_count and len(test_images) < test_count:
            raise ValueError(
                f"Kelas {class_name} hanya punya {len(test_images)} gambar test tanpa overlap; "
                f"butuh {test_count}."
            )

        for split_name, paths in (
            ("train", train_images),
            ("validation", val_images),
            ("test", test_images),
        ):
            split_items.extend(
                SplitItem(split_name, class_index, class_name, path) for path in paths
            )

        summary.append(
            {
                "class_name": class_name,
                "total_images": len(images),
                "train": len(train_images),
                "validation": len(val_images),
                "test": len(test_images),
                "unused": len(unused_images),
                "warning": (
                    f"test set kurang dari {test_count} karena total gambar kurang dari "
                    f"{train_count + val_count + test_count}"
                    if len(test_images) < test_count
                    else ""
                ),
            }
        )

    return split_items, summary


def build_split_custom(
    dataset_dir: Path,
    class_dirs: Sequence[str],
    train_start: int,
    train_end: int,
    val_count: int,
    test_count: int,
    strict_test_count: bool,
) -> tuple[list[SplitItem], list[dict[str, object]]]:
    split_items: list[SplitItem] = []
    summary: list[dict[str, object]] = []

    for class_index, class_name in enumerate(class_dirs):
        images = collect_images(dataset_dir / class_name)
        if len(images) < val_count + test_count:
            raise ValueError(
                f"Kelas {class_name} hanya punya {len(images)} gambar; "
                f"butuh minimal {val_count + test_count} untuk validation+test."
            )

        val_images = images[:val_count]
        test_images = images[val_count : val_count + test_count]

        if train_start <= val_count + test_count:
            raise ValueError(
                "train_start harus berada setelah validation dan test, "
                "agar tidak terjadi overlap antara split."
            )

        train_start_idx = train_start - 1
        train_end_idx = min(train_end, len(images))
        train_images = images[train_start_idx:train_end_idx]

        if strict_test_count and len(test_images) < test_count:
            raise ValueError(
                f"Kelas {class_name} hanya punya {len(test_images)} gambar test tanpa overlap; "
                f"butuh {test_count}."
            )

        used_indices = set(range(0, val_count)) | set(range(val_count, val_count + len(test_images))) | set(range(train_start_idx, train_end_idx))
        unused_images = [image for index, image in enumerate(images) if index not in used_indices]

        for split_name, paths in (
            ("train", train_images),
            ("validation", val_images),
            ("test", test_images),
        ):
            split_items.extend(
                SplitItem(split_name, class_index, class_name, path) for path in paths
            )

        summary.append(
            {
                "class_name": class_name,
                "total_images": len(images),
                "train": len(train_images),
                "validation": len(val_images),
                "test": len(test_images),
                "unused": len(unused_images),
                "warning": (
                    f"test set kurang dari {test_count} karena total gambar kurang dari "
                    f"{val_count + test_count + train_end - train_start + 1}"
                    if len(test_images) < test_count
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
            fieldnames=("split", "class_index", "class_name", "path"),
        )
        writer.writeheader()
        for item in split_items:
            writer.writerow(
                {
                    "split": item.split,
                    "class_index": item.class_index,
                    "class_name": item.class_name,
                    "path": item.path.relative_to(root).as_posix(),
                }
            )


def write_json(payload: object, output_path: Path) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(payload, indent=2), encoding="utf-8")


def write_history(history: dict[str, list[float]], output_path: Path) -> None:
    metric_names = list(history.keys())
    rows = max((len(values) for values in history.values()), default=0)
    with output_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["epoch", *metric_names])
        writer.writeheader()
        for index in range(rows):
            row = {"epoch": index + 1}
            for metric_name in metric_names:
                values = history[metric_name]
                row[metric_name] = values[index] if index < len(values) else ""
            writer.writerow(row)


def merge_history(*histories: dict[str, list[float]]) -> dict[str, list[float]]:
    merged: dict[str, list[float]] = {}
    for history in histories:
        for key, values in history.items():
            merged.setdefault(key, []).extend(values)
    return merged


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


def get_sparse_categorical_loss(tf, label_smoothing: float):
    try:
        return tf.keras.losses.SparseCategoricalCrossentropy(label_smoothing=label_smoothing)
    except TypeError:
        if label_smoothing != 0.0:
            print(
                "WARNING: label_smoothing is not supported by the installed TensorFlow version. "
                "Falling back to SparseCategoricalCrossentropy without label smoothing."
            )
        return tf.keras.losses.SparseCategoricalCrossentropy()


def build_model(
    tf,
    image_size: int,
    num_classes: int,
    weights: str | None,
    dropout: float,
    learning_rate: float,
    dense_units: int,
    label_smoothing: float,
    weight_decay: float,
):
    inputs = tf.keras.Input(shape=(image_size, image_size, 3), name="image")
    x = tf.keras.Sequential(
        [
            tf.keras.layers.RandomFlip("horizontal"),
            tf.keras.layers.RandomRotation(0.12),
            tf.keras.layers.RandomZoom(0.14),
            tf.keras.layers.RandomTranslation(0.08, 0.08),
            tf.keras.layers.RandomContrast(0.12),
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
    x = tf.keras.layers.BatchNormalization(name="bn_pool")(x)
    x = tf.keras.layers.Dropout(dropout, name="dropout")(x)
    x = tf.keras.layers.Dense(
        dense_units,
        activation="relu",
        kernel_regularizer=tf.keras.regularizers.l2(1e-4),
        name="dense",
    )(x)
    x = tf.keras.layers.BatchNormalization(name="bn_dense")(x)
    x = tf.keras.layers.Dropout(dropout * 0.5, name="dropout_2")(x)
    outputs = tf.keras.layers.Dense(num_classes, activation="softmax", name="predictions")(x)
    model = tf.keras.Model(inputs, outputs, name="batik_mobilenetv2")

    if weight_decay > 0 and hasattr(tf.keras.optimizers, "AdamW"):
        optimizer = tf.keras.optimizers.AdamW(
            learning_rate=learning_rate,
            weight_decay=weight_decay,
        )
    else:
        optimizer = tf.keras.optimizers.Adam(learning_rate=learning_rate)

    model.compile(
        optimizer=optimizer,
        loss=get_sparse_categorical_loss(tf, label_smoothing),
        metrics=["accuracy"],
    )
    return model, base_model


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
        "--split-strategy",
        choices=("default", "custom"),
        default="default",
        help="Pilih strategi split dataset: default atau custom.",
    )
    parser.add_argument(
        "--train-start",
        type=int,
        default=21,
        help="Mulai index gambar untuk train split (1-based, hanya untuk strategi custom).",
    )
    parser.add_argument(
        "--train-end",
        type=int,
        default=50,
        help="Akhir index gambar untuk train split (1-based, hanya untuk strategi custom).",
    )
    parser.add_argument("--strict-test-count", action="store_true")
    parser.add_argument("--split-only", action="store_true")
    parser.add_argument("--fine-tune", action="store_true")
    parser.add_argument(
        "--fine-tune-layers",
        type=int,
        default=30,
        help="Jumlah layer top MobileNetV2 yang di-unfreeze untuk fine tuning.",
    )
    parser.add_argument(
        "--fine-tune-epochs",
        type=int,
        default=8,
        help="Epoch tambahan untuk fine-tuning setelah pelatihan awal.",
    )
    parser.add_argument(
        "--fine-tune-learning-rate",
        type=float,
        default=1e-5,
        help="Learning rate untuk fase fine tuning.",
    )
    parser.add_argument("--dense-units", type=int, default=128)
    parser.add_argument("--label-smoothing", type=float, default=0.0)
    parser.add_argument(
        "--weight-decay",
        type=float,
        default=0.0,
        help="Optional weight decay for the optimizer if AdamW is available.",
    )
    parser.add_argument("--image-size", type=int, default=224)
    parser.add_argument("--batch-size", type=int, default=16)
    parser.add_argument("--epochs", type=int, default=12)
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

    if args.split_strategy == "custom":
        split_items, summary = build_split_custom(
            dataset_dir=dataset_dir,
            class_dirs=args.class_dirs,
            train_start=args.train_start,
            train_end=args.train_end,
            val_count=args.val_count,
            test_count=args.test_count,
            strict_test_count=args.strict_test_count,
        )
    else:
        split_items, summary = build_split(
            dataset_dir=dataset_dir,
            class_dirs=args.class_dirs,
            train_count=args.train_count,
            val_count=args.val_count,
            test_count=args.test_count,
            strict_test_count=args.strict_test_count,
        )

    write_manifest(split_items, output_dir / "split_manifest.csv", root)
    write_json(summary, output_dir / "split_summary.json")
    write_json(list(args.class_dirs), output_dir / "class_names.json")

    print("Split dataset:")
    for item in summary:
        warning = f" | WARNING: {item['warning']}" if item["warning"] else ""
        print(
            f"- {item['class_name']}: train={item['train']}, "
            f"validation={item['validation']}, test={item['test']}, unused={item['unused']}{warning}"
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

    model, base_model = build_model(
        tf=tf,
        image_size=args.image_size,
        num_classes=len(args.class_dirs),
        weights=None if args.weights == "none" else args.weights,
        dropout=args.dropout,
        learning_rate=args.learning_rate,
        dense_units=args.dense_units,
        label_smoothing=args.label_smoothing,
        weight_decay=args.weight_decay,
    )

    checkpoint_path = output_dir / "batik_mobilenetv2_best.keras"
    callbacks = [
        tf.keras.callbacks.ModelCheckpoint(
            filepath=str(checkpoint_path),
            monitor="val_accuracy",
            mode="max",
            save_best_only=True,
        ),
        tf.keras.callbacks.EarlyStopping(
            monitor="val_accuracy",
            mode="max",
            patience=args.patience,
            restore_best_weights=True,
        ),
    ]

    history1 = model.fit(
        train_ds,
        validation_data=val_ds,
        epochs=args.epochs,
        callbacks=callbacks,
    )

    if args.fine_tune:
        base_model.trainable = True
        if args.fine_tune_layers is not None:
            for layer in base_model.layers[:-args.fine_tune_layers]:
                layer.trainable = False
        model.compile(
            optimizer=tf.keras.optimizers.Adam(learning_rate=args.fine_tune_learning_rate),
            loss=get_sparse_categorical_loss(tf, args.label_smoothing),
            metrics=["accuracy"],
        )

        fine_tune_callbacks = [
            tf.keras.callbacks.ModelCheckpoint(
                filepath=str(checkpoint_path),
                monitor="val_accuracy",
                mode="max",
                save_best_only=True,
            ),
            tf.keras.callbacks.EarlyStopping(
                monitor="val_accuracy",
                mode="max",
                patience=args.patience,
                restore_best_weights=True,
            ),
            tf.keras.callbacks.ReduceLROnPlateau(
                monitor="val_loss",
                factor=0.5,
                patience=2,
                verbose=1,
                min_lr=1e-7,
            ),
        ]

        history2 = model.fit(
            train_ds,
            validation_data=val_ds,
            epochs=args.fine_tune_epochs,
            callbacks=fine_tune_callbacks,
        )
        history = merge_history(history1.history, history2.history)
    else:
        history = history1.history

    final_model_path = output_dir / "batik_mobilenetv2_final.keras"
    model.save(final_model_path)
    write_history(history, output_dir / "training_history.csv")

    metrics = model.evaluate(test_ds, return_dict=True)
    write_json(metrics, output_dir / "test_metrics.json")

    print(f"Model terbaik: {checkpoint_path}")
    print(f"Model final: {final_model_path}")
    print(f"Test metrics: {metrics}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
