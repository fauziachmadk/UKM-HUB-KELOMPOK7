// Modul: State, tab, hasil navigasi, edit/hapus/undo.
// Penanggung jawab: Fauzi Achmad Koesnaedi - 102022300352.
// Fondasi disediakan untuk integrasi; ownership bukan bukti kontribusi teman.
// BEGIN UKM07-FAUZI-INTEGRATION
// MULAI BAGIAN FAUZI.
// TODO(FAUZI): tinjau integrasi modul anggota, QA Android, dan bukti README final.
import 'package:flutter/material.dart';
import '../models/pendaftaran.dart';
import '../models/ukm.dart';
import '../services/api_service.dart';
import 'detail_page.dart';
import 'jelajah_page.dart';
import 'profile_page.dart';
import 'registration_form.dart';
import 'registrations_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
    required this.api,
    required this.themeMode,
    required this.onThemeChanged,
  });
  final ApiService api;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _tab = 0;
  final List<Pendaftaran> _registrations = [];
  String _nama = '', _nim = '';

  Future<void> _openUkm(Ukm ukm) async {
    final record = await Navigator.push<Pendaftaran>(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPage(
          ukm: ukm,
          registrations: List.unmodifiable(_registrations),
          namaAwal: _nama,
          nimAwal: _nim,
        ),
      ),
    );
    if (!mounted || record == null) return;
    // Induk memeriksa ulang hasil async agar satu UKM hanya punya satu minat.
    if (hasRegistrationForUkm(_registrations, record.ukm.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamu sudah terdaftar di UKM ini.')),
      );
      return;
    }
    setState(() {
      _registrations.insert(0, record);
      _tab = 1;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Minat berhasil disimpan.')));
  }

  Future<void> _edit(Pendaftaran old) async {
    final updated = await Navigator.push<Pendaftaran>(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrationForm(
          ukm: old.ukm,
          initial: old,
          registrations: List.unmodifiable(_registrations),
        ),
      ),
    );
    if (!mounted || updated == null) return;
    final index = _registrations.indexOf(old);
    if (index < 0) return;
    setState(() => _registrations[index] = updated);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Minat diperbarui.')));
  }

  Future<void> _delete(Pendaftaran record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus minat ini?'),
        content: Text(
          'Minat untuk ${record.ukm.nama} akan dihapus dari sesi ini.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    final index = _registrations.indexOf(record);
    setState(() => _registrations.remove(record));
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: const Text('Minat dihapus.'),
          action: SnackBarAction(
            label: 'Urungkan',
            onPressed: () {
              if (!mounted ||
                  hasRegistrationForUkm(_registrations, record.ukm.id)) {
                return;
              }
              setState(
                () => _registrations.insert(
                  index.clamp(0, _registrations.length),
                  record,
                ),
              );
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: IndexedStack(
        index: _tab,
        children: [
          JelajahPage(
            api: widget.api,
            onOpen: _openUkm,
            onProfile: () => setState(() => _tab = 2),
            registeredIds: _registrations.map((item) => item.ukm.id).toSet(),
            onToggleTheme: () => widget.onThemeChanged(
              Theme.of(context).brightness == Brightness.dark
                  ? ThemeMode.light
                  : ThemeMode.dark,
            ),
          ),
          RegistrationsPage(
            items: _registrations,
            onExplore: () => setState(() => _tab = 0),
            onEdit: _edit,
            onDelete: _delete,
          ),
          ProfilePage(
            nama: _nama,
            nim: _nim,
            themeMode: widget.themeMode,
            onThemeChanged: widget.onThemeChanged,
            onIdentity: (nama, nim) => setState(() {
              _nama = nama;
              _nim = nim;
            }),
          ),
        ],
      ),
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _tab,
      onDestinationSelected: (index) => setState(() => _tab = index),
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore),
          label: 'Jelajah',
        ),
        NavigationDestination(
          icon: Badge(
            isLabelVisible: _registrations.isNotEmpty,
            label: Text('${_registrations.length}'),
            child: const Icon(Icons.assignment_outlined),
          ),
          selectedIcon: const Icon(Icons.assignment),
          label: 'Pendaftaran Saya',
        ),
        const NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    ),
  );
}
// END UKM07-FAUZI-INTEGRATION - FAUZI SAMPAI SINI.
