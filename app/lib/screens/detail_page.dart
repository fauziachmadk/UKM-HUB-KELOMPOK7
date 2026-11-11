// File bersama: Azka (tampilan), Vanesa (handoff form), Fauzi (kontrak).
// Perubahan import/signature melalui Fauzi; jangan mengedit region teman.
import 'package:flutter/material.dart';
import '../models/pendaftaran.dart';
import '../models/ukm.dart';
import '../widgets/hub_widgets.dart';
import 'registration_form.dart';

class DetailPage extends StatelessWidget {
  // BEGIN UKM07-FAUZI-DETAIL-CONTRACT
  // MULAI BAGIAN FAUZI: constructor dan field kontrak bersama.
  const DetailPage({
    super.key,
    required this.ukm,
    required this.registrations,
    this.namaAwal = '',
    this.nimAwal = '',
  });
  final Ukm ukm;
  final List<Pendaftaran> registrations;
  final String namaAwal, nimAwal;
  // END UKM07-FAUZI-DETAIL-CONTRACT - FAUZI SAMPAI SINI.

  // BEGIN UKM07-AZKA-DETAIL-GUIDE
  // MULAI BAGIAN AZKA. Status memakai aturan duplikat bersama.
  bool get _alreadyRegistered => hasRegistrationForUkm(registrations, ukm.id);

  // Panduan minat berdasarkan bidang, bukan klaim jadwal atau syarat resmi UKM.
  String get _interestGuide => switch (ukm.bidang) {
    'Seni' =>
      'Kamu yang ingin mengembangkan ekspresi, mencoba proses kreatif, dan menghasilkan karya bersama teman kampus.',
    'Teknologi' =>
      'Kamu yang senang mencoba ide, memecahkan masalah, dan belajar teknologi melalui proyek bersama.',
    'Olahraga' =>
      'Kamu yang ingin membangun kebiasaan bergerak, mengasah teknik, dan menikmati kerja sama dalam latihan.',
    'Keagamaan' =>
      'Kamu yang ingin memperdalam pemahaman, mengikuti kegiatan kerohanian, dan bertumbuh bersama komunitas.',
    'Sosial' =>
      'Kamu yang tertarik berbagi pengetahuan, menjadi relawan, dan berkontribusi pada lingkungan sekitar.',
    _ =>
      'Kamu yang ingin mengenal teman baru dan mengembangkan minat melalui kegiatan bersama.',
  };
  // END UKM07-AZKA-DETAIL-GUIDE - AZKA SAMPAI SINI.

  Future<void> _register(BuildContext context) async {
    if (_alreadyRegistered || !ukm.bukaRekrutmen) return;
    final record = await Navigator.push<Pendaftaran>(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrationForm(
          ukm: ukm,
          registrations: registrations,
          namaAwal: namaAwal,
          nimAwal: nimAwal,
        ),
      ),
    );
    if (!context.mounted || record == null) return;
    Navigator.pop(context, record);
  }

  // BEGIN UKM07-AZKA-DETAIL-VIEW
  // MULAI BAGIAN AZKA.
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final registered = _alreadyRegistered;
    final canRegister = ukm.bukaRekrutmen && !registered;
    return Scaffold(
      // Nama tetap terlihat saat pengguna menggulir penjelasan panjang.
      appBar: AppBar(
        title: Text(ukm.nama, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: ContentWidth(
        child: ListView(
          key: const Key('detail-scroll'),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: cs.secondaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'ukm-${ukm.id}',
                        child: UkmLogo(ukm: ukm, size: 72),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ukm.bidang.toUpperCase(),
                              style: TextStyle(
                                color: cs.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              ukm.nama,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -1,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (ukm.singkat.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      ukm.singkat,
                      style: TextStyle(color: cs.onSurfaceVariant, height: 1.6),
                    ),
                  ],
                  const SizedBox(height: 16),
                  RecruitmentBadge(open: ukm.bukaRekrutmen),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _DetailSection(
              title: 'Tentang ${ukm.nama}',
              child: Text(
                ukm.deskripsi ??
                    '${ukm.nama} adalah komunitas bidang ${ukm.bidang.toLowerCase()} untuk mengembangkan minat bersama mahasiswa lain.',
                style: TextStyle(color: cs.onSurfaceVariant, height: 1.8),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: const Icon(Icons.people_outline, size: 18),
                  label: Text('${ukm.jumlahAnggota} anggota'),
                ),
                Chip(
                  avatar: const Icon(Icons.calendar_today_outlined, size: 16),
                  label: Text('Berdiri ${ukm.berdiri.year}'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person_outline, color: cs.primary, size: 21),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Ketua: ${ukm.ketua}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            _DetailSection(
              title: 'Cocok untuk kamu yang...',
              child: Text(
                _interestGuide,
                style: TextStyle(color: cs.onSurfaceVariant, height: 1.8),
              ),
            ),
            if (ukm.kegiatan.isNotEmpty) ...[
              const SizedBox(height: 28),
              _DetailSection(
                title: 'Kegiatan di ${ukm.nama}',
                child: Column(
                  key: const Key('detail-activities'),
                  children: ukm.kegiatan
                      .asMap()
                      .entries
                      .map(
                        (entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 30,
                                child: Text(
                                  '${entry.key + 1}'.padLeft(2, '0'),
                                  style: TextStyle(
                                    color: cs.primary,
                                    fontWeight: FontWeight.w800,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: registered
                    ? cs.primaryContainer
                    : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    registered
                        ? Icons.check_circle_outline
                        : ukm.bukaRekrutmen
                        ? Icons.how_to_reg_outlined
                        : Icons.lock_outline,
                    color: registered ? cs.onPrimaryContainer : cs.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          registered
                              ? 'Kamu sudah terdaftar'
                              : ukm.bukaRekrutmen
                              ? 'Minat bergabung sedang dibuka'
                              : 'Rekrutmen sedang ditutup',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: registered
                                ? cs.onPrimaryContainer
                                : cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          registered
                              ? 'Minatmu untuk ${ukm.nama} sudah tersimpan. Perbarui alasan atau hapus minat melalui Pendaftaran Saya.'
                              : ukm.bukaRekrutmen
                              ? 'Isi nama, NIM, dan alasanmu bergabung dengan ${ukm.nama}. Hasilnya langsung muncul di Pendaftaran Saya. Setiap UKM hanya bisa didaftarkan satu kali dalam sesi ini.'
                              : 'Kamu tetap bisa mengenal ${ukm.nama} melalui profil dan kegiatan di halaman ini. Form minat belum tersedia selama rekrutmen ditutup.',
                          style: TextStyle(
                            height: 1.7,
                            color: registered
                                ? cs.onPrimaryContainer
                                : cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Katalog ini memakai data contoh untuk UTS. Minat hanya tersimpan selama sesi aplikasi dan belum dikirim kepada pengurus UKM.',
              style: TextStyle(
                fontSize: 11,
                color: cs.onSurfaceVariant,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: ContentWidth(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Minat bergabung dengan ${ukm.nama}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    key: const Key('register-ukm'),
                    onPressed: canRegister ? () => _register(context) : null,
                    icon: Icon(
                      registered
                          ? Icons.check_circle_outline
                          : ukm.bukaRekrutmen
                          ? Icons.arrow_forward
                          : Icons.lock_outline,
                    ),
                    label: Text(
                      registered
                          ? 'Sudah terdaftar'
                          : ukm.bukaRekrutmen
                          ? 'Saya berminat'
                          : 'Rekrutmen belum dibuka',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // END UKM07-AZKA-DETAIL-VIEW - AZKA SAMPAI SINI.
}

// BEGIN UKM07-AZKA-DETAIL-SECTION
// MULAI BAGIAN AZKA. Widget privat judul + isi bagian detail.
class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 10),
      child,
    ],
  );
}
// END UKM07-AZKA-DETAIL-SECTION - AZKA SAMPAI SINI.
