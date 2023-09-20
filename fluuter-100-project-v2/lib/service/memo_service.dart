import 'package:path/path.dart';
import 'package:project/models/memo_dto.dart';
import 'package:sqflite/sqflite.dart';

// ignore_for_file: constant_identifier_names
const String TBL_MEMO = "tbl_memoList";

class MemoService {
  late Database _database;
  final String createTABLE = """
  CREATE TABLE $TBL_MEMO (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    content TEXT,
  )
  """;

  Future<void> onCreateTable(db, version) async {
    return db.execute(createTABLE);
  }

  Future<void> onUpgradeTable(db, oldVersion, newVersion) async {
    if (newVersion > oldVersion) {
      final db = await database;
      final batch = db.batch();
      batch.execute("DROP TABLE $TBL_MEMO");
      batch.execute(createTABLE);
      await batch.commit();
    }
  }

  Future<Database> initDatabase() async {
    String dbPath = await getDatabasesPath();
    var dbFile = join(dbPath, "memo.dbf");
    return await openDatabase(
      dbFile,
      onCreate: onCreateTable,
      onUpgrade: onUpgradeTable,
      version: 4,
    );
  }

  Future<Database> get database async {
    _database = await initDatabase();
    return _database;
  }

  Future<int> insert(MemoDto memo) async {
    final db = await database;
    return await db.insert(TBL_MEMO, memo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MemoDto>> selectAll() async {
    final db = await database;
    final List<Map<String, dynamic>> memoList = await db.query(TBL_MEMO);

    return List.generate(
      memoList.length,
      (index) => MemoDto(
        id: memoList[index]["id"],
        content: memoList[index]["content"],
      ),
    );
  }
}
