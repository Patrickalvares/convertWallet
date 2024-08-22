import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../entities/currency_by_currency.dart';
import '../../entities/currencys.dart';
import '../../entities/walleted_currency.dart';
import '../../../utils/helpers/log.dart';

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
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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

    await db.execute('''
    CREATE TABLE selected_currency(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      currency_code TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE walleted_currency(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      currency_code TEXT,
      amount REAL
    )
  ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      CREATE TABLE walleted_currency(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        currency_code TEXT,
        amount REAL
      )
    ''');
    }
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

  Future<void> saveSelectedCurrency(Currency currency) async {
    final db = await database;

    await db.delete('selected_currency');

    await db.insert(
      'selected_currency',
      {'currency_code': currency.code},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Currency?> getSelectedCurrency() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('selected_currency');
    if (result.isNotEmpty) {
      final currencyCode = result.first['currency_code'] as String;
      final currency = Currency.fromCode(currencyCode);
      if (currency != null) {
        return currency;
      } else {
        return Currency.BRL;
      }
    }
    return null;
  }

  Future<void> insertWalletedCurrency(WalletedCurrency walletedCurrency) async {
    final db = await database;

    Log.print('Inserindo na tabela walleted_currency: ${walletedCurrency.toMap()}');
    await db.insert(
      'walleted_currency',
      walletedCurrency.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<WalletedCurrency>> getWalletedCurrencies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('walleted_currency');

    return List.generate(maps.length, (i) {
      return WalletedCurrency(
        currency: Currency.fromCode(maps[i]['currency_code'])!,
        amount: maps[i]['amount'],
      );
    });
  }

  Future<WalletedCurrency?> getWalletedCurrencyByCode(String code) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'walleted_currency',
      where: 'currency_code = ?',
      whereArgs: [code],
    );

    if (maps.isNotEmpty) {
      return WalletedCurrency(
        currency: Currency.fromCode(maps.first['currency_code'])!,
        amount: maps.first['amount'],
      );
    }
    return null;
  }

  Future<void> updateWalletedCurrency(WalletedCurrency walletedCurrency) async {
    final db = await database;

    Log.print('Atualizando na tabela walleted_currency: ${walletedCurrency.toMap()}');
    await db.update(
      'walleted_currency',
      walletedCurrency.toMap(),
      where: 'currency_code = ?',
      whereArgs: [walletedCurrency.currency.code],
    );
  }

  Future<void> deleteWalletedCurrency(String code) async {
    final db = await database;
    await db.delete(
      'walleted_currency',
      where: 'currency_code = ?',
      whereArgs: [code],
    );
  }
}
