// Modul form. Penanggung jawab: Vanesa Rizka Alfatihah - 102022300121.
import 'package:flutter/material.dart';
import '../models/pendaftaran.dart';
import '../models/ukm.dart';
import '../widgets/hub_widgets.dart';

// BEGIN UKM07-VANESA-FORM
// MULAI BAGIAN VANESA.
// TODO(VANESA): Form + validator nama/NIM/alasan yang teruji, alasan multi-baris,
// pesan error per field, konteks logo/bidang, keyboard dan tampilan responsif.
// Baseline hanya menolak kolom kosong; belum validasi akhir tugas kelompok.
class RegistrationForm extends StatefulWidget {
  const RegistrationForm({
    super.key,
    required this.ukm,
    this.initial,
    this.namaAwal = '',
    this.nimAwal = '',
    this.registrations = const [],
  });
  final Ukm ukm;
  final Pendaftaran? initial;
  final String namaAwal, nimAwal;
  final List<Pendaftaran> registrations;
  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  late final _nama = TextEditingController(
    text: widget.initial?.nama ?? widget.namaAwal,
  );
  late final _nim = TextEditingController(
    text: widget.initial?.nim ?? widget.nimAwal,
  );
  late final _alasan = TextEditingController(
    text: widget.initial?.alasan ?? '',
  );

  @override
  void dispose() {
    _nama.dispose();
    _nim.dispose();
    _alasan.dispose();
    super.dispose();
  }

  void _save() {
    if (hasRegistrationForUkm(
      widget.registrations,
      widget.ukm.id,
      except: widget.initial,
    )) {
      return;
    }
    if (_nama.text.trim().isEmpty ||
        _nim.text.trim().isEmpty ||
        _alasan.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi semua kolom terlebih dahulu.')),
      );
      return;
    }
    Navigator.pop(
      context,
      Pendaftaran(
        nama: _nama.text.trim(),
        nim: _nim.text.trim(),
        ukm: widget.ukm,
        alasan: _alasan.text.trim(),
        tanggal: widget.initial?.tanggal ?? DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        '${widget.initial == null ? 'Minat' : 'Ubah minat'} ${widget.ukm.nama}',
      ),
    ),
    body: ContentWidth(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(widget.ukm.nama, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            key: const Key('form-nama'),
            controller: _nama,
            decoration: const InputDecoration(labelText: 'Nama'),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('form-nim'),
            controller: _nim,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'NIM'),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('form-alasan'),
            controller: _alasan,
            decoration: const InputDecoration(labelText: 'Alasan'),
          ),
          const SizedBox(height: 20),
          FilledButton(
            key: const Key('save-registration'),
            onPressed: _save,
            child: const Text('Simpan minat'),
          ),
          const SizedBox(height: 12),
          Text(
            'Minat disimpan di sesi aplikasi, belum dikirim ke pengurus.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ),
  );
}
// END UKM07-VANESA-FORM - VANESA SAMPAI SINI.
