// Modul: Identitas sesi dan preferensi tema.
// Penanggung jawab: Fauzi Achmad Koesnaedi - 102022300352.
// Fondasi disediakan untuk integrasi; ownership bukan bukti kontribusi teman.
// BEGIN UKM07-FAUZI-PROFILE
// MULAI BAGIAN FAUZI.
// TODO(FAUZI): tinjau integrasi modul anggota, QA Android, dan bukti README final.
import 'package:flutter/material.dart';
import '../widgets/hub_widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.nama,
    required this.nim,
    required this.themeMode,
    required this.onThemeChanged,
    required this.onIdentity,
  });
  final String nama, nim;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final void Function(String, String) onIdentity;

  Future<void> _edit(BuildContext context) async {
    final identity = await showDialog<(String, String)>(
      context: context,
      builder: (_) => _IdentityDialog(nama: nama, nim: nim),
    );
    if (!context.mounted || identity == null) return;
    onIdentity(identity.$1, identity.$2);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Identitas sesi diperbarui.')));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ContentWidth(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Ruang kamu.',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Mulai kenalan, dengan caramu sendiri.',
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: cs.secondaryContainer,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: cs.primaryContainer,
                  child: Icon(
                    Icons.person_outline,
                    color: cs.onPrimaryContainer,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  nama.isEmpty ? 'Halo, teman kampus!' : nama,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(nim.isEmpty ? 'Identitas belum diisi' : 'NIM $nim'),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => _edit(context),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Ubah identitas'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Tampilan',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ThemeMode.values
                .map(
                  (mode) => ChoiceChip(
                    selected: themeMode == mode,
                    label: Text(switch (mode) {
                      ThemeMode.system => 'Sistem',
                      ThemeMode.light => 'Terang',
                      ThemeMode.dark => 'Gelap',
                    }),
                    onSelected: (_) => onThemeChanged(mode),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 28),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'UKM Hub',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Proyek UTS PAB • Kelompok 07\nKatalog unit kegiatan mahasiswa',
            style: TextStyle(color: cs.onSurfaceVariant, height: 1.7),
          ),
          const SizedBox(height: 20),
          Text(
            'Data UKM bersifat contoh. Identitas, preferensi, dan minat hanya tersimpan selama sesi ini. Tidak ada akun atau pengiriman ke pengurus.',
            style: TextStyle(
              fontSize: 12,
              color: cs.onSurfaceVariant,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _IdentityDialog extends StatefulWidget {
  const _IdentityDialog({required this.nama, required this.nim});
  final String nama, nim;
  @override
  State<_IdentityDialog> createState() => _IdentityDialogState();
}

class _IdentityDialogState extends State<_IdentityDialog> {
  final _form = GlobalKey<FormState>();
  late final _nama = TextEditingController(text: widget.nama);
  late final _nim = TextEditingController(text: widget.nim);
  @override
  void dispose() {
    _nama.dispose();
    _nim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Identitas kamu'),
    content: Form(
      key: _form,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nama,
              decoration: const InputDecoration(labelText: 'Nama'),
              textCapitalization: TextCapitalization.words,
              validator: (value) => (value?.trim().length ?? 0) < 2
                  ? 'Isi nama minimal 2 karakter.'
                  : null,
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _nim,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'NIM'),
              validator: (value) =>
                  RegExp(r'^\d{8,15}$').hasMatch(value?.trim() ?? '')
                  ? null
                  : 'NIM harus 8–15 angka.',
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Batal'),
      ),
      FilledButton(
        onPressed: () {
          if (_form.currentState!.validate()) {
            Navigator.pop(context, (_nama.text.trim(), _nim.text.trim()));
          }
        },
        child: const Text('Simpan'),
      ),
    ],
  );
}
// END UKM07-FAUZI-PROFILE - FAUZI SAMPAI SINI.
