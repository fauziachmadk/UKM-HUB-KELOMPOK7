// Modul daftar. Penanggung jawab: Vanesa Rizka Alfatihah - 102022300121.
import 'package:flutter/material.dart';
import '../models/pendaftaran.dart';
import '../widgets/hub_widgets.dart';

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
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ContentWidth(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Pendaftaran\nSaya',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Satu langkah lebih dekat dengan komunitasmu.',
            style: TextStyle(color: cs.onSurfaceVariant, height: 1.6),
          ),
          const SizedBox(height: 24),
          if (items.isEmpty)
            HubMessage(
              icon: Icons.assignment_outlined,
              title: 'Cerita kamu dimulai di sini',
              message:
                  'Belum ada minat bergabung. Temukan UKM yang bikin kamu penasaran.',
              action: FilledButton(
                onPressed: onExplore,
                child: const Text('Jelajahi UKM'),
              ),
            )
          else ...[
            Text(
              '${items.length} minat tersimpan • hanya sesi ini',
              style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
            ),
            const SizedBox(height: 16),
            ...items.map(
              (record) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLow,
                  border: Border.all(color: cs.outlineVariant),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        UkmLogo(ukm: record.ukm, size: 40),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record.ukm.bidang.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: cs.onSurfaceVariant,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                record.ukm.nama,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      record.nama,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'NIM ${record.nim}',
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(record.alasan, style: const TextStyle(height: 1.6)),
                    const SizedBox(height: 14),
                    Text(
                      'Disimpan ${record.tanggalLabel}',
                      style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => onEdit(record),
                          icon: const Icon(Icons.edit_outlined, size: 17),
                          label: const Text('Ubah'),
                        ),
                        TextButton.icon(
                          onPressed: () => onDelete(record),
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Hapus'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
