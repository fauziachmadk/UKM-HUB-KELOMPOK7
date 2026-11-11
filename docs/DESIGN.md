# Desain kerangka

Acuan valid: source UKM-HUB-DEV yang telah diperiksa pada workspace, bukan klaim
membuka localhost atau Figma baru. Core/theme, Manrope dan logo lokal berasal
dari fondasi DEV. Layout layar anggota sengaja dasar untuk diimplementasikan.

- Material 3, ColorScheme.fromSeed warna hijau #244B3D, surface hangat, aksen
  hijau muda; dua tema memakai sumber token yang sama.
- Widget mengambil warna melalui Theme.of(context).colorScheme. Tidak menambah
  Colors.xxx langsung; maksimal tiga pengecualian sesuai tugas.
- Gunakan ContentWidth, UkmLogo, RecruitmentBadge, HubMessage yang sudah ada.
- Header Jelajah memuat toggle tema di samping ikon profil. State di root
  dipakai bersama Profil; jangan membuat ThemeMode kedua di layar.
- Detail tetap menunjukkan UKM yang dipilih, bukan hanya CTA tanpa konteks.
- Form harus ditingkatkan: logo/nama/bidang, validasi, alasan multiline,
  keyboard dan ruang baca. Daftar perlu kartu berisi identitas/tanggal/aksi.
- Hindari overflow nama panjang/teks besar, area sentuh kecil, dan warna yang
  hilang di dark mode. Screenshot penilaian harus asli Android, bukan mockup.

| Layar | Baseline | Pekerjaan desain anggota |
| --- | --- | --- |
| Jelajah | Grid dasar + loading/error/retry | Azka: filter/search/empty/responsif |
| Detail | Logo/nama/bidang/deskripsi/CTA | Azka: konteks kaya dan status; Vanesa handoff |
| Form | 3 input satu baris + simpan | Vanesa: validasi/multiline/konteks/keyboard |
| Pendaftaran Saya | ListTile nama/NIM | Vanesa: ringkasan, edit/hapus, empty state |
| Profil | Identitas sesi dan tema | Fauzi: jaga integrasi dan aksesibilitas |

Data merupakan contoh komunitas, bukan klaim daftar/kontak/jadwal resmi kampus.
Hero dan RefreshIndicator adalah bonus setelah fitur wajib lulus.
