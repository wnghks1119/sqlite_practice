import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart' as sql;

// 테이블 생성
class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE data(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      year INTEGER NOT NULL,
      month INTEGER NOT NULL,
      day INTEGER NOT NULL,
      Desc TEXT,
    )""");
  }

  // 최초로 앱 실행하여 데이터 아무것도 없는 경우에 데이터베이스 생성을 위한 함수
  static Future<sql.Database> db() async {
    return await sql.openDatabase("database_name.db", version: 1,
        onCreate: (sql.Database database, int version) async {
          await createTables(database);
        });
  }

  // 데이터베이스에 데이터 최초 저장
  static Future<int> createData(int year, int month, int day, String? desc) async {
    final db = await SQLHelper.db();

    final data = {
      'year': year,
      'month': month,
      'day': day,
      'Desc': desc,
    };
    final id = await db.insert('data', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  // 생성한 모든 데이터(레코드)를 저장해두는 데이터베이스
  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await SQLHelper.db();
    return db.query('data', orderBy: 'id');
  }

  // 전체 데이터 중 특정 월에 대한 데이터만 추출해주는 함수 (where 조건 createdAt 이용해서 캘린더에서 선택한 일에 대한 데이터 추출)
  static Future<List<Map<String, dynamic>>> getMonthData(int year, int month) async {
    final db = await SQLHelper.db();

    return db.rawQuery('SELECT * FROM data WHERE year = year and month = month');
  } // 여기서 'data'는 데이터베이스에서 테이블명을 지칭함

  // 전체 데이터 중 특정 일에 대한 데이터만 추출해주는 함수 (where 조건 createdAt 이용해서 캘린더에서 선택한 일에 대한 데이터 추출)
  static Future<List<Map<String, dynamic>>> getDayData(int year, int month, int day) async {
    final db = await SQLHelper.db();

    return db.rawQuery('SELECT * FROM data WHERE year = year and month = month and day = day');
  }

  // InputListLaterScreen에서 '텍스트 수정 시' 수정내용 반영될 수 있도록 하기
  static Future<int> updateData(int year, int month, int day, String? desc) async {
    final db = await SQLHelper.db();
    final data = {
      'year': year,
      'month': month,
      'day': day,
      'Desc': desc,
    };
    final result = await db.rawUpdate('UPDATE * FROM data WHERE year = year and month = month');
    return result;
  }
}
