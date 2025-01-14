# UnivGO

UnivGO adalah aplikasi direktori kampus yang dirancang untuk memudahkan kamu dalam menemukan informasi seputar kampus di Indonesia. UnivGO memudahkan kamu menemukan kampus terdekat, top 10 PTN, politeknik, dan swasta terbaik, serta berita kampus dan fitur pencarian program studi. 

## Tentang UnivGO Flutter

Mobile Application dari **UnivGO**. Flutter digunakan sebagai framework utama untuk pengembangan aplikasi mobile, memberikan antarmuka pengguna yang interaktif dan responsif. Di sisi backend, Laravel digunakan untuk mengelola data dan logika bisnis, dengan Filament untuk membangun admin panel.

## Fitur

* **Direktori Kampus**: Menampilkan informasi kampus di Indonesia.
* **Pencarian Kampus dan Program Studi**: Fitur pencarian kampus dan program studi dengan sorting dan filter yang beragam sesuai dengan kebutuhan.
* **Rekomendasi Kampus Terdekat**: Daftar Kampus Terdekat sesuai dengan lokasi.
* **Top Kampus**: Menyediakan daftar kampus terbaik di berbagai kategori (PTN, Politeknik, Swasta).
* **Rating dan Ulasan Kampus**: 
Menampilkan rating dan ulasan dari mahasiswa dan alumni untuk setiap kampus, membantu calon mahasiswa dalam memilih kampus yang tepat.
* **Berita Kampus**: Menyediakan berita terkini terkait kampus.

## Instalasi dan Penggunaan

### Requirement

* **Flutter**
* **Git**

### Instalasi

1. **Clone Repository**

   ```bash
   git clone https://github.com/fzlaziz/univgo-flutter.git
   cd univgo-flutter
   ```

2. **Install Dependensi**

   ```bash
   flutter pub get
   ```

3. **Konfigurasi Environment**

   Salin file `.env.example` dan beri nama `.env`:
   ```bash
   cp .env.example .env
   ```

   Ubah konfigurasi untuk base url dan storage system url dari backend service UnivGO Laravel.

4. **Build & Install Release App**

   ```bash
   flutter build apk --release
   ```

