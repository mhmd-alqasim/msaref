// الاستثناءات (Exceptions) = الأخطاء التي تحدث في طبقة Data
//
// الفرق بين Exception و Failure:
// Exception = خطأ تقني (قاعدة البيانات فشلت، الشبكة انقطعت)
// Failure   = خطأ نعرضه للمستخدم بشكل مفهوم

class CasheExeption implements Exception {
  final String message;
  const CasheExeption({this.message = 'A database error occurred.'});
}

class DatabaseException implements Exception {
  final String message;
  const DatabaseException({this.message = 'Failure of the operation'});
}
