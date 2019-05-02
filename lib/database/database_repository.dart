import 'dart:core';
import 'dart:io';
import 'package:panda_power/models/game_state.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

//table and column names
final String gameStateTable = 'gameState';
final String pandaNameColumn = 'pandaName';
final String userNameColumn = 'userName';
final String columnId = '_id';
final String isDemoColumn = 'isDemo';
final String pandaStateColumn = 'pandaState';
final String powerBarValueColumn = 'powerBarValue';
final String powerBarGoalValueColumn = 'powerBarGoalValue';

class DatabaseRepository {

  static final _databaseName = 'PandaDatabase.db';
  static final _databaseVersion = 1;

  DatabaseRepository._privateConstructor();

  static final DatabaseRepository instance = DatabaseRepository._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    print('creating database');
    await db.execute('''
      CREATE TABLE $gameStateTable (
        $columnId INTEGER PRIMARY KEY,
        $pandaNameColumn TEXT NOT NULL,
        $userNameColumn TEXT NOT NULL,
        $isDemoColumn INTEGER NOT NULL,
        $pandaStateColumn TEXT NOT NULL,
        $powerBarValueColumn REAL NOT NULL,
        $powerBarGoalValueColumn REAL NOT NULL
      )
    '''
    );
  }

  Future<int> deleteGame(int id) async {
    Database db = await database;
    int deleted = await db.delete(gameStateTable,
    where: '$columnId = ?',
    whereArgs: [id]);

    return deleted;
  }

  Future<GameState> queryState(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(gameStateTable,
      columns: [columnId, pandaNameColumn, userNameColumn, isDemoColumn, pandaStateColumn, powerBarValueColumn, powerBarGoalValueColumn],
      where: '$columnId = ?',
      whereArgs: [id]
    );
    if (maps.length > 0) {
      return GameState.fromMap(maps.first);
    }
    return null;
  }

  Future<int> saveState(GameState state) async {
    Database db = await database;
    int id = await db.insert(gameStateTable, state.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return id;

  }

}