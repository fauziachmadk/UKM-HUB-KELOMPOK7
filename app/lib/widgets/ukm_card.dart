// Modul kartu. Penanggung jawab: Muhammad Azka Azkiya - 102022300166.
import 'package:flutter/material.dart';
import '../models/ukm.dart';
import 'hub_widgets.dart';

// BEGIN UKM07-AZKA-CARD
// MULAI BAGIAN AZKA.
// TODO(AZKA): kembangkan kartu custom dengan Row/Column/Expanded/Stack,
// Positioned untuk Open Recruitment, layout responsif, dan konteks terdaftar.
// Baseline sengaja sederhana; jangan menyatakan syarat kartu final sudah lengkap.
class UkmCard extends StatelessWidget {
  const UkmCard({
    super.key,
    required this.ukm,
    required this.onTap,
    this.isRegistered = false,
  });
  final Ukm ukm;
  final VoidCallback onTap;
  final bool isRegistered;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UkmLogo(ukm: ukm, size: 44),
            const SizedBox(height: 12),
            Text(
              ukm.nama,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              isRegistered ? 'Sudah terdaftar' : ukm.bidang,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    ),
  );
}
// END UKM07-AZKA-CARD - AZKA SAMPAI SINI.
