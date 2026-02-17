import 'package:earnwise_app/data/repositories/auth_http_repository.dart';
import 'package:earnwise_app/data/repositories/category_http_repository.dart';
import 'package:earnwise_app/domain/repositories/auth_repository.dart';
import 'package:earnwise_app/domain/repositories/category_repository.dart';
import 'package:get_it/get_it.dart';

final di = GetIt.instance;

void setupDI() {
  di.registerFactory<AuthRepository>(() => AuthHttpRepository());
  di.registerFactory<CategoryRepository>(() => CategoryHttpRepository());
}