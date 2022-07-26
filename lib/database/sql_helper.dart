import 'package:flutter/foundation.dart';
import 'package:music/models/track_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE tracks (
        trackId INTEGER PRIMARY KEY ,
        trackName TEXT,
        albumName TEXT,
        artistName TEXT,
        rating INTEGRE,
        explicit INTEGRE
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'music.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> addTrack(TrackModel trackModel) async {
    final db = await SQLHelper.db();
    final result = await db.insert('tracks', trackModel.toMap());
    
    return result;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('tracks');
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('tracks', where: "trackId = ?", whereArgs: [id], limit: 1);
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("tracks", where: "trackId = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
