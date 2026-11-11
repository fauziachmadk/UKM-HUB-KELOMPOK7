// Modul: Komponen visual bersama.
// Penanggung jawab: Fauzi Achmad Koesnaedi - 102022300352.
// Fondasi disediakan untuk integrasi; ownership bukan bukti kontribusi teman.
// BEGIN UKM07-FAUZI-COMPONENTS
// MULAI BAGIAN FAUZI.
// TODO(FAUZI): tinjau integrasi modul anggota, QA Android, dan bukti README final.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/ukm.dart';

class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    heightFactor: 1,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 820),
      child: child,
    ),
  );
}

class UkmLogo extends StatelessWidget {
  const UkmLogo({super.key, required this.ukm, this.size = 64});
  final Ukm ukm;
  final double size;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SvgPicture.asset(
      ukm.logo,
      width: size,
      height: size,
      semanticsLabel: 'Logo ${ukm.nama}',
      colorMapper: _LogoColors(cs),
      placeholderBuilder: (_) =>
          Icon(Icons.groups_outlined, size: size, color: cs.primary),
    );
  }
}

/// Memetakan dua tinta SVG ke token tema tanpa menghilangkan detail emblem.
class _LogoColors extends ColorMapper {
  const _LogoColors(this.scheme);
  final ColorScheme scheme;
  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) =>
      color.toARGB32() == 0xFF244B3D ? scheme.primary : scheme.primaryContainer;
  @override
  bool operator ==(Object other) =>
      other is _LogoColors && other.scheme == scheme;
  @override
  int get hashCode => scheme.hashCode;
}

class RecruitmentBadge extends StatelessWidget {
  const RecruitmentBadge({super.key, required this.open});
  final bool open;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: open ? cs.primaryContainer : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        open ? 'Open Recruitment' : 'Rekrutmen ditutup',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: open ? cs.onPrimaryContainer : cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

class HubMessage extends StatelessWidget {
  const HubMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });
  final IconData icon;
  final String title, message;
  final Widget? action;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 46, color: cs.primary),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onSurfaceVariant, height: 1.6),
          ),
          if (action != null) ...[const SizedBox(height: 20), action!],
        ],
      ),
    );
  }
}
// END UKM07-FAUZI-COMPONENTS - FAUZI SAMPAI SINI.
