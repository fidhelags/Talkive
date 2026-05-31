# Talkive

> - Link Repo: https://github.com/fidhelags/Talkive
> - Branch: `web-mobile`
> - Catatan: Semua file yang diperlukan untuk setup dapat diakses melalui folder Setup

## Setup Backend (Spring Boot)

### 1. Clone Repository
```bash
git clone https://github.com/fidhelags/Talkive.git
```
```
cd Talkive
```
```
git checkout web-mobile
```

### 2. Database
- Nyalakan **XAMPP** → Apache & MySQL
- Import `talkive.sql` dengan nama database `talkive_app`

### 3. Konfigurasi File
- Letakkan `application.properties` di `src/main/resources/`
- Letakkan `firebase-service-account.json` di `src/main/resources/`
- Letakkan `application.properties` di `Talkive`

### 4. Jalankan Backend
```bash
mvn spring-boot:run
```

Buka browser: http://localhost:8080/

---

## Setup Mobile (Flutter)

### 1. Masuk ke Folder Mobile
```bash
cd talkive_mobile
```
```
flutter pub get
```

### 2. Jalankan App
- Nyalakan device/emulator
```bash
flutter run
```

### 3. Troubleshooting AndroidX
- Jika muncul error AndroidX, letakkan `gradle.properties` di `talkive/talkive_mobile/android`
---

## Midtrans (Webhook Pembayaran)

Jalankan ngrok agar callback Midtrans bisa diterima secara otomatis:
```bash
ngrok http 8080
```
> Jika ngrok tidak tersedia, status pembayaran dapat diubah manual di database.

---

## Akun

| Role    | Email              | Password  |
|---------|--------------------|-----------|
| Tutor   | ragil@gmail.com    | @Tutor123 |
| Tutor   | rafly@gmail.com    | @Tutor123 |
| Student | yudis@gmail.com    | @User123  |
| Student | fidhela@gmail.com  | @User123  |
| Student | fadhil@gmail.com   | @User123  |
