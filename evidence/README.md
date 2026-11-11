# Bukti smoke-test kerangka, 11 November 2026

Semua capture berikut berasal dari Android Emulator UKM_Hub_DEV, emulator-5560,
1080x2400, bukan render/mockup. API uji port 18081 terpisah dari port 8080.
Source anggota masih dasar; capture ini bukan bukti aplikasi UTS final.

| Capture | Yang benar-benar diamati |
| --- | --- |
| [01-catalog.png](01-catalog.png) | Lima UKM tampil dari server sungguhan |
| [02-registration.png](02-registration.png) | Form kembali ke induk, satu minat nama/NIM demo muncul |
| [03-duplicate-locked.png](03-duplicate-locked.png) | Detail sama: tombol Sudah terdaftar nonaktif |
| [04-server-error.png](04-server-error.png) | APK akhir ketika server uji dihentikan: error + Coba lagi |
| [05-retry-success.png](05-retry-success.png) | APK akhir: server hidup kembali, Coba lagi memulihkan katalog |

Capture 01-03 diambil pada smoke APK awal sebelum perbaikan callback retry
(SHA-256 26c8bbd50f64ef830bca1088b560d0399c3ce2b4cd9d30d31ed453ebf2787043).
Capture 04-05 diambil ulang setelah perbaikan callback dan tes regresi
(SHA-256 42242f335c7cee5c2c6af382deb1f126451e25649f158c130f175c3d23173b54).
Kedua APK memakai API_URL=http://10.0.2.2:18081. APK normal dibangun terpisah
dengan API_URL=http://10.0.2.2:8080; lihat artifacts pada workspace pembuat.
APK, cache, log runtime dan PID tidak masuk arsip source/Git.

Layar final kelompok perlu diverifikasi/dicapture ulang setelah pekerjaan anggota
terintegrasi. Identitas demo bukan pendaftaran resmi atau data pengguna nyata.
