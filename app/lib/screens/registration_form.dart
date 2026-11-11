// Modul form. Penanggung jawab: Vanesa Rizka Alfatihah - 102022300121.
import 'package:flutter/material.dart';
import '../models/pendaftaran.dart';
import '../models/ukm.dart';
import '../widgets/hub_widgets.dart';

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
  final _form = GlobalKey<FormState>();
  bool get _alreadyRegistered => hasRegistrationForUkm(
    widget.registrations,
    widget.ukm.id,
    except: widget.initial,
  );
  late final TextEditingController _nama = TextEditingController(
    text: widget.initial?.nama ?? widget.namaAwal,
  );
  late final TextEditingController _nim = TextEditingController(
    text: widget.initial?.nim ?? widget.nimAwal,
  );
  late final TextEditingController _alasan = TextEditingController(
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
    if (_alreadyRegistered) return;
    if (!_form.currentState!.validate()) return;
    final record = Pendaftaran(
      nama: _nama.text.trim(),
      nim: _nim.text.trim(),
      ukm: widget.ukm,
      alasan: _alasan.text.trim(),
      tanggal: widget.initial?.tanggal ?? DateTime.now(),
    );
    // Hanya mengembalikan data. MainPage menjadi pemilik tunggal daftar minat.
    Navigator.pop(context, record);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initial == null
              ? 'Daftar ${widget.ukm.nama}'
              : 'Ubah minat ${widget.ukm.nama}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ContentWidth(
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            children: [
              Container(
                key: const Key('form-ukm-context'),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.secondaryContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    UkmLogo(ukm: widget.ukm, size: 44),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.ukm.bidang,
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            widget.ukm.nama,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                          if (widget.ukm.singkat.isNotEmpty)
                            Text(
                              widget.ukm.singkat,
                              style: TextStyle(
                                color: cs.onSurfaceVariant,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (_alreadyRegistered) ...[
                Text(
                  'Kamu sudah terdaftar di ${widget.ukm.nama}. Ubah minat yang sudah ada melalui Pendaftaran Saya.',
                  key: const Key('duplicate-registration-message'),
                  style: TextStyle(
                    color: cs.primary,
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
              ],
              Text(
                'Langkah kecil,\ncerita baru.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Ceritakan sedikit tentang dirimu dan alasanmu ingin bergabung dengan ${widget.ukm.nama}.',
                style: TextStyle(color: cs.onSurfaceVariant, height: 1.6),
              ),
              const SizedBox(height: 26),
              TextFormField(
                key: const Key('form-nama'),
                controller: _nama,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Nama lengkap'),
                validator: (value) => (value?.trim().length ?? 0) < 2
                    ? 'Isi nama minimal 2 karakter.'
                    : null,
              ),
              const SizedBox(height: 18),
              TextFormField(
                key: const Key('form-nim'),
                controller: _nim,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'NIM'),
                validator: (value) {
                  if (!RegExp(r'^\d{8,15}$').hasMatch(value?.trim() ?? '')) {
                    return 'NIM harus 8–15 angka.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              InputDecorator(
                decoration: const InputDecoration(labelText: 'UKM pilihan'),
                child: Row(
                  children: [
                    UkmLogo(ukm: widget.ukm, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.ukm.nama,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Icon(Icons.lock_outline, size: 16),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              TextFormField(
                key: const Key('form-alasan'),
                controller: _alasan,
                minLines: 4,
                maxLines: 7,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Alasan bergabung',
                  alignLabelWithHint: true,
                  hintText:
                      'Apa yang ingin kamu pelajari atau lakukan bersama?',
                ),
                validator: (value) => (value?.trim().length ?? 0) < 10
                    ? 'Ceritakan alasan minimal 10 karakter.'
                    : null,
              ),
              const SizedBox(height: 18),
              Text(
                'Minat disimpan di perangkat selama sesi aplikasi. Belum dikirim kepada pengurus UKM.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.6,
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                key: const Key('save-registration'),
                onPressed:
                    !_alreadyRegistered &&
                        (widget.ukm.bukaRekrutmen || widget.initial != null)
                    ? _save
                    : null,
                icon: const Icon(Icons.check),
                label: Text(
                  widget.initial == null ? 'Simpan minat' : 'Simpan perubahan',
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
