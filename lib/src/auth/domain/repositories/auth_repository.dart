import 'package:fpdart/fpdart.dart';

import '../entities/logged_user.dart';
import '../errors/errors.dart';
import '../usecases/login_usecase.dart';

abstract class IAuthRepository {
  Future<Either<AuthException, LoggedUser>> login(CredentialsParams params);
}