import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/Spending_model.dart';
import '../../models/category_model_class.dart';

class ApiHelperClass {
  ApiHelperClass._();
  static ApiHelperClass apiHelperClass = ApiHelperClass._();

  Database? db;

  Future<void> initDB() async {
    String directoryPath = await getDatabasesPath();
    String path = join(directoryPath, "BudgetDataTracker.db");

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        String query =
            "CREATE TABLE IF NOT EXISTS categories(category_id INTEGER PRIMARY KEY AUTOINCREMENT,category_name TEXT NOT NULL,category_image BLOB);";
        await db.execute(query);
        log("========================");
        log("message_doneCat");
        log("========================");

        String spendingQuery =
            "CREATE TABLE IF NOT EXISTS spending(spending_id INTEGER PRIMARY KEY AUTOINCREMENT,spending_amount NUMERIC NOT NULL, spending_type TEXT NOT NULL,spending_category INTEGER NOT NULL);";
        await db.execute(spendingQuery);
        log("========================");
        log("message_doneSpen");
        log("========================");
      },
    );
  }

  Future<int> insertCategories({required CategoryModelClass category}) async {
    if (db == null) {
      await initDB();
    }
    String query =
        "INSERT INTO categories(category_name, category_image) VALUES(?, ?);";
    List args = [category.name, category.image];

    int? id = await db?.rawInsert(query, args);

    return id!;
  }

  Future<List<CategoryModelClass>> fetchCategories() async {
    if (db == null) {
      await initDB();
    }

    String query = "SELECT * FROM categories;";

    List<Map<String, dynamic>> allRecords = await db!.rawQuery(query);

    List<CategoryModelClass> allCategories =
        allRecords.map((e) => CategoryModelClass.fromMap(data: e)).toList();
    return allCategories;
  }

  Future<int> updateCategories(
      {required CategoryModelClass category, required int id}) async {
    if (db == null) {
      await initDB();
    }

    String query =
        "UPDATE categories SET category_name=? , category_image=? WHERE category_id=?;";

    List args = [category.name, category.image, id];

    int res = await db!.rawUpdate(query, args);
    return res;
  }

  Future<int> deleteCategory({required int id}) async {
    if (db == null) {
      await initDB();
    }

    String query = "DELETE FROM categories WHERE category_id=?;";
    List args = [id];

    int res = await db!.rawDelete(query, args);

    return res;
  }

  deleteAllCategories() async {
    if (db == null) {
      await initDB();
    }

    String query = "DELETE FROM categories;";
    int res = await db!.rawDelete(query);
    return res;
  }

  Future<List<CategoryModelClass>> searchCategories(
      {required String data}) async {
    if (db == null) {
      await initDB();
    }
    String query =
        "SELECT * FROM categories WHERE category_name LIKE '%$data%';";

    List<Map<String, dynamic>> searchCategoriesRecords =
        await db!.rawQuery(query);

    List<CategoryModelClass> searchCategories = searchCategoriesRecords
        .map((e) => CategoryModelClass.fromMap(data: e))
        .toList();
    return searchCategories;
  }

  Future<int> insertSpending({required SpendingModel spending}) async {
    if (db == null) {
      await initDB();
    }
    String query = ""
        "INSERT INTO spending (spending_amount, spending_type, spending_category) VALUES (?, ?, ?);";

    List args = [
      spending.spending_amount,
      spending.spending_type,
      spending.spending_category,
    ];
    int res = await db!.rawInsert(query, args);

    return res;
  }

  Future<List<SpendingModel>> fetchSpending() async {
    if (db == null) {
      await initDB();
    }
    String query = "SELECT * FROM spending;";

    List<Map<String, dynamic>> allRecords = await db!.rawQuery(query);

    List<SpendingModel> allSpendingData = allRecords
        .map((Map<String, dynamic> e) => SpendingModel.fromMap(data: e))
        .toList();
    return allSpendingData;
  }

  Future<CategoryModelClass> findCategory({required int id}) async {
    if (db == null) {
      await initDB();
    }
    String query = "SELECT * FROM categories WHERE category_id=?;";
    List args = [id];

    List<Map<String, dynamic>> foundedCat = await db!.rawQuery(query, args);

    List<CategoryModelClass> category =
        foundedCat.map((e) => CategoryModelClass.fromMap(data: e)).toList();

    return category[0];
  }

  Future<int> updateSpending({required SpendingModel spending}) async {
    if (db == null) {
      await initDB();
    }
    String query = ""
        "UPDATE spending SET spending_amount = ?, spending_type = ?, spending_category = ? "
        "WHERE spending_id = ?;";

    List args = [
      spending.spending_amount,
      spending.spending_type,
      spending.spending_category,
      spending.spending_id,
    ];
    int res = await db!.rawUpdate(query, args);

    return res;
  }

  Future<int> deleteSpending({required int spendingId}) async {
    if (db == null) {
      await initDB();
    }
    String query = "DELETE FROM spending WHERE spending_id = ?;";

    List args = [spendingId];
    int res = await db!.rawDelete(query, args);

    return res;
  }
}
