import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;
  //هون انا طبقت مبدا
  // singleton Pattern
  ///نسخو وحدة وثابتة من بدا تشغيل التطبيق حتى انتهاء العمل تجنب حدوث مشاكل وصرف الذاكرة
  ///
  ///الـ Factory Constructor يضمن أنه كلما قمت بكتابة DatabaseHelper() لإنشاء كائن جديد، فلن يتم إنشاء كلاس جديد، بل سيتم إرجاع نفس النسخة الثابتة (instance) المخزنة مسبقاً.
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    // إذا قاعدة البيانات موجودة، أعدها مباشرة
    if (_database != null) return _database!;
    // إذا لاء، أنشئها
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'msaref.db');

    return await openDatabase(path, version: 1, onCreate: _createTables);
  }

  Future<void> _createTables(Database db, int version) async {
    // نستخدم Batch لتنفيذ كل الأوامر دفعة واحدة
    // أسرع من تنفيذها واحداً واحداً
    final batch = db.batch();

    // ── جدول المحافظ ──
    batch.execute('''
      CREATE TABLE wallets (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        balance REAL NOT NULL DEFAULT 0.0,
        currency TEXT NOT NULL DEFAULT 'USD',
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // ── جدول المعاملات ──
    batch.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        wallet_id TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        category_id INTEGER NOT NULL DEFAULT 0,
        description TEXT DEFAULT '',
        date INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (wallet_id) 
          REFERENCES wallets(id) 
          ON DELETE CASCADE
      )
    ''');

    // ── جدول الميزانيات ──
    batch.execute('''
      CREATE TABLE budgets (
        id TEXT PRIMARY KEY,
        wallet_id TEXT NOT NULL,
        category_id INTEGER NOT NULL DEFAULT 0,
        name TEXT NOT NULL,
        amount REAL NOT NULL,
        period TEXT NOT NULL,
        start_date INTEGER NOT NULL,
        end_date INTEGER NOT NULL,
        FOREIGN KEY (wallet_id) 
          REFERENCES wallets(id) 
          ON DELETE CASCADE
      )
    ''');

    // ── جدول الأهداف ──
    batch.execute('''
      CREATE TABLE goals (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        target_amount REAL NOT NULL,
        current_amount REAL NOT NULL DEFAULT 0.0,
        category TEXT DEFAULT '',
        start_date INTEGER NOT NULL,
        end_date INTEGER,
        is_completed INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    await batch.commit(noResult: true);
  }

  ///توابع رح تساعدني
  /// أدخل صف جديد في أي جدول
  Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
    // ConflictAlgorithm? conflictAlgorithm: بارامتر اختياري (اختياري لأن بجانبه علامة ?)
    // يُستخدم لتحديد السلوك عند حدوث تعارض في البيانات (مثل تكرار المفتاح الأساسي)،
    // وإذا تركته فارغاً فلن يحدث خطأ ولن يتم تطبيقه.
  }

  /// جلب صفوف بشرط معين
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
  }

  /// تحديث صف
  Future<void> update(
    String table,
    Map<String, dynamic> data, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  /// حذف صف
  Future<void> delete(
    String table, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    await db.delete(table, where: where, whereArgs: whereArgs);
  }

  /// إغلاق قاعدة البيانات (نادراً ما نحتاجه)
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
