// Modul: Model minat dan aturan duplikat, dikonfirmasi Vanesa.
// Penanggung jawab: Fauzi Achmad Koesnaedi - 102022300352.
// Fondasi disediakan untuk integrasi; ownership bukan bukti kontribusi teman.
// BEGIN UKM07-FAUZI-REGISTRATION-CONTRACT
// MULAI BAGIAN FAUZI.
// TODO(FAUZI): tinjau integrasi modul anggota, QA Android, dan bukti README final.
import 'ukm.dart';

/// Minat tersimpan di memori sesi, bukan pengajuan resmi kepada pengurus.
class Pendaftaran {
  const Pendaftaran({
    required this.nama,
    required this.nim,
    required this.ukm,
    required this.alasan,
    required this.tanggal,
  });
  final String nama, nim, alasan;
  final Ukm ukm;
  final DateTime tanggal;

  String get tanggalLabel =>
      '${tanggal.day.toString().padLeft(2, '0')}/'
      '${tanggal.month.toString().padLeft(2, '0')}/${tanggal.year}';
}

/// Satu sesi mewakili satu pengguna. Mengganti NIM tidak membuka pendaftaran
/// kedua pada UKM yang sama; objek sendiri dikecualikan ketika sedang diubah.
bool hasRegistrationForUkm(
  Iterable<Pendaftaran> registrations,
  String ukmId, {
  Pendaftaran? except,
}) => registrations.any(
  (item) => !identical(item, except) && item.ukm.id == ukmId,
);
// END UKM07-FAUZI-REGISTRATION-CONTRACT - FAUZI SAMPAI SINI.
