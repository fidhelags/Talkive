# Talkive

> **Repository:** https://github.com/fidhelags/Talkive
> **Branch:** `web-mobile`

## Informasi Setup

Seluruh file yang diperlukan untuk proses setup aplikasi tersedia pada folder **Setup**. Namun, folder tersebut tidak disertakan dalam repository karena mengandung file konfigurasi dan kredensial yang bersifat sensitif, seperti `firebase-service-account.json` dan `application.properties`.

Untuk keperluan instalasi dan pengujian aplikasi, silakan memperoleh folder **Setup** secara terpisah melalui pengembang atau pihak yang bertanggung jawab atas proyek ini.

---

## Setup Backend (Spring Boot)

### 1. Clone Repository

```bash
git clone https://github.com/fidhelags/Talkive.git
cd Talkive
git checkout web-mobile
```

### 2. Setup Database

1. Jalankan **XAMPP** dan aktifkan **Apache** serta **MySQL**.
2. Buat database dengan nama `talkive_app`.
3. Import file `talkive_app_updated.sql` ke database tersebut.

### 3. Konfigurasi File

Letakkan file berikut pada lokasi yang sesuai:

* `firebase-service-account.json` → `src/main/resources/`
* `application.properties` → root project (`Talkive/`)

### 4. Menjalankan Backend

```bash
mvn spring-boot:run
```

Backend akan berjalan pada:

```text
http://localhost:8080
```

### Catatan

Warning berikut dapat diabaikan karena tidak memengaruhi proses build maupun jalannya aplikasi:

```text
warning: [options] source value 8 is obsolete and will be removed in a future release
warning: [options] target value 8 is obsolete and will be removed in a future release
warning: [options] To suppress warnings about obsolete options, use -Xlint:-options.
```

---

## Setup Mobile (Flutter)

### 1. Masuk ke Folder Mobile

```bash
cd talkive_mobile
flutter pub get
```

### 2. Menjalankan Aplikasi

Pastikan emulator atau perangkat Android telah aktif, kemudian jalankan:

```bash
flutter run
```

### 3. Troubleshooting AndroidX

Jika muncul error terkait AndroidX, salin file `gradle.properties` ke direktori berikut:

```text
Talkive/talkive_mobile/android
```

---

## Midtrans (Webhook Pembayaran)

Agar callback pembayaran dari Midtrans dapat diterima secara otomatis, jalankan:

```bash
ngrok http 8080
```

> Jika ngrok tidak tersedia, status pembayaran dapat diperbarui secara manual melalui database.

---

## Akun Pengujian

| Role    | Email                                         | Password     |
| ------- | --------------------------------------------- | ------------ |
| Tutor   | [ragil@gmail.com](mailto:ragil@gmail.com)     | @Tutor123    |
| Tutor   | [rafly@gmail.com](mailto:rafly@gmail.com)     | @Tutor123    |
| Student | [yudis@gmail.com](mailto:yudis@gmail.com)     | @Yudis123123 |
| Student | [fidhela@gmail.com](mailto:fidhela@gmail.com) | @User123     |
| Student | [fadhil@gmail.com](mailto:fadhil@gmail.com)   | @User123     |
