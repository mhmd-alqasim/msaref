import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/failures.dart';

// الـ UseCase = وحدة عمل واحدة محددة
//
// كل UseCase يفعل شيئاً واحداً فقط:
// GetWallets   → يجلب المحافظ
// AddWallet    → يضيف محفظة
// DeleteWallet → يحذف محفظة
//
// لماذا؟ لأن كل وظيفة يجب أن تكون مستقلة وقابلة للاختبار
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// نستخدم NoParams عندما لا يحتاج الـ UseCase لأي مدخلات
// مثال: GetAllWallets لا يحتاج أي مدخل
class NoParams {
  const NoParams();
}
