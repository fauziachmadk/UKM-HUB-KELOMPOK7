// Modul kartu. Penanggung jawab: Muhammad Azka Azkiya - 102022300166.
import 'package:flutter/material.dart';
import '../models/ukm.dart';
import 'hub_widgets.dart';

// BEGIN UKM07-AZKA-CARD
// MULAI BAGIAN AZKA.
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
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: cs.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(
                    color: cs.secondaryContainer,
                    child: Center(
                      child: Hero(
                        tag: 'ukm-${ukm.id}',
                        child: UkmLogo(ukm: ukm),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: RecruitmentBadge(open: ukm.bukaRekrutmen),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ukm.bidang.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    ukm.nama,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ukm.singkat,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 14,
                        color: cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${ukm.jumlahAnggota} anggota',
                          style: TextStyle(
                            fontSize: 10,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isRegistered) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Sudah terdaftar',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// END UKM07-AZKA-CARD - AZKA SAMPAI SINI.
