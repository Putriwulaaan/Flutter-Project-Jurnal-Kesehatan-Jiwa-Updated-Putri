import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/journal_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return instance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'healthysync_main.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE journals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        conditionLevel INTEGER,
        location TEXT,
        createdAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE profile (
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        emergency_contact TEXT
      )
    ''');
  }

  // ======================
  // JOURNAL CRUD
  // ======================

  Future<int> insertJournal(JournalModel journal) async {
    final Database db = await database;
    return db.insert('journals', journal.toMap());
  }

  Future<List<JournalModel>> getJournals() async {
    final Database db = await database;
    final List<Map<String, Object?>> result =
        await db.query('journals', orderBy: 'id DESC');

    return result
        .map((Map<String, Object?> e) => JournalModel.fromMap(e))
        .toList();
  }

  Future<int> updateJournal(JournalModel journal) async {
    final Database db = await database;
    return db.update(
      'journals',
      journal.toMap(),
      where: 'id = ?',
      whereArgs: <int?>[journal.id],
    );
  }

  Future<int> deleteJournal(int id) async {
    final Database db = await database;
    return db.delete(
      'journals',
      where: 'id = ?',
      whereArgs: <int>[id],
    );
  }

  // ======================
  // PROFILE
  // ======================

  Future<Map<String, Object?>?> getProfile() async {
    final Database db = await database;
    final List<Map<String, Object?>> result =
        await db.query('profile', limit: 1);

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  Future<void> saveProfile(
    String name,
    String email,
    String contact,
  ) async {
    final Database db = await database;

    await db.insert(
      'profile',
      <String, Object?>{
        'id': 1,
        'name': name,
        'email': email,
        'emergency_contact': contact,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
