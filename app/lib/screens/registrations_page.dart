// Modul daftar. Penanggung jawab: Vanesa Rizka Alfatihah - 102022300121.
import 'package:flutter/material.dart';
import '../models/pendaftaran.dart';
import '../widgets/hub_widgets.dart';

// BEGIN UKM07-VANESA-LIST
// MULAI BAGIAN VANESA.
// TODO(VANESA): kartu ringkasan dengan nama/NIM/alasan/tanggal, aksi ubah/hapus,
// empty state yang baik dan tampilan responsif; gunakan callback yang tersedia.
// Fauzi sudah menyediakan state edit/hapus/undo di MainPage. Jangan duplikasi.
class RegistrationsPage extends StatelessWidget {
  const RegistrationsPage({
    super.key,
    required this.items,
    required this.onExplore,
    required this.onEdit,
    required this.onDelete,
  });
  final List<Pendaftaran> items;
  final VoidCallback onExplore;
  final ValueChanged<Pendaftaran> onEdit, onDelete;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Pendaftaran Saya')),
    body: ContentWidth(
      child: items.isEmpty
          ? HubMessage(
              icon: Icons.assignment_outlined,
              title: 'Belum ada minat',
              message: 'Pilih UKM untuk mulai menyimpan minat di sesi ini.',
              action: OutlinedButton(
                onPressed: onExplore,
                child: const Text('Jelajahi UKM'),
              ),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.ukm.nama),
                  subtitle: Text('${item.nama} - ${item.nim}'),
                );
              },
            ),
    ),
  );
}
// END UKM07-VANESA-LIST - VANESA SAMPAI SINI.
