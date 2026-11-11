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
    entries = [
        ("P01/P02-1 org/paket", "app/android/app/build.gradle.kts", 'applicationId =', "Dasar tersedia: id.ac.telkomuniversity.ukm_hub; flutter create sesuai org."),
        ("P01/P02-2 launcher", "app/android/app/src/main/AndroidManifest.xml", 'android:label=', "Nama UKM Hub dan ikon lokal; QA perangkat dicatat terpisah."),
        ("P01/P02-3 Android/4 capture", "screenshots/README.md", '# Screenshot', "Belum final: perlu run versi gabungan dan minimal 4 screenshot perangkat."),
        ("P01/P02-4 analyze", "docs/QA.md", '# QA', "Lihat hasil aktual QA; wajib diulang setelah implementasi anggota."),
        ("P03-1 widget/state", "app/lib/screens/main_page.dart", 'class MainPage', "Dasar: custom Stateful/Stateless dan setState pada integrasi."),
        ("P03-2 controller/dispose", "app/lib/screens/registration_form.dart", 'void dispose()', "Dasar tersedia; validasi akhir dan multiline tugas Vanesa."),
        ("P03-3 dua tombol M3", "app/lib/screens/jelajah_page.dart", 'IconButton(', "Dasar IconButton dan FilledButton; OutlinedButton pada daftar/Profil."),
        ("P03-4 pilihan", "app/lib/screens/profile_page.dart", 'ChoiceChip(', "Dasar pilihan tema; chip bidang Jelajah belum dibuat Azka."),
        ("P03-5 SnackBar", "app/lib/screens/main_page.dart", 'showSnackBar(', "Dasar feedback minat; uji gabungan tetap diperlukan."),
        ("P04-1 model 6+/tanggal/bool", "app/lib/models/ukm.dart", 'final DateTime berdiri', "Kontrak model tersedia, termasuk bool dan DateTime."),
        ("P04-2 custom card layout", "app/lib/widgets/ukm_card.dart", '// TODO(AZKA)', "Belum: Row/Column/Expanded/Stack dan Positioned badge tugas Azka."),
        ("P04-3 builder", "app/lib/screens/jelajah_page.dart", 'GridView.builder(', "Grid dasar tersedia; filter/search/responsif perlu diselesaikan."),
        ("P04-4 tiga tab/IndexedStack", "app/lib/screens/main_page.dart", 'child: IndexedStack(', "Dasar tersedia: Jelajah, Pendaftaran Saya, Profil."),
        ("P05-1 detail constructor", "app/lib/screens/main_page.dart", 'builder: (_) => DetailPage(', "Ukm diteruskan melalui push dan constructor."),
        ("P05-2 pop/await/data langsung", "app/lib/screens/registration_form.dart", 'Navigator.pop(', "Alur dasar tersedia; validasi/list akhir masih tugas Vanesa."),
        ("P05-3 mounted", "app/lib/screens/detail_page.dart", 'if (!context.mounted', "Guard dasar tersedia setelah await; jaga saat mengembangkan."),
        ("P05-4 tiga widget test", "app/test/flows_test.dart", "testWidgets(", "4 widget test dasar; cakupan final dikembangkan Arief."),
        ("P06-1 seed/darkTheme", "app/lib/core/app.dart", 'darkTheme:', "Dua tema dan ColorScheme.fromSeed pada core/theme tersedia."),
        ("P06-2 warna skema", "app/lib/widgets/hub_widgets.dart", 'Theme.of(context).colorScheme', "Widget memakai skema; jaga maksimal 3 Colors.xxx saat pengembangan."),
        ("P06-3 font", "app/pubspec.yaml", 'family: Manrope', "Font lokal Manrope dengan lisensi OFL."),
        ("P06-4 ikon", "app/pubspec.yaml", 'flutter_launcher_icons:', "Generator ikon dan aset disediakan; hasil perangkat di QA."),
        ("P06-5 aset lokal", "app/pubspec.yaml", 'assets/images/', "Logo/ilustrasi terdaftar; UkmLogo dipakai kartu/detail."),
        ("P07-1 Shelf/12 JSON", "server/data/ukm.json", '"id"', "Sebagian: Shelf/router ada, seed baru 5; Djalil wajib 12+."),
        ("P07-2 tiga GET/filter", "server/lib/api.dart", "router.get('/ukm'", "Sebagian: daftar/detail ada; filter bidang masih 501, belum memenuhi final."),
        ("P07-3 http/API_URL", "app/lib/services/api_service.dart", "'API_URL'", "GET daftar dasar; Arief melengkapi query/detail/error/timeout."),
        ("P07-4 JSON/DateTime", "app/lib/models/ukm.dart", 'DateTime.parse(', "fromJson/toJson tersedia; uji round-trip perlu ditambah."),
        ("P07-5 FutureBuilder", "app/lib/screens/jelajah_page.dart", 'FutureBuilder<List<Ukm>>(', "Dasar loading/error/retry/sukses tersedia; perlu regresi Arief."),
        ("P07-6 MockClient", "app/test/api_service_test.dart", 'MockClient(', "1 tes dasar; perlu variasi error dan query/detail."),
    ]
    assert len(entries) == 28
    body = ["| Poin | File:baris aktual | Status kerangka |", "| --- | --- | --- |"]
    for point, path, needle, status in entries:
        body.append(f"| {point} | {ref(path, needle)} | {status} |")
    path = ROOT / "README.md"
    content = path.read_text(encoding="utf-8")
    start, end = "<!-- CHECKLIST:BEGIN -->", "<!-- CHECKLIST:END -->"
    before, after = content.split(start, 1)
    _, tail = after.split(end, 1)
    path.write_text(before + start + "\n" + "\n".join(body) + "\n" + end + tail, encoding="utf-8")


if __name__ == "__main__":
    count = regions()
    checklist()
    print(f"Peta {count} batas tugas dan 28 baris README diperbarui.")
