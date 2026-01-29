import 'dart:convert';

class JournalModel {
  final int? id;
  final String title;
  final String description;
  final int conditionLevel;
  final String location;
  final String createdAt;

  const JournalModel({
    this.id,
    required this.title,
    required this.description,
    required this.conditionLevel,
    required this.location,
    required this.createdAt,
  });

  /// ===============================
  /// KONVERSI OBJECT → MAP (Untuk Simpan ke SQLite)
  /// ===============================
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'conditionLevel': conditionLevel,
      'location': location,
      'createdAt': createdAt,
    };
  }

  /// ===============================
  /// KONVERSI MAP → OBJECT (Dari SQLite ke App)
  /// ===============================
  factory JournalModel.fromMap(Map<String, dynamic> map) {
    return JournalModel(
      // Menggunakan 'as' secara eksplisit setelah pengecekan null safety
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      // Memastikan conditionLevel selalu memiliki fallback yang masuk akal
      conditionLevel: (map['conditionLevel'] is int) 
          ? map['conditionLevel'] as int 
          : int.tryParse(map['conditionLevel']?.toString() ?? '1') ?? 1,
      location: map['location']?.toString() ?? 'Tidak Ada Lokasi',
      createdAt: map['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }

  /// ===============================
  /// HELPER UNTUK JSON (Opsional, berguna untuk debug/API)
  /// ===============================
  String toJson() => json.encode(toMap());
  factory JournalModel.fromJson(String source) => 
      JournalModel.fromMap(json.decode(source) as Map<String, dynamic>);

  /// ===============================
  /// COPYWITH (Digunakan saat Edit Data)
  /// ===============================
  JournalModel copyWith({
    int? id,
    String? title,
    String? description,
    int? conditionLevel,
    String? location,
    String? createdAt,
  }) {
    return JournalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      conditionLevel: conditionLevel ?? this.conditionLevel,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// ===============================
  /// OVERRIDE TOSTRING (Sangat berguna untuk Debugging)
  /// ===============================
  @override
  String toString() {
    return 'JournalModel(id: $id, title: $title, conditionLevel: $conditionLevel)';
  }
}