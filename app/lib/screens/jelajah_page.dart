// Modul Jelajah. Penanggung jawab: Muhammad Azka Azkiya - 102022300166.
import 'package:flutter/material.dart';
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
  final VoidCallback onProfile, onToggleTheme;
  final Set<String> registeredIds;
  @override
  State<JelajahPage> createState() => _JelajahPageState();
}

class _JelajahPageState extends State<JelajahPage> {
  late Future<List<Ukm>> _catalog = widget.api.getUkm();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('UKM Hub'),
      actions: [
        IconButton(
          tooltip: 'Ganti tema',
          onPressed: widget.onToggleTheme,
          icon: const Icon(Icons.brightness_6_outlined),
        ),
        IconButton(
          tooltip: 'Buka profil',
          onPressed: widget.onProfile,
          icon: const Icon(Icons.person_outline),
        ),
      ],
    ),
    body: ContentWidth(
      child: FutureBuilder<List<Ukm>>(
        future: _catalog,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return HubMessage(
              icon: Icons.cloud_off_outlined,
              title: 'Katalog belum tersedia',
              message: '${snapshot.error}',
              action: FilledButton(
                onPressed: () => setState(() {
                  // Callback setState sinkron; jangan mengembalikan Future.
                  _catalog = widget.api.getUkm();
                }),
                child: const Text('Coba lagi'),
              ),
            );
          }
          final items = snapshot.data ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('${items.length} UKM - katalog dasar'),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 260,
                    mainAxisExtent: 200,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) => UkmCard(
                    ukm: items[index],
                    isRegistered: widget.registeredIds.contains(
                      items[index].id,
                    ),
                    onTap: () => widget.onOpen(items[index]),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
// END UKM07-AZKA-EXPLORE - AZKA SAMPAI SINI.
