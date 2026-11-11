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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(ukm.nama)),
    body: ContentWidth(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          UkmLogo(ukm: ukm, size: 72),
          const SizedBox(height: 20),
          Text(ukm.nama, style: Theme.of(context).textTheme.headlineSmall),
          Text(ukm.bidang),
          const SizedBox(height: 16),
          Text(ukm.deskripsi ?? ukm.singkat),
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
  // END UKM07-AZKA-DETAIL-VIEW - AZKA SAMPAI SINI.
}
