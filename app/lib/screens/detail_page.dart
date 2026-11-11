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
  // TODO(AZKA): tambahkan panduan bidang tanpa mengarang informasi resmi.
  bool get _alreadyRegistered => hasRegistrationForUkm(registrations, ukm.id);
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
  // TODO(AZKA): tambahkan ketua/anggota/tahun/kegiatan dan konteks detail kaya
  // sesuai DEV; nama tetap jelas saat scroll; CTA jangan mengubah alur Vanesa.
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
            FilledButton(
              key: const Key('register-ukm'),
              onPressed: ukm.bukaRekrutmen && !_alreadyRegistered
                  ? () => _register(context)
                  : null,
              child: Text(
                _alreadyRegistered
                    ? 'Sudah terdaftar'
                    : ukm.bukaRekrutmen
                    ? 'Saya berminat'
                    : 'Rekrutmen tutup',
              ),
            ),
          ],
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
