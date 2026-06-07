from __future__ import annotations

import argparse
import csv
import json
import sys
from copy import deepcopy
from pathlib import Path


CLASS_DIRS = [
    ("batik-bali", "batik_bali"),
    ("batik-megamendung", "megamendung"),
    ("batik-parang", "parang"),
    ("batik-kawung", "kawung"),
]

IMAGE_EXTENSIONS = (".jpg", ".jpeg", ".png", ".webp")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Train batik image recognition with MobileNetV2."
    )
    parser.add_argument("--dataset-dir", default="dataset", type=Path)
    parser.add_argument("--output-dir", default="outputs", type=Path)
    parser.add_argument("--image-size", default=224, type=int)
    parser.add_argument("--batch-size", default=8, type=int)
    parser.add_argument("--epochs", default=15, type=int)
    parser.add_argument("--fine-tune-epochs", default=5, type=int)
    parser.add_argument("--fine-tune-layers", default=20, type=int)
    parser.add_argument("--learning-rate", default=1e-3, type=float)
    parser.add_argument("--fine-tune-learning-rate", default=1e-5, type=float)
    parser.add_argument("--weight-decay", default=1e-4, type=float)
    parser.add_argument("--dropout", default=0.3, type=float)
    parser.add_argument("--seed", default=42, type=int)
    parser.add_argument("--weights", choices=("imagenet", "none"), default="imagenet")
    parser.add_argument("--num-workers", default=0, type=int)
    parser.add_argument("--test-start", default=1, type=int)
    parser.add_argument("--test-end", default=10, type=int)
    parser.add_argument("--train-start", default=11, type=int)
    parser.add_argument("--train-end", default=40, type=int)
    parser.add_argument("--val-start", default=41, type=int)
    parser.add_argument("--val-end", default=50, type=int)
    parser.add_argument(
        "--allow-overlap",
        action="store_true",
        help="Allow the same image path to appear in more than one split.",
    )
    parser.add_argument(
        "--unfreeze-backbone",
        action="store_true",
        help="Train the full MobileNetV2 backbone from the first epoch.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Only print split counts and missing images. No files are written.",
    )
    return parser.parse_args()


def image_range(start: int, end: int) -> range:
    if start > end:
        raise ValueError(f"Invalid range: {start} is greater than {end}.")
    return range(start, end + 1)


def find_image(class_dir: Path, image_number: int) -> Path | None:
    for suffix in IMAGE_EXTENSIONS:
        candidate = class_dir / f"{image_number}{suffix}"
        if candidate.exists():
            return candidate

    for item in class_dir.iterdir():
        if (
            item.is_file()
            and item.stem == str(image_number)
            and item.suffix.lower() in IMAGE_EXTENSIONS
        ):
            return item
    return None


def validate_image_file(image_path: Path) -> str | None:
    try:
        from PIL import Image
    except ModuleNotFoundError:
        return None

    try:
        with Image.open(image_path) as image:
            image.verify()
    except Exception as exc:
        return str(exc)
    return None


def build_split_records(args: argparse.Namespace) -> tuple[list[dict], list[dict], list[dict], list[dict]]:
    dataset_dir = args.dataset_dir
    split_ranges = {
        "test": image_range(args.test_start, args.test_end),
        "train": image_range(args.train_start, args.train_end),
        "val": image_range(args.val_start, args.val_end),
    }

    records: list[dict] = []
    missing: list[dict] = []
    invalid: list[dict] = []
    duplicates: list[dict] = []
    seen_paths: dict[str, str] = {}

    for split_name, numbers in split_ranges.items():
        for label, (folder_name, class_name) in enumerate(CLASS_DIRS):
            class_dir = dataset_dir / folder_name
            if not class_dir.exists():
                raise FileNotFoundError(f"Class folder not found: {class_dir}")

            for image_number in numbers:
                image_path = find_image(class_dir, image_number)
                if image_path is None:
                    missing.append(
                        {
                            "split": split_name,
                            "class_name": class_name,
                            "folder": folder_name,
                            "image_number": image_number,
                        }
                    )
                    continue

                invalid_reason = validate_image_file(image_path)
                if invalid_reason:
                    invalid.append(
                        {
                            "split": split_name,
                            "class_name": class_name,
                            "folder": folder_name,
                            "image_number": image_number,
                            "path": str(image_path),
                            "error": invalid_reason,
                        }
                    )
                    continue

                resolved = str(image_path.resolve()).lower()
                if resolved in seen_paths:
                    duplicates.append(
                        {
                            "path": str(image_path),
                            "class_name": class_name,
                            "image_number": image_number,
                            "first_split": seen_paths[resolved],
                            "second_split": split_name,
                        }
                    )
                seen_paths[resolved] = split_name

                records.append(
                    {
                        "split": split_name,
                        "label": label,
                        "class_name": class_name,
                        "folder": folder_name,
                        "image_number": image_number,
                        "path": str(image_path),
                    }
                )

    if duplicates and not args.allow_overlap:
        duplicate_lines = "\n".join(
            f"- {item['path']} in {item['first_split']} and {item['second_split']}"
            for item in duplicates
        )
        raise ValueError(
            "Duplicate images found across splits. Use --allow-overlap only if this "
            f"is intentional.\n{duplicate_lines}"
        )

    return records, missing, duplicates, invalid


def split_counts(records: list[dict]) -> dict[str, dict[str, int]]:
    counts = {
        split: {class_name: 0 for _, class_name in CLASS_DIRS}
        for split in ("train", "val", "test")
    }
    for record in records:
        counts[record["split"]][record["class_name"]] += 1
    return counts


def print_split_summary(
    records: list[dict],
    missing: list[dict],
    duplicates: list[dict],
    invalid: list[dict],
) -> None:
    counts = split_counts(records)
    print("Split counts:")
    for split_name in ("train", "val", "test"):
        total = sum(counts[split_name].values())
        class_counts = ", ".join(
            f"{class_name}={count}"
            for class_name, count in counts[split_name].items()
        )
        print(f"- {split_name}: {total} ({class_counts})")

    if missing:
        print("\nMissing images:")
        for item in missing:
            print(
                f"- {item['split']}: {item['folder']}/{item['image_number']}.jpg"
            )
    else:
        print("\nMissing images: none")

    if invalid:
        print("\nInvalid images:")
        for item in invalid:
            print(f"- {item['split']}: {item['path']} ({item['error']})")
    else:
        print("\nInvalid images: none")

    if duplicates:
        print("\nDuplicate images across splits:")
        for item in duplicates:
            print(
                f"- {item['path']} in {item['first_split']} and {item['second_split']}"
            )


def write_split_files(
    output_dir: Path,
    records: list[dict],
    missing: list[dict],
    duplicates: list[dict],
    invalid: list[dict],
) -> None:
    output_dir.mkdir(parents=True, exist_ok=True)

    manifest_path = output_dir / "split_manifest.csv"
    with manifest_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=("split", "label", "class_name", "folder", "image_number", "path"),
        )
        writer.writeheader()
        writer.writerows(records)

    missing_path = output_dir / "missing_images.csv"
    with missing_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=("split", "class_name", "folder", "image_number"),
        )
        writer.writeheader()
        writer.writerows(missing)

    invalid_path = output_dir / "invalid_images.csv"
    with invalid_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=("split", "class_name", "folder", "image_number", "path", "error"),
        )
        writer.writeheader()
        writer.writerows(invalid)

    class_indices = {class_name: index for index, (_, class_name) in enumerate(CLASS_DIRS)}
    (output_dir / "class_indices.json").write_text(
        json.dumps(class_indices, indent=2), encoding="utf-8"
    )

    split_summary = {
        "counts": split_counts(records),
        "missing_images": missing,
        "invalid_images": invalid,
        "duplicates": duplicates,
    }
    (output_dir / "split_summary.json").write_text(
        json.dumps(split_summary, indent=2), encoding="utf-8"
    )


def import_torch_stack():
    try:
        import torch
        from PIL import Image
        from torch import nn
        from torch.utils.data import DataLoader, Dataset
        from torchvision import models, transforms
    except ModuleNotFoundError as exc:
        raise SystemExit(
            "PyTorch dependencies are not installed. Run: "
            r".\.venv\Scripts\python.exe -m pip install -r requirements.txt"
        ) from exc

    return torch, Image, nn, DataLoader, Dataset, models, transforms


def make_dataset_class(Dataset, Image):
    class BatikDataset(Dataset):
        def __init__(self, records: list[dict], split_name: str, transform):
            self.records = [record for record in records if record["split"] == split_name]
            if not self.records:
                raise ValueError(f"No images found for split: {split_name}")
            self.transform = transform

        def __len__(self) -> int:
            return len(self.records)

        def __getitem__(self, index: int):
            record = self.records[index]
            image = Image.open(record["path"]).convert("RGB")
            if self.transform is not None:
                image = self.transform(image)
            return image, record["label"]

    return BatikDataset


def build_transforms(transforms, image_size: int):
    imagenet_mean = [0.485, 0.456, 0.406]
    imagenet_std = [0.229, 0.224, 0.225]

    train_transform = transforms.Compose(
        [
            transforms.Resize((image_size, image_size)),
            transforms.RandomHorizontalFlip(),
            transforms.RandomRotation(8),
            transforms.ColorJitter(brightness=0.08, contrast=0.12, saturation=0.08),
            transforms.ToTensor(),
            transforms.Normalize(mean=imagenet_mean, std=imagenet_std),
        ]
    )
    eval_transform = transforms.Compose(
        [
            transforms.Resize((image_size, image_size)),
            transforms.ToTensor(),
            transforms.Normalize(mean=imagenet_mean, std=imagenet_std),
        ]
    )
    return train_transform, eval_transform


def build_dataloaders(torch, DataLoader, BatikDataset, records: list[dict], transforms_pair, args):
    generator = torch.Generator().manual_seed(args.seed)
    train_transform, eval_transform = transforms_pair

    train_dataset = BatikDataset(records, "train", train_transform)
    val_dataset = BatikDataset(records, "val", eval_transform)
    test_dataset = BatikDataset(records, "test", eval_transform)

    train_loader = DataLoader(
        train_dataset,
        batch_size=args.batch_size,
        shuffle=True,
        num_workers=args.num_workers,
        generator=generator,
    )
    val_loader = DataLoader(
        val_dataset,
        batch_size=args.batch_size,
        shuffle=False,
        num_workers=args.num_workers,
    )
    test_loader = DataLoader(
        test_dataset,
        batch_size=args.batch_size,
        shuffle=False,
        num_workers=args.num_workers,
    )
    return train_loader, val_loader, test_loader, test_dataset.records


def build_model(models, nn, args: argparse.Namespace):
    weights = None
    if args.weights == "imagenet":
        weights = models.MobileNet_V2_Weights.DEFAULT

    model = models.mobilenet_v2(weights=weights)
    in_features = model.classifier[1].in_features
    model.classifier = nn.Sequential(
        nn.Dropout(p=args.dropout),
        nn.Linear(in_features, len(CLASS_DIRS)),
    )

    if not args.unfreeze_backbone:
        for parameter in model.features.parameters():
            parameter.requires_grad = False

    return model


def trainable_parameters(model):
    return [parameter for parameter in model.parameters() if parameter.requires_grad]


def run_epoch(torch, model, loader, criterion, device, optimizer=None) -> dict[str, float]:
    training = optimizer is not None
    model.train(training)

    total_loss = 0.0
    total_correct = 0
    total_count = 0

    for images, labels in loader:
        images = images.to(device)
        labels = labels.to(device)

        with torch.set_grad_enabled(training):
            outputs = model(images)
            loss = criterion(outputs, labels)

            if training:
                optimizer.zero_grad()
                loss.backward()
                optimizer.step()

        batch_size = labels.size(0)
        total_loss += loss.item() * batch_size
        total_correct += (outputs.argmax(dim=1) == labels).sum().item()
        total_count += batch_size

    return {
        "loss": total_loss / total_count,
        "accuracy": total_correct / total_count,
    }


def fit_stage(
    torch,
    model,
    train_loader,
    val_loader,
    criterion,
    device,
    output_dir: Path,
    history: list[dict],
    stage: str,
    epochs: int,
    image_size: int,
    learning_rate: float,
    weight_decay: float,
) -> dict:
    if epochs <= 0:
        return {
            "best_accuracy": None,
            "best_state": deepcopy(model.state_dict()),
        }

    optimizer = torch.optim.Adam(
        trainable_parameters(model),
        lr=learning_rate,
        weight_decay=weight_decay,
    )
    scheduler = torch.optim.lr_scheduler.ReduceLROnPlateau(
        optimizer, mode="max", patience=3, factor=0.2
    )

    best_accuracy = -1.0
    best_state = deepcopy(model.state_dict())

    for epoch in range(1, epochs + 1):
        train_metrics = run_epoch(torch, model, train_loader, criterion, device, optimizer)
        val_metrics = run_epoch(torch, model, val_loader, criterion, device)
        scheduler.step(val_metrics["accuracy"])

        current_lr = optimizer.param_groups[0]["lr"]
        row = {
            "stage": stage,
            "epoch": epoch,
            "train_loss": train_metrics["loss"],
            "train_accuracy": train_metrics["accuracy"],
            "val_loss": val_metrics["loss"],
            "val_accuracy": val_metrics["accuracy"],
            "learning_rate": current_lr,
        }
        history.append(row)

        print(
            f"{stage} epoch {epoch}/{epochs} - "
            f"loss={train_metrics['loss']:.4f}, "
            f"acc={train_metrics['accuracy']:.4f}, "
            f"val_loss={val_metrics['loss']:.4f}, "
            f"val_acc={val_metrics['accuracy']:.4f}"
        )

        if val_metrics["accuracy"] > best_accuracy:
            best_accuracy = val_metrics["accuracy"]
            best_state = deepcopy(model.state_dict())
            torch.save(
                {
                    "architecture": "mobilenet_v2",
                    "backend": "torchvision",
                    "class_names": [class_name for _, class_name in CLASS_DIRS],
                    "class_indices": {
                        class_name: index
                        for index, (_, class_name) in enumerate(CLASS_DIRS)
                    },
                    "image_size": image_size,
                    "model_state_dict": best_state,
                    "stage": stage,
                    "val_accuracy": best_accuracy,
                },
                output_dir / "best_model.pt",
            )

    model.load_state_dict(best_state)
    return {
        "best_accuracy": best_accuracy,
        "best_state": best_state,
    }


def unfreeze_last_layers(model, fine_tune_layers: int) -> None:
    for parameter in model.features.parameters():
        parameter.requires_grad = False

    feature_layers = list(model.features.children())
    for layer in feature_layers[-fine_tune_layers:]:
        for parameter in layer.parameters():
            parameter.requires_grad = True


def write_history(output_dir: Path, history: list[dict]) -> None:
    history_path = output_dir / "training_history.csv"
    fieldnames = (
        "stage",
        "epoch",
        "train_loss",
        "train_accuracy",
        "val_loss",
        "val_accuracy",
        "learning_rate",
    )
    with history_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(history)


def evaluate(torch, model, test_loader, test_records: list[dict], criterion, device, output_dir: Path):
    model.eval()
    class_names = [class_name for _, class_name in CLASS_DIRS]
    confusion = torch.zeros(len(CLASS_DIRS), len(CLASS_DIRS), dtype=torch.int64)
    predictions = []
    total_loss = 0.0
    total_count = 0
    record_index = 0

    with torch.no_grad():
        for images, labels in test_loader:
            images = images.to(device)
            labels = labels.to(device)
            outputs = model(images)
            loss = criterion(outputs, labels)
            probabilities = torch.softmax(outputs, dim=1)
            predicted_labels = outputs.argmax(dim=1)

            batch_size = labels.size(0)
            total_loss += loss.item() * batch_size
            total_count += batch_size

            for true_label, predicted_label in zip(labels.cpu(), predicted_labels.cpu()):
                confusion[int(true_label), int(predicted_label)] += 1

            for row, predicted_label in zip(probabilities.cpu(), predicted_labels.cpu()):
                record = test_records[record_index]
                predictions.append(
                    {
                        "path": record["path"],
                        "image_number": record["image_number"],
                        "true_label": record["class_name"],
                        "predicted_label": class_names[int(predicted_label)],
                        "confidence": float(row[int(predicted_label)]),
                    }
                )
                record_index += 1

    prediction_path = output_dir / "test_predictions.csv"
    with prediction_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=(
                "path",
                "image_number",
                "true_label",
                "predicted_label",
                "confidence",
            ),
        )
        writer.writeheader()
        writer.writerows(predictions)

    per_class = {}
    for index, class_name in enumerate(class_names):
        total = int(confusion[index].sum().item())
        correct = int(confusion[index][index].item())
        per_class[class_name] = {
            "total": total,
            "correct": correct,
            "accuracy": correct / total if total else None,
        }

    accuracy = sum(item["correct"] for item in per_class.values()) / total_count
    return {
        "test_loss": total_loss / total_count,
        "test_accuracy": accuracy,
        "confusion_matrix": confusion.tolist(),
        "per_class": per_class,
    }


def save_model(torch, model, args: argparse.Namespace, output_dir: Path, metrics: dict) -> Path:
    model_path = output_dir / "batik_mobilenetv2.pt"
    torch.save(
        {
            "architecture": "mobilenet_v2",
            "backend": "torchvision",
            "class_names": [class_name for _, class_name in CLASS_DIRS],
            "class_indices": {
                class_name: index for index, (_, class_name) in enumerate(CLASS_DIRS)
            },
            "image_size": args.image_size,
            "model_state_dict": model.state_dict(),
            "metrics": metrics,
        },
        model_path,
    )
    return model_path


def train(
    args: argparse.Namespace,
    records: list[dict],
    missing: list[dict],
    duplicates: list[dict],
    invalid: list[dict],
):
    torch, Image, nn, DataLoader, Dataset, models, transforms = import_torch_stack()
    torch.manual_seed(args.seed)

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"Using device: {device}")

    output_dir = args.output_dir
    write_split_files(output_dir, records, missing, duplicates, invalid)

    BatikDataset = make_dataset_class(Dataset, Image)
    transforms_pair = build_transforms(transforms, args.image_size)
    train_loader, val_loader, test_loader, test_records = build_dataloaders(
        torch, DataLoader, BatikDataset, records, transforms_pair, args
    )

    model = build_model(models, nn, args).to(device)
    criterion = nn.CrossEntropyLoss()
    history: list[dict] = []

    fit_stage(
        torch,
        model,
        train_loader,
        val_loader,
        criterion,
        device,
        output_dir,
        history,
        "classifier",
        args.epochs,
        args.image_size,
        args.learning_rate,
        args.weight_decay,
    )

    if args.fine_tune_epochs > 0:
        unfreeze_last_layers(model, args.fine_tune_layers)
        fit_stage(
            torch,
            model,
            train_loader,
            val_loader,
            criterion,
            device,
            output_dir,
            history,
            "fine_tune",
            args.fine_tune_epochs,
            args.image_size,
            args.fine_tune_learning_rate,
            args.weight_decay,
        )

    write_history(output_dir, history)
    metrics = evaluate(torch, model, test_loader, test_records, criterion, device, output_dir)
    metrics.update(
        {
            "counts": split_counts(records),
            "missing_images": missing,
            "invalid_images": invalid,
            "duplicates": duplicates,
        }
    )
    (output_dir / "metrics.json").write_text(
        json.dumps(metrics, indent=2), encoding="utf-8"
    )

    model_path = save_model(torch, model, args, output_dir, metrics)
    print(f"\nSaved model: {model_path}")
    print(f"Test accuracy: {metrics['test_accuracy']:.4f}")
    print(f"Test loss: {metrics['test_loss']:.4f}")


def main() -> int:
    args = parse_args()

    try:
        records, missing, duplicates, invalid = build_split_records(args)
        print_split_summary(records, missing, duplicates, invalid)

        if args.dry_run:
            return 0

        train(args, records, missing, duplicates, invalid)
    except Exception as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
