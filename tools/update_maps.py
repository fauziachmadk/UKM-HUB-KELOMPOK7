"""Fauzi: perbarui batas kepemilikan dan bukti README dari source aktual.

Penanda kode stabil, nomor baris dihasilkan ulang setelah format. Status fitur
tidak ditebak dari pencarian string; pengintegrasi memperbaruinya dengan bukti.
"""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def line(path, needle):
    lines = (ROOT / path).read_text(encoding="utf-8").splitlines()
    return next(i for i, text in enumerate(lines, 1) if needle in text)


def ref(path, needle, prefix=""):
    number = line(path, needle)
    return f"[{path}:{number}]({prefix}{path}#L{number})"


def regions():
    rows = []
    used = set()
    for folder in ("app/lib", "app/test", "server/bin", "server/lib", "server/test"):
        for path in sorted((ROOT / folder).rglob("*.dart")):
            active = None
            for number, text in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
                begin = re.search(r"// BEGIN (UKM07-[A-Z0-9-]+)", text)
                end = re.search(r"// END (UKM07-[A-Z0-9-]+)", text)
                if begin:
                    assert active is None, f"Region bersarang: {path}:{number}"
                    assert begin[1] not in used, f"ID ganda: {begin[1]}"
                    active = (begin[1], number)
                    used.add(begin[1])
                if end:
                    assert active and active[0] == end[1], f"END tidak cocok: {path}:{number}"
                    assert "SAMPAI SINI" in text, f"Batas akhir belum jelas: {path}:{number}"
                    relative = path.relative_to(ROOT).as_posix()
                    rows.append(f"| {active[0].split('-')[1].title()} | `{active[0]}` | "
                                f"[{relative}](../{relative}#L{active[1]}) | {active[1]}-{number} |")
                    active = None
            assert active is None, f"Region belum ditutup: {path}"
    dataset = ROOT / "server/data/ukm.json"
    rows.append(f"| Djalil | Dataset (JSON tanpa komentar) | [server/data/ukm.json](../server/data/ukm.json) | 1-{len(dataset.read_text(encoding='utf-8').splitlines())} |")
    content = """# Peta ownership dan baris aktual

Dihasilkan oleh tools/update_maps.py setelah format. Rentang mencakup komentar
BEGIN/END, bukan klaim siapa yang telah menulis baseline. Cari ID pada VS Code.
Seluruh file platform hasil flutter create dan konfigurasi native dikelola Fauzi.
Import/signature detail bersama melalui Fauzi; jangan mengubah region teman.

| Pemegang tugas | Region stabil | File | Baris awal-akhir |
| --- | --- | --- | --- |
""" + "\n".join(rows) + "\n"
    (ROOT / "docs/OWNERSHIP.md").write_text(content, encoding="utf-8")
    return len(rows)


def checklist():
    # Status source ditinjau; bukti eksekusi dan perangkat tetap perlu QA.
    entries = (
        [('P01–P02: 1. Pembuatan proyek dan nama paket',
          [('docs/QA.md', 'flutter create'), ('app/android/app/build.gradle.kts', 'applicationId =')],
          'Proyek dibuat dengan organisasi id.ac.telkomuniversity; nama paket Android '
          'id.ac.telkomuniversity.ukm_hub.'),
         ('P01–P02: 2. Nama aplikasi pada launcher',
          [('app/android/app/src/main/AndroidManifest.xml', 'android:label=')],
          'Nama aplikasi yang ditampilkan adalah UKM Hub.'),
         ('P01–P02: 3. Android dan minimal 4 screenshot',
          [('screenshots/README.md', '# Screenshot')],
          'Empat screenshot Android ditampilkan pada bagian 3. Asal gambar dan catatan pengujian perangkat '
          'dijelaskan pada QA.'),
         ('P01–P02: 4. Hasil flutter analyze',
          [('docs/QA.md', '## Pemeriksaan versi gabungan')],
          'flutter analyze selesai tanpa error maupun warning pada 12 November 2026.'),
         ('P03: 1. StatelessWidget, StatefulWidget, dan setState',
          [('app/lib/widgets/ukm_card.dart', 'extends StatelessWidget'),
           ('app/lib/screens/main_page.dart', 'extends StatefulWidget'),
           ('app/lib/screens/main_page.dart', 'setState(() {')],
          'UkmCard menggunakan StatelessWidget; MainPage menggunakan StatefulWidget dan setState untuk '
          'memperbarui tampilan.'),
         ('P03: 2. TextField, controller, dan dispose',
          [('app/lib/screens/jelajah_page.dart', 'TextField('),
           ('app/lib/screens/jelajah_page.dart', '_search.dispose()')],
          'Kolom pencarian menggunakan controller yang ditutup melalui dispose.'),
         ('P03: 3. Minimal 2 jenis tombol Material 3',
          [('app/lib/screens/registration_form.dart', 'FilledButton.icon('),
           ('app/lib/screens/registration_form.dart', 'OutlinedButton(')],
          'Form menyediakan FilledButton dan OutlinedButton. IconButton juga digunakan pada aplikasi.'),
         ('P03: 4. Pilihan menggunakan chip',
          [('app/lib/screens/jelajah_page.dart', 'ChoiceChip(')],
          'ChoiceChip menyediakan pilihan Semua dan lima bidang UKM.'),
         ('P03: 5. Umpan balik menggunakan SnackBar',
          [('app/lib/screens/main_page.dart', 'Minat berhasil disimpan.')],
          'SnackBar menampilkan pesan penyimpanan minat dan menyediakan aksi Urungkan setelah '
          'penghapusan.'),
         ('P04: 1. Model minimal 6 field, DateTime, dan bool',
          [('app/lib/models/ukm.dart', 'class Ukm'),
           ('app/lib/models/ukm.dart', 'final bool'),
           ('app/lib/models/ukm.dart', 'final DateTime')],
          'Ukm memiliki delapan field utama, termasuk bukaRekrutmen bertipe bool dan berdiri bertipe '
          'DateTime.'),
         ('P04: 2. Kartu dengan Row, Column, Expanded, dan Stack',
          [('app/lib/widgets/ukm_card.dart', 'Row('),
           ('app/lib/widgets/ukm_card.dart', 'Column('),
           ('app/lib/widgets/ukm_card.dart', 'Expanded('),
           ('app/lib/widgets/ukm_card.dart', 'Stack(')],
          'UkmCard menyusun logo, informasi UKM, dan lencana rekrutmen menggunakan keempat widget '
          'tersebut.'),
         ('P04: 3. Daftar menggunakan builder',
          [('app/lib/screens/jelajah_page.dart', 'GridView.builder(')],
          'Katalog UKM ditampilkan menggunakan GridView.builder.'),
         ('P04: 4. NavigationBar minimal 3 tab dan IndexedStack',
          [('app/lib/screens/main_page.dart', 'IndexedStack('),
           ('app/lib/screens/main_page.dart', 'NavigationBar(')],
          'Tersedia tab Jelajah, Pendaftaran Saya, dan Profil; IndexedStack mempertahankan halaman saat '
          'berpindah tab.'),
         ('P05: 1. Detail menerima objek melalui konstruktor',
          [('app/lib/screens/main_page.dart', 'Navigator.push<Pendaftaran>'),
           ('app/lib/screens/detail_page.dart', 'required this.ukm')],
          'Navigator.push membuka DetailPage dengan objek Ukm melalui konstruktor.'),
         ('P05: 2. Form mengembalikan data dan memperbarui daftar',
          [('app/lib/screens/registration_form.dart', 'Navigator.pop(context, record)'),
           ('app/lib/screens/main_page.dart', 'await Navigator.push'),
           ('app/lib/screens/main_page.dart', '_registrations.insert(0, record)')],
          'Form mengembalikan data melalui Navigator.pop. MainPage menunggu hasil dengan await, menambah '
          'data, lalu membuka Pendaftaran Saya.'),
         ('P05: 3. Pemeriksaan mounted setelah await',
          [('app/lib/screens/main_page.dart', 'if (!mounted || record == null)'),
           ('app/lib/screens/detail_page.dart', 'if (!context.mounted')],
          'mounted diperiksa sebelum memakai context atau memperbarui state setelah await.'),
         ('P05: 4. Minimal 3 widget test dan hasil pengujian',
          [('app/test/flows_test.dart', 'testWidgets('), ('docs/QA.md', '## Pemeriksaan versi gabungan')],
          'Sebanyak 12 widget test dan 5 tes layanan lulus pada 12 November 2026.'),
         ('P06: 1. ThemeData, ColorScheme.fromSeed, dan darkTheme',
          [('app/lib/core/theme.dart', 'ColorScheme.fromSeed('), ('app/lib/core/app.dart', 'darkTheme:')],
          'Aplikasi menyediakan tema terang dan gelap dengan warna dasar hijau.'),
         ('P06: 2. Warna widget dari ColorScheme',
          [('app/lib/widgets/ukm_card.dart', 'Theme.of(context).colorScheme')],
          'Warna widget diambil dari ColorScheme pada tema aplikasi.'),
         ('P06: 3. Font kustom',
          [('app/pubspec.yaml', 'family: Manrope')],
          'Font Manrope disimpan sebagai aset lokal dan disertai lisensi SIL OFL.'),
         ('P06: 4. Ikon launcher sendiri',
          [('app/pubspec.yaml', 'flutter_launcher_icons:'),
           ('app/android/app/src/main/AndroidManifest.xml', 'android:icon=')],
          'Ikon UKM Hub dibuat menggunakan flutter_launcher_icons dan digunakan pada launcher Android.'),
         ('P06: 5. Gambar aset lokal',
          [('app/pubspec.yaml', '- assets/images/'), ('app/lib/widgets/hub_widgets.dart', 'class UkmLogo')],
          'Aset gambar didaftarkan dalam pubspec dan logo ditampilkan melalui UkmLogo.'),
         ('P07: 1. Shelf, Shelf Router, dan minimal 12 item JSON',
          [('server/pubspec.yaml', 'shelf:'),
           ('server/pubspec.yaml', 'shelf_router:'),
           ('server/data/ukm.json', '"id":"aksara"')],
          'Server menggunakan shelf dan shelf_router. Dataset berisi 15 UKM dalam lima bidang.'),
         ('P07: 2. GET daftar, detail, dan endpoint khas',
          [('server/lib/api.dart', "router.get('/ukm'"),
           ('server/lib/api.dart', "queryParameters['bidang']"),
           ('server/lib/api.dart', "router.get('/ukm/<id>'")],
          'API menyediakan daftar UKM, detail berdasarkan ID, dan filter bidang pada server.'),
         ('P07: 3. Paket http dan konfigurasi API_URL',
          [('app/lib/services/api_service.dart', "'package:http/http.dart'"),
           ('app/lib/services/api_service.dart', "'API_URL'")],
          'ApiService menggunakan paket http; alamat server ditentukan melalui API_URL saat menjalankan '
          'aplikasi.'),
         ('P07: 4. fromJson, toJson, dan konversi DateTime',
          [('app/lib/models/ukm.dart', 'factory Ukm.fromJson'),
           ('app/lib/models/ukm.dart', 'DateTime.parse('),
           ('app/lib/models/ukm.dart', 'toJson()')],
          'Model menyediakan fromJson dan toJson dengan konversi tanggal ISO ke DateTime dan sebaliknya.'),
         ('P07: 5. FutureBuilder dengan tiga keadaan',
          [('app/lib/screens/jelajah_page.dart', 'FutureBuilder<List<Ukm>>'),
           ('app/lib/screens/jelajah_page.dart', 'snapshot.hasError'),
           ('app/lib/screens/jelajah_page.dart', "Text('Coba lagi')")],
          'FutureBuilder menampilkan keadaan memuat, pesan gagal dengan tombol Coba lagi, dan katalog saat '
          'berhasil.'),
         ('P07: 6. Pengujian menggunakan MockClient',
          [('app/test/api_service_test.dart', 'MockClient('),
           ('docs/QA.md', '## Pemeriksaan versi gabungan')],
          'Lima tes MockClient lulus, mencakup filter, detail, status HTTP, format JSON, dan kegagalan '
          'koneksi.')]
    )
    assert len(entries) == 28
    body = ["| Poin | File:baris | Keterangan |", "| --- | --- | --- |"]
    for point, sources, status in entries:
        refs = "; ".join(ref(path, needle) for path, needle in sources)
        body.append(f"| {point} | {refs} | {status} |")
    path = ROOT / "README.md"
    content = path.read_text(encoding="utf-8")
    start, end = "<!-- CHECKLIST:BEGIN -->", "<!-- CHECKLIST:END -->"
    if content.count(start) != 1 or content.count(end) != 1:
        raise ValueError("README harus memiliki tepat satu pasangan penanda CHECKLIST.")
    before, after = content.split(start, 1)
    _, tail = after.split(end, 1)
    path.write_text(before + start + "\n" + "\n".join(body) + "\n" + end + tail, encoding="utf-8")


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Perbarui bukti README dan peta region.")
    parser.add_argument("--readme-only", action="store_true",
                        help="Perbarui tabel README tanpa mengubah peta region.")
    args = parser.parse_args()
    checklist()
    if args.readme_only:
        print("28 baris README diperbarui; semua anchor source ditemukan.")
    else:
        count = regions()
        print(f"Peta {count} batas tugas dan 28 baris README diperbarui.")
