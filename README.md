# Batik Scanner - Klasifikasi Motif Batik dengan MobileNetV2

Proyek ini adalah sistem **image recognition** untuk mengenali motif batik dari gambar. Model yang digunakan adalah **MobileNetV2** dengan pendekatan **transfer learning** untuk mengklasifikasikan gambar ke dalam 4 kategori:

- `batik-bali`
- `batik-megamendung`
- `batik-parang`
- `batik-kawung`

Proyek ini dirancang agar pipeline dapat dijalankan ulang secara jelas, mulai dari validasi dataset, pembagian data, training model, fine-tuning, evaluasi test set, sampai penyimpanan model dan laporan evaluasi.

## Ringkasan Sistem

Alur kerja sistem:

1. Membaca gambar dari folder `dataset`.
2. Memvalidasi file gambar dari header file agar file rusak atau bukan gambar tidak ikut diproses.
3. Mengurutkan file gambar secara natural dan deterministik.
4. Membagi dataset menjadi training, validation, dan test set.
5. Melakukan preprocessing gambar ke ukuran `224x224` pixel.
6. Melatih model MobileNetV2 dengan transfer learning.
7. Melakukan fine-tuning pada layer akhir MobileNetV2.
8. Mengevaluasi model dengan test set.
9. Menyimpan model, metrics, classification report, dan confusion matrix ke folder `artifacts`.

## Model yang Digunakan

Model utama yang digunakan adalah **MobileNetV2** dari TensorFlow Keras.

MobileNetV2 dipilih karena:

- ringan dan efisien untuk image classification,
- cocok untuk transfer learning,
- dapat memakai pretrained weights dari ImageNet,
- lebih hemat resource dibanding arsitektur CNN besar,
- cocok untuk dataset yang jumlah gambarnya masih terbatas.

Arsitektur model pada script:

```text
Input image 224x224x3
-> Data augmentation
-> MobileNetV2 include_top=False
-> GlobalAveragePooling2D
-> Dropout
-> Dense softmax 4 kelas
```

MobileNetV2 digunakan sebagai feature extractor. Classifier head di bagian akhir digunakan untuk memetakan fitur gambar ke 4 kelas batik.

## Struktur Folder

```text
batik_scanner/
|-- dataset/
|   |-- batik-bali/
|   |-- batik-megamendung/
|   |-- batik-parang/
|   `-- batik-kawung/
|-- artifacts/
|   |-- batik_mobilenetv2_best.keras
|   |-- batik_mobilenetv2_final.keras
|   |-- batik_mobilenetv2_finetuned_best.keras
|   |-- batik_mobilenetv2_finetuned_final.keras
|   |-- class_names.json
|   |-- split_manifest.csv
|   |-- split_summary.json
|   |-- training_history.csv
|   |-- test_metrics.json
|   |-- classification_report.txt
|   `-- confusion_matrix.png
|-- train_mobilenetv2.py
|-- requirements.txt
|-- MOBILENETV2.md
`-- README.md
```

Keterangan:

- `dataset/`: folder dataset gambar batik per kelas.
- `train_mobilenetv2.py`: script utama untuk split dataset, training, fine-tuning, dan evaluasi.
- `requirements.txt`: dependency Python.
- `artifacts/`: output hasil split, model, metrics, dan laporan evaluasi.
- `MOBILENETV2.md`: catatan teknis tambahan untuk pipeline MobileNetV2.

## Dataset

Dataset disusun berdasarkan nama folder kelas:

| Class Index | Kelas | Folder |
| ---: | --- | --- |
| 0 | Batik Bali | `dataset/batik-bali` |
| 1 | Batik Megamendung | `dataset/batik-megamendung` |
| 2 | Batik Parang | `dataset/batik-parang` |
| 3 | Batik Kawung | `dataset/batik-kawung` |

## Dynamic Split Dataset

Script menggunakan dynamic split secara default. Artinya, jumlah data training, validation, dan test ditentukan berdasarkan jumlah gambar valid pada setiap kelas.

Aturan dynamic split:

| Tier | Syarat jumlah gambar valid | Train | Validation | Test |
| --- | ---: | ---: | ---: | ---: |
| `80+` | `>= 80` | 60 | 15 | maksimal 15 |
| `50+` | `>= 50` | 30 | 10 | maksimal 10 |
| `<50` | `< 50` | 30 | 10 | maksimal 10 |

Jika sisa gambar setelah train dan validation lebih sedikit dari target test, semua sisa gambar akan dipakai sebagai test set. Tidak ada gambar yang dipakai di lebih dari satu split.

Untuk menjalankan split dinamis:

```powershell
.\.venv\Scripts\python.exe train_mobilenetv2.py --split-only --dynamic-split
```

Untuk memakai split fixed lama berdasarkan `--train-count`, `--val-count`, dan `--test-count`:

```powershell
.\.venv\Scripts\python.exe train_mobilenetv2.py --split-only --no-dynamic-split
```

## Kondisi Dataset Saat Ini

Jumlah data aktual setelah validasi file gambar:

| Kelas | Tier | Total File | File Valid | Train | Validation | Test | Unused | Catatan |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `batik-bali` | `50+` | 50 | 50 | 30 | 10 | 10 | 0 | lengkap |
| `batik-megamendung` | `<50` | 47 | 46 | 30 | 10 | 6 | 0 | `49.jpg` bukan file gambar valid |
| `batik-parang` | `80+` | 94 | 94 | 60 | 15 | 15 | 4 | data lebih banyak |
| `batik-kawung` | `80+` | 88 | 88 | 60 | 15 | 13 | 0 | test 13 karena sisa data setelah train dan validation hanya 13 |

Catatan: file `dataset/batik-megamendung/49.jpg` memiliki ekstensi `.jpg`, tetapi isinya bukan gambar valid. Script otomatis melewati file ini.

## Instalasi

Gunakan virtual environment yang tersedia atau buat environment baru.

Install dependency:

```powershell
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

Dependency utama:

```text
tensorflow
scikit-learn
matplotlib
```

## Cara Menjalankan Split Dataset

Untuk membuat ulang manifest split tanpa training:

```powershell
.\.venv\Scripts\python.exe train_mobilenetv2.py --split-only --dynamic-split
```

Output:

- `artifacts/split_manifest.csv`: daftar gambar, split, class index, class name, tier, dan path.
- `artifacts/split_summary.json`: ringkasan jumlah data per kelas.
- `artifacts/class_names.json`: urutan nama kelas yang dipakai model.

## Cara Training Model

Training penuh dengan dynamic split:

```powershell
.\.venv\Scripts\python.exe train_mobilenetv2.py --epochs 15 --finetune-epochs 20 --patience 6 --dynamic-split
```

Command sederhana juga tetap bisa digunakan:

```powershell
.\.venv\Scripts\python.exe train_mobilenetv2.py --epochs 12
```

Secara default script akan:

- menggunakan image size `224`,
- menggunakan batch size `16`,
- menggunakan pretrained weights `imagenet`,
- memakai dynamic split,
- memakai data augmentation,
- menghitung class weights otomatis dari jumlah sample training aktual,
- menjalankan training phase 1,
- menjalankan fine-tuning phase 2 jika `--finetune-epochs > 0`,
- menyimpan model dan hasil evaluasi ke `artifacts`.

## Strategi Training Dua Fase

### Phase 1: Training Classifier Head

Pada phase 1:

- MobileNetV2 base dibekukan dengan `trainable = False`.
- Model hanya melatih classifier head.
- Learning rate default: `0.0003`.
- EarlyStopping memakai monitor `val_accuracy`.
- Model terbaik disimpan sebagai `batik_mobilenetv2_best.keras`.
- Model final phase 1 disimpan sebagai `batik_mobilenetv2_final.keras`.

### Phase 2: Fine-Tuning

Pada phase 2:

- 30 layer terakhir MobileNetV2 di-unfreeze.
- Learning rate diturunkan menjadi `learning_rate * 0.1`.
- Jumlah epoch tambahan diatur dengan `--finetune-epochs`.
- Model terbaik disimpan sebagai `batik_mobilenetv2_finetuned_best.keras`.
- Model final fine-tuned disimpan sebagai `batik_mobilenetv2_finetuned_final.keras`.

Phase 2 hanya berjalan jika `--finetune-epochs` lebih besar dari 0.

## Data Augmentation

Saat training, gambar diberi augmentasi:

- `RandomFlip("horizontal_and_vertical")`
- `RandomRotation(0.2)`
- `RandomZoom(0.2)`
- `RandomContrast(0.2)`
- `RandomBrightness(0.2)`

Augmentasi membantu model melihat variasi gambar yang lebih banyak dari dataset yang tersedia.

## Class Weights

Class weights dihitung otomatis menggunakan:

```python
from sklearn.utils.class_weight import compute_class_weight
```

Perhitungan dilakukan berdasarkan jumlah sample training aktual setelah dynamic split. Dengan dataset saat ini, jumlah training per kelas adalah:

```text
batik-bali        : 30
batik-megamendung : 30
batik-parang      : 60
batik-kawung      : 60
```

Karena jumlah training tidak sama, class weights membantu model agar kelas dengan data lebih sedikit tetap mendapat perhatian saat training.

## Callback Training

Callback yang digunakan:

- `ModelCheckpoint`: menyimpan model terbaik berdasarkan `val_accuracy`.
- `EarlyStopping`: menghentikan training jika validation accuracy tidak membaik.
- `ReduceLROnPlateau`: menurunkan learning rate jika `val_loss` stagnan.

Konfigurasi `ReduceLROnPlateau`:

```text
monitor = val_loss
factor = 0.5
patience = 2
min_lr = 1e-7
```

## Evaluasi Model

Evaluasi model yang sudah tersimpan:

```powershell
.\.venv\Scripts\python.exe train_mobilenetv2.py --evaluate-model artifacts\batik_mobilenetv2_finetuned_final.keras
```

Jika hanya ada model phase 1:

```powershell
.\.venv\Scripts\python.exe train_mobilenetv2.py --evaluate-model artifacts\batik_mobilenetv2_final.keras
```

Output evaluasi:

- `artifacts/test_metrics.json`: accuracy, loss, per-class accuracy, dan classification report dalam format JSON.
- `artifacts/classification_report.txt`: precision, recall, f1-score, dan support per kelas.
- `artifacts/confusion_matrix.png`: visualisasi confusion matrix.

Catatan: setelah dataset berubah, model lama sebaiknya dievaluasi ulang atau dilatih ulang agar metrics sesuai split terbaru.

## Parameter Penting

| Parameter | Fungsi | Default |
| --- | --- | --- |
| `--dataset-dir` | lokasi dataset | `dataset` |
| `--output-dir` | lokasi output | `artifacts` |
| `--dynamic-split` | memakai split dinamis | aktif |
| `--no-dynamic-split` | memakai split fixed lama | tidak aktif |
| `--train-count` | train count untuk fixed split | `30` |
| `--val-count` | validation count untuk fixed split | `10` |
| `--test-count` | test count untuk fixed split | `10` |
| `--image-size` | ukuran input gambar | `224` |
| `--batch-size` | batch size | `16` |
| `--epochs` | epoch phase 1 | `12` |
| `--finetune-epochs` | epoch phase 2 | `10` |
| `--patience` | patience EarlyStopping | `4` |
| `--dropout` | dropout classifier head | `0.25` |
| `--learning-rate` | learning rate phase 1 | `0.0003` |
| `--weights` | pretrained weights | `imagenet` |

## Contoh Prediksi Satu Gambar

```python
import json
import numpy as np
import tensorflow as tf

model = tf.keras.models.load_model("artifacts/batik_mobilenetv2_finetuned_final.keras")
class_names = json.loads(open("artifacts/class_names.json", encoding="utf-8").read())

image_path = "dataset/batik-bali/41.jpg"
image = tf.io.read_file(image_path)
image = tf.image.decode_image(image, channels=3, expand_animations=False)
image = tf.image.resize(image, [224, 224])
image = tf.expand_dims(image, axis=0)

predictions = model.predict(image)
predicted_index = int(np.argmax(predictions[0]))
confidence = float(predictions[0][predicted_index])

print(class_names[predicted_index], confidence)
```

## Catatan Pengembangan Selanjutnya

Beberapa pengembangan yang dapat dilakukan:

- Melatih ulang model setelah update dataset Parang dan Kawung.
- Menambah gambar untuk `batik-megamendung` agar jumlah data lebih seimbang.
- Mengganti file invalid `batik-megamendung/49.jpg` dengan gambar valid.
- Menganalisis `confusion_matrix.png` untuk melihat kelas yang sering tertukar.
- Membuat script inference terpisah, misalnya `predict.py`.
- Membuat antarmuka aplikasi untuk upload gambar batik dan menampilkan prediksi.

## Kesimpulan

Proyek ini menggunakan MobileNetV2 transfer learning untuk mengenali motif Batik Bali, Megamendung, Parang, dan Kawung. Script sudah mendukung validasi file gambar, natural sorting, dynamic split per kelas, class weights otomatis, training dua fase, fine-tuning, evaluasi dengan classification report, dan confusion matrix.

Dengan update dataset terbaru, `batik-parang` dan `batik-kawung` otomatis masuk tier `80+`, sehingga keduanya mendapat porsi training yang lebih besar. Pipeline tetap deterministik dan dapat dijalankan ulang dengan command yang sama.
