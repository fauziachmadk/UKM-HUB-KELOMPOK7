// Modul: Model bersama, kontrak JSON dikonfirmasi Djalil.
// Penanggung jawab: Fauzi Achmad Koesnaedi - 102022300352.
// Fondasi disediakan untuk integrasi; ownership bukan bukti kontribusi teman.
// BEGIN UKM07-FAUZI-UKM-CONTRACT
// MULAI BAGIAN FAUZI.
// TODO(FAUZI): tinjau integrasi modul anggota, QA Android, dan bukti README final.
/// Data katalog immutable; tanggal ISO di API menjadi DateTime di aplikasi.
class Ukm {
  const Ukm({
    required this.id,
    required this.nama,
    required this.bidang,
    required this.ketua,
    required this.jumlahAnggota,
    required this.bukaRekrutmen,
    required this.berdiri,
    required this.logo,
    this.deskripsi,
    this.singkat = '',
    this.kegiatan = const [],
  });

  final String id, nama, bidang, ketua, logo, singkat;
  final int jumlahAnggota;
  final bool bukaRekrutmen;
  final DateTime berdiri;
  final String? deskripsi;
  final List<String> kegiatan;

  static const bidangList = [
    'Olahraga',
    'Seni',
    'Teknologi',
    'Keagamaan',
    'Sosial',
  ];

  factory Ukm.fromJson(Map<String, dynamic> json) => Ukm(
    id: json['id'] as String,
    nama: json['nama'] as String,
    bidang: json['bidang'] as String,
    ketua: json['ketua'] as String,
    jumlahAnggota: json['jumlahAnggota'] as int,
    bukaRekrutmen: json['bukaRekrutmen'] as bool,
    berdiri: DateTime.parse(json['berdiri'] as String),
    logo: json['logo'] as String,
    deskripsi: json['deskripsi'] as String?,
    singkat: json['singkat'] as String? ?? '',
    kegiatan: List<String>.unmodifiable(json['kegiatan'] as List? ?? []),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nama': nama,
    'bidang': bidang,
    'ketua': ketua,
    'jumlahAnggota': jumlahAnggota,
    'bukaRekrutmen': bukaRekrutmen,
    'berdiri': berdiri.toIso8601String(),
    'logo': logo,
    'deskripsi': deskripsi,
    'singkat': singkat,
    'kegiatan': kegiatan,
  };
}
