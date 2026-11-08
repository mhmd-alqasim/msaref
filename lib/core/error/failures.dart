// الفشل (Failures) = ما نعرضه للـ UI
//
// لماذا نفصل بين Exception و Failure؟
// لأن الـ UI لا يجب أن يعرف كيف تعمل قاعدة البيانات
// الـ UI يحتاج فقط: "هل نجح الأمر أم لا؟ وما الرسالة؟"
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
