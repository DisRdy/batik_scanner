# MobileNetV2 Batik Classifier

Pipeline ini melatih model klasifikasi gambar batik untuk empat kelas:

- `batik-bali`
- `batik-megamendung`
- `batik-parang`
- `batik-kawung`

Split dibuat dari urutan natural filename di setiap folder kelas:

- 30 gambar pertama untuk training
- 10 gambar berikutnya untuk validation
- sampai 10 gambar terakhir yang tersisa untuk test, tanpa overlap

Catatan dataset saat ini:

- `batik-bali`: 50 gambar, test 10
- `batik-megamendung`: 47 gambar, test 7
- `batik-parang`: 50 gambar, test 10
- `batik-kawung`: 45 gambar, test 5

## Setup

```powershell
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

## Cek Split Dataset

```powershell
.\.venv\Scripts\python.exe train_mobilenetv2.py --split-only
```

Output split disimpan ke:

- `artifacts/split_manifest.csv`
- `artifacts/split_summary.json`
- `artifacts/class_names.json`

## Training Model

```powershell
.\.venv\Scripts\python.exe train_mobilenetv2.py --epochs 12
```

Untuk split custom dengan train 21-50 dan fine tuning:

```powershell
.\.venv\Scripts\python.exe train_mobilenetv2.py --split-strategy custom --train-start 21 --train-end 50 --val-count 10 --test-count 10 --epochs 30 --fine-tune --fine-tune-epochs 20 --fine-tune-layers 100 --batch-size 4 --learning-rate 0.0001 --fine-tune-learning-rate 1e-5 --dropout 0.4
```

Hasil training disimpan ke folder `artifacts`:

- `batik_mobilenetv2_best.keras`
- `batik_mobilenetv2_final.keras`
- `training_history.csv`
- `test_metrics.json`

Jika tidak ingin download pretrained ImageNet weights:

```powershell
.\.venv\Scripts\python.exe train_mobilenetv2.py --weights none
```
