import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();
  static Database? db;
  final String categoryTable = "Categories";
  final String starTable = "StarTable";
  final String myTasksTable = "MyTasksTable";
  Future<Database> get database async {
    if (db != null) return db!;
    db = await getDatabase();
    return db!; //!is null assertion operator tells compiler the variable is not null so stop yapping
  }

  Future<Database> getDatabase() async {
    final databaseDirectory = await getDatabasesPath();
    final databasePath = join(databaseDirectory, "ToDo.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $categoryTable(
          Category TEXT
        );
      ''');

        await db.rawInsert(
            'INSERT INTO $categoryTable (Category) VALUES (?)', [starTable]);
        await db.rawInsert(
            'INSERT INTO $categoryTable (Category) VALUES (?)', [myTasksTable]);

        await db.execute('''
          CREATE TABLE $starTable(
          Tasks TEXT
          )
          ''');
        await db.execute('''
          CREATE TABLE $myTasksTable(
           Tasks TEXT
          )
        ''');
      },
    );
    return database;
  }

  Future<List<String>> initMyTasksOnAppStart() async {
    final db = await database;
    List<Map<String, Object?>> tasksMap =
        await db.rawQuery('SELECT * FROM $myTasksTable');
    //print(tasksMap);
    if (tasksMap.isEmpty) return [];
    final List<String> tasks = [];
    for (var task in tasksMap) {
      String taskName = task["Tasks"] as String;
      tasks.add(taskName);
    }
    return tasks;
  }

  Future<List<String>> initCategoryChipsOnAppStart() async {
    final db = await database;
    List<Map<String, Object?>> chipsMap = await db.query(categoryTable);
    List<String> chips = [];
    for (var chip in chipsMap) {
      String chipName = chip["Category"] as String;
      chips.add(chipName);
    }
    //if (chips.length == 2) return [];
    chips.remove("StarTable");
    chips.remove(myTasksTable);
    //print(chips);
    return chips;
  }

  Future<List<String>> createCategory(String categoryName) async {
    final db = await database;
    await db.execute('CREATE TABLE $categoryName(Tasks TEXT)');
    await db.rawInsert(
        'INSERT INTO $categoryTable (Category) VALUES(?)', [categoryName]);
    //print(await db.rawQuery('SELECT * FROM $categoryTable'));
    return [];
  }

  Future<void> deleteCategory(String categoryName) async {
    final db = await database;
    await db.rawDelete(
        'DELETE FROM $categoryTable WHERE Category=?', [categoryName]);
    await db.execute('DROP TABLE IF EXISTS $categoryName');
    //print(await db.rawQuery('SELECT * FROM $categoryTable'));
  }

  Future<void> saveTasks(String tableName, String task) async {
    final db = await database;
    await db.rawInsert('INSERT INTO $tableName(Tasks) VALUES(?)', [task]);
    // print(await db.rawQuery('SELECT * FROM $tableName'));
  }

  Future<void> deleteTasks(String taskName, String tableName) async {
    final db = await database;
    await db.rawDelete('DELETE FROM $tableName WHERE Tasks=?', [taskName]);
  }

  Future<void> starTasks(String taskName, String tableName) async {
    final db = await database;
    await db.rawDelete('DELETE FROM $tableName WHERE Tasks=?', [taskName]);
    await db.rawInsert('INSERT INTO $starTable(Tasks) VALUES(?)', [taskName]);
  }

  Future<void> unStarTasks(String taskName) async {
    final db = await database;
    await db.rawDelete('DELETE FROM $starTable WHERE Tasks=?', [taskName]);
    await db
        .rawInsert('INSERT INTO $myTasksTable(Tasks) VALUES(?)', [taskName]);
  }

  Future<List<String>> fetchCurrentToDo(String tableName) async {
    final db = await database;
    List<Map<String, Object?>> tasksMap =
        await db.rawQuery('SELECT * FROM $tableName');
    //print(tasksMap);
    if (tasksMap.isEmpty) return [];
    final List<String> tasks = [];
    for (var task in tasksMap) {
      String taskName = task["Tasks"] as String;
      tasks.add(taskName);
    }
    return tasks;
  }
}
