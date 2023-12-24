import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  Database? database;

  Future<Database> get sqDatabase async {
    if (database != null) {
      return database!;
    }
    database = await initialize();
    return database!;
  }

  Future<String> get fullPath async {
    const name = 'todo.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> initialize() async {
    final path = await fullPath;
    final base = await openDatabase(path,
        version: 1, onCreate: create, singleInstance: true);
    return base;
  }

  Future<void> create(Database db, int version) async {
    return await createTable(db);
  }

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS todos (
      "id" INTEGER NOT NULL,
      "title" TEXT NOT NULL,
      "description" TEXT NOT NULL,
      "is_completed" INTEGER NOT NULL,
      "created_at" Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
      "updated_at" Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY("id" AUTOINCREMENT)
    )""");
  }
}
