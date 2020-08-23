import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_coffee_count/model/caffeineModel.dart';

class DatabaseHelper {

  static DatabaseHelper _databasehelper;
  static Database _database;

  String caffeineTable = 'caffeine_table';
  String colId = 'id';
  String colCaffeine = 'caffeine';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {

    if (_databasehelper == null) {
      _databasehelper = DatabaseHelper._createInstance();
    }
    return _databasehelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'caffeine.db';

    // Open/create the database at a given path
    var caffeinesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return caffeinesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $caffeineTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colCaffeine TEXT, '
        '$colDate TEXT)');
  }
  
  // Fetch Operation: Get all objects from database
  Future<List<Map<String, dynamic>>> getCaffeineMapList() async {
    Database db = await this.database;

    var result = await db.query(caffeineTable);
    return result;
  }

  // Insert Operation: Insert an object to database
	Future<int> insertCaffeine(CaffeineModel caffeineModel) async {
		Database db = await this.database;
		var result = await db.insert(caffeineTable, caffeineModel.toMap());
		return result;
	}

  // Update Operation: Update an object and save it to database
	Future<int> updateCaffeine(CaffeineModel caffeineModel) async {
		var db = await this.database;
		var result = await db.update(caffeineTable, caffeineModel.toMap(), where: '$colId = ?', whereArgs: [caffeineModel.id]);
		return result;
	}

  // Delete Operation: Delete an object from database
	Future<int> deleteCaffeine(int id) async {
		var db = await this.database;
		int result = await db.rawDelete('DELETE FROM $caffeineTable WHERE $colId = $id');
		return result;
	}

  // Get number of objects in database
	Future<int> getCount() async {
		Database db = await this.database;
		List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $caffeineTable');
		int result = Sqflite.firstIntValue(x);
		return result;
	}

  // Get the 'Map List' [ List<Map> ] and convert it to 'caffeine List' [ List<CaffeineModel> ]
	Future<List<CaffeineModel>> getCaffeineList() async {

		var caffeineMapList = await getCaffeineMapList(); // Get 'Map List' from database
		int count = caffeineMapList.length;         // Count the number of map entries in db table

		List<CaffeineModel> caffeineList = List<CaffeineModel>();
		// For loop to create a 'caffeine List' from a 'Map List'
		for (int i = 0; i < count; i++) {
			caffeineList.add(CaffeineModel.fromMapObject(caffeineMapList[i]));
		}

		return caffeineList;
	}


}
