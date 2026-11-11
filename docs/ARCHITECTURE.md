# Arsitektur kerangka

Flutter app/ dan Dart Shelf server/ berdiri terpisah. UI mengambil katalog
melalui ApiService; model Ukm mengubah ISO JSON ke DateTime dan sebaliknya.
Logo adalah aset lokal Flutter. Core/theme dan widgets umum mengikuti acuan DEV
yang disetujui, sementara layar anggota disediakan pada tingkat dasar.

## State dan navigasi

UkmHubApp memiliki satu client dan ThemeMode. MainPage memiliki indeks tab,
identitas opsional dan List<Pendaftaran>. NavigationBar memakai IndexedStack.
Kartu -> callback onOpen -> MainPage push DetailPage(Ukm). Detail push form;
form pop(Pendaftaran), detail memeriksa mounted dan meneruskan hasil dengan pop;
MainPage await/mounted/duplikat lalu setState dan memilih tab daftar.

Satu minat per id UKM dalam sesi. Form/detail dan induk memakai guard bersama
hasRegistrationForUkm; edit mengecualikan objek sendiri. Hapus membuka minat
baru, undo tidak boleh membuat duplikat. Callback edit/hapus/undo di core sudah
tersedia, tetapi UI daftar belum menampilkan aksi tersebut: pekerjaan Vanesa.

Tidak ada persistensi, auth, cloud DB, admin, POST, atau pengiriman ke pengurus.
Memulai ulang proses menghapus state. Model, constructor, callback, dan field
JSON merupakan kontrak bersama; perubahan melalui Fauzi sebelum coding.

## Kontrak model

Ukm: String id/nama/bidang/ketua/logo/singkat; int jumlahAnggota;
bool bukaRekrutmen; DateTime berdiri; String? deskripsi; List<String> kegiatan.
Lima bidang: Olahraga, Seni, Teknologi, Keagamaan, Sosial.
Pendaftaran: String nama/nim/alasan; Ukm ukm; DateTime tanggal. NIM tetap String.

## API: kondisi awal vs target

| Request/metode | Baseline | Target anggota |
| --- | --- | --- |
| GET /ukm | Array 5 seed | Minimal 12 lengkap |
| GET /ukm/{id} | Objek/404 | Perkuat tes kontrak |
| GET /ukm?bidang=... | 501, belum siap | Djalil: filter case-insensitive; tak dikenal [] |
| ApiService.getUkm() | GET list dasar | Arief: query/timeout/error spesifik |
| ApiService.getUkmById(id) | ApiException belum dihubungkan | Arief: HTTP detail dan parsing |

Detail UI menerima Ukm dari constructor; tidak memerlukan request detail baru.
Endpoint detail tetap wajib tersedia dan diuji. Djalil/Arief menyelesaikan filter
lebih dahulu sebelum Azka mengaktifkan chip bidang.

API_URL dibaca dari dart-define, default 10.0.2.2:8080 untuk emulator. HP USB
memakai reverse +127.0.0.1 atau jaringan LAN +IP laptop. Server HOST/PORT dari
environment. HTTP cleartext hanya diizinkan debug. Tidak ada path D dalam source.
