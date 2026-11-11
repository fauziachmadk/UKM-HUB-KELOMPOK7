// Modul: Root client dan ThemeMode.
// Penanggung jawab: Fauzi Achmad Koesnaedi - 102022300352.
// Fondasi disediakan untuk integrasi; ownership bukan bukti kontribusi teman.
// BEGIN UKM07-FAUZI-APP
// MULAI BAGIAN FAUZI.
// TODO(FAUZI): tinjau integrasi modul anggota, QA Android, dan bukti README final.
import 'package:flutter/material.dart';
import '../screens/main_page.dart';
import '../services/api_service.dart';
import 'theme.dart';

class UkmHubApp extends StatefulWidget {
  const UkmHubApp({super.key, this.api});
  final ApiService? api;
  @override
  State<UkmHubApp> createState() => _UkmHubAppState();
}

class _UkmHubAppState extends State<UkmHubApp> {
  late final ApiService _api = widget.api ?? ApiService();
  ThemeMode _themeMode = ThemeMode.system;
  @override
  void dispose() {
    if (widget.api == null) _api.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'UKM Hub',
    debugShowCheckedModeBanner: false,
    theme: HubTheme.create(Brightness.light),
    darkTheme: HubTheme.create(Brightness.dark),
    themeMode: _themeMode,
    home: MainPage(
      api: _api,
      themeMode: _themeMode,
      onThemeChanged: (mode) => setState(() => _themeMode = mode),
    ),
  );
}
// END UKM07-FAUZI-APP - FAUZI SAMPAI SINI.
