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
            token TEXT UNIQUE,
            name TEXT,
            age INTEGER,
            gender TEXT,
            aadhar TEXT,
            parent TEXT,
            phone TEXT,
            address TEXT,
            photo TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE eye_checkups (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            patientToken TEXT UNIQUE,
            date TEXT,

            -- Vision tests stored as JSON
            withoutGlasses TEXT,
            withGlasses TEXT,
            withCorrection TEXT,

            -- Near Vision stored as JSON
            nearVision TEXT,

            -- Additional info
            bifocal TEXT,
            color TEXT,
            remarks TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE examinations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            patientToken TEXT UNIQUE,
            date TEXT,

            -- Vision Test stored as JSON
            visionTest TEXT,

            -- Complaints stored as JSON
            complaints TEXT,

            -- Comorbidities stored as JSON
            comorbidities TEXT,

            -- Eye Examination stored as JSON
            examFindings TEXT,

            -- Workup stored as JSON
            workup TEXT,

            -- Dilated Eye Findings stored as JSON
            dilatedFindings TEXT,

            -- Diagnosis stored as JSON
            diagnosis TEXT,

            -- Pre-Surgery Plan stored as JSON
            preSurgeryPlan TEXT
          )
        ''');
      },
    );
  }

  // Insert a new registration
  Future<int> insertRegistration(Map<String, dynamic> registration) async {
    final db = await database;
    return await db.insert('registrations', registration, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getRegistrations() async {
    final db = await database;
    return await db.query('registrations');
  }

  Future<int> insertEyeCheckup(Map<String, dynamic> checkupData) async {
    final db = await database;
    return await db.insert('eye_checkups', checkupData, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getEyeCheckups() async {
    final db = await database;
    return await db.query('eye_checkups', orderBy: "date DESC");
  }

  Future<void> clearEyeCheckups() async {
    final db = await database;
    await db.delete('eye_checkups');
  }

  Future<int> insertExamination(Map<String, dynamic> examinationData) async {
    final db = await database;
    return await db.insert('examinations', examinationData, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getExaminations() async {
    final db = await database;
    return await db.query('examinations', orderBy: "date DESC");
  }

  Future<void> clearExamination() async {
    final db = await database;
    await db.delete('examinations');
  }
}
