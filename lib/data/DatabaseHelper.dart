import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  // Database reference
  static Database? _database;

  // Getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'camp_registration.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE registrations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            age TEXT,
            gender TEXT,
            aadhar TEXT,
            parent TEXT,
            phone TEXT,
            address TEXT,
            complaint TEXT,
            photo_path TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE eye_checkups (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            patientId TEXT,
            withoutGlasses TEXT,
            withGlasses TEXT,
            withCorrection TEXT,
            remarks TEXT,
            complaint TEXT
          )
        ''');
      },
    );
  }

  // Insert a new registration
  Future<int> insertRegistration(Map<String, dynamic> registration) async {
    final db = await database;
    return await db.insert('registrations', registration);
  }

  // Retrieve all registrations
  Future<List<Map<String, dynamic>>> getRegistrations() async {
    final db = await database;
    return await db.query('registrations');
  }

  // Delete a registration by ID
  Future<int> deleteRegistration(int id) async {
    final db = await database;
    return await db.delete('registrations', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertEyeCheckup(Map<String, dynamic> checkupData) async {
    final db = await database;
    return await db.insert('eye_checkups', checkupData);
  }

  Future<List<Map<String, dynamic>>> getEyeCheckups() async {
    final db = await database;
    return await db.query('eye_checkups');
  }

  Future<int> deleteEyeCheckup(int id) async {
    final db = await database;
    return await db.delete('eye_checkups', where: 'id = ?', whereArgs: [id]);
  }
}
