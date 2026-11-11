// Modul Jelajah. Penanggung jawab: Muhammad Azka Azkiya - 102022300166.
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/ukm.dart';
import '../services/api_service.dart';
import '../widgets/hub_widgets.dart';
import '../widgets/ukm_card.dart';

// BEGIN UKM07-AZKA-EXPLORE
// MULAI BAGIAN AZKA. Signature ini sudah digunakan MainPage milik Fauzi.
// TODO(AZKA): ChoiceChip 5 bidang + semua dengan request server; pencarian
// nama lokal beserta dispose controller; hasil kosong; grid adaptif layar sempit;
// tata letak setara acuan DEV. RefreshIndicator/Hero setelah fitur wajib.
class JelajahPage extends StatefulWidget {
  const JelajahPage({
    super.key,
    required this.api,
    required this.onOpen,
    required this.onProfile,
    required this.onToggleTheme,
    this.registeredIds = const {},
  });
  final ApiService api;
  final ValueChanged<Ukm> onOpen;
  final VoidCallback onProfile;
  final VoidCallback onToggleTheme;
  final Set<String> registeredIds;
  @override
  State<JelajahPage> createState() => _JelajahPageState();
}

class _JelajahPageState extends State<JelajahPage> {
  final _search = TextEditingController();
  String? _bidang;
  late Future<List<Ukm>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.api.getUkm();
    _search.addListener(_searchChanged);
  }

  void _searchChanged() => setState(() {});
  @override
  void dispose() {
    _search.removeListener(_searchChanged);
    _search.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final request = widget.api.getUkm(bidang: _bidang);
    setState(() {
      _future = request;
    });
    // Error tetap ditampilkan FutureBuilder; refresh gesture boleh selesai.
    try {
      await request;
    } on ApiException {
      /* Ditangani di tampilan gagal. */
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ContentWidth(
      child: RefreshIndicator(
        onRefresh: _reload,
        child: CustomScrollView(
          key: const PageStorageKey('jelajah-scroll'),
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/launcher.png',
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(width: 9),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'UKM Hub',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                          ),
                          Text(
                            'Temukan komunitas kampusmu',
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      key: const Key('theme-toggle'),
                      onPressed: widget.onToggleTheme,
                      tooltip: Theme.of(context).brightness == Brightness.dark
                          ? 'Aktifkan tema terang'
                          : 'Aktifkan tema gelap',
                      icon: Icon(
                        Theme.of(context).brightness == Brightness.dark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: widget.onProfile,
                      tooltip: 'Buka profil',
                      icon: const Icon(Icons.person_outline),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '•  BANYAK MINAT. SATU TEMPAT.',
                            style: TextStyle(
                              fontSize: 9,
                              letterSpacing: 1.3,
                              fontWeight: FontWeight.w700,
                              color: cs.primaryContainer,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Ada tempat buat',
                            style: TextStyle(
                              fontSize: 26,
                              height: 1.2,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -1.2,
                              color: cs.onPrimary,
                            ),
                          ),
                          Text(
                            'versi seru kamu.',
                            style: TextStyle(
                              fontSize: 26,
                              height: 1.2,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -1.2,
                              color: cs.primaryContainer,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Jelajahi UKM. Temukan teman satu frekuensi.',
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.6,
                              color: cs.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ExcludeSemantics(
                      child: SvgPicture.asset(
                        'assets/images/hub-mark.svg',
                        width: 48,
                        height: 48,
                        colorFilter: ColorFilter.mode(
                          cs.primaryContainer,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
                child: TextField(
                  key: const Key('search-ukm'),
                  controller: _search,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Cari nama UKM...',
                    prefixIcon: const Icon(Icons.search, size: 21),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus pencarian',
                            onPressed: _search.clear,
                            icon: const Icon(Icons.close),
                          ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [null, ...Ukm.bidangList]
                      .map(
                        (bidang) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(bidang ?? 'Semua'),
                            selected: _bidang == bidang,
                            onSelected: (_) {
                              // Filter bidang wajib diproses server.
                            setState(() => _bidang = bidang);
                              _reload();
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            FutureBuilder<List<Ukm>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(48),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Memuat komunitas...'),
                        ],
                      ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: HubMessage(
                      icon: Icons.wifi_off_outlined,
                      title: 'Katalog belum tersedia',
                      message: snapshot.error.toString(),
                      action: FilledButton.icon(
                        onPressed: _reload,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba lagi'),
                      ),
                    ),
                  );
                }
                // Pencarian nama hanya menyaring hasil yang sudah diterima.
                final query = _search.text.trim().toLowerCase();
                final items = snapshot.data!
                    .where((ukm) => ukm.nama.toLowerCase().contains(query))
                    .toList();
                return SliverMainAxisGroup(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 14, 12, 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Temukan komunitasmu',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${items.length} UKM untuk dijelajahi',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: _reload,
                              tooltip: 'Muat ulang katalog',
                              icon: const Icon(Icons.refresh),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (items.isEmpty)
                      SliverToBoxAdapter(
                        child: HubMessage(
                          icon: Icons.search_off,
                          title: 'Belum ada yang cocok',
                          message:
                              'Coba nama lain atau pilih bidang yang berbeda.',
                          action: OutlinedButton(
                            onPressed: () {
                              _search.clear();
                              setState(() => _bidang = null);
                              _reload();
                            },
                            child: const Text('Reset pencarian'),
                          ),
                        ),
                      )
                    else
                      SliverToBoxAdapter(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final columns = constraints.maxWidth < 320
                                ? 1
                                : constraints.maxWidth > 680
                                ? 3
                                : 2;
                            final scale = MediaQuery.textScalerOf(
                              context,
                            ).scale(1);
                            return GridView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                              shrinkWrap: true,
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    mainAxisExtent:
                                        254 + math.max(0, scale - 1) * 110,
                                  ),
                              itemBuilder: (context, index) => UkmCard(
                                ukm: items[index],
                                isRegistered: widget.registeredIds.contains(
                                  items[index].id,
                                ),
                                onTap: () => widget.onOpen(items[index]),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
// END UKM07-AZKA-EXPLORE - AZKA SAMPAI SINI.
