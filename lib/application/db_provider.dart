import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/presentation/database/database_service.dart';

final dbfProvider = FutureProvider<Database>((ref) async {
  final database = await DatabaseService().sqDatabase;
  return database;
});
