import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../core/entities/currency_by_currency.dart';

class DatabaseHelper {
  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'currencies.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE currency_by_currency(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT,
        standardByTargetValue REAL,
        targetByStandardRate REAL,
        targetCurrencyCode TEXT
      )
    ''');
  }

  Future<void> insertCurrencyByCurrency(CurrencyByCurrency currency) async {
    final db = await database;
    await db.insert(
      'currency_by_currency',
      currency.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CurrencyByCurrency>> getCurrencyByCurrencies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('currency_by_currency');
    return List.generate(maps.length, (i) {
      return CurrencyByCurrency.fromMap(maps[i]);
    });
  }

  Future<void> clearCurrencyByCurrencies() async {
    final db = await database;
    await db.delete('currency_by_currency');
  }
}
