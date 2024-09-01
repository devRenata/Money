import 'package:fpdart/fpdart.dart';
import 'package:validators/validators.dart';

import '../entities/logged_user.dart';
import '../errors/errors.dart';
import '../repositories/auth_repository.dart';

abstract class ILoginUsecase {
  Future<Either<AuthException, LoggedUser>> call(CredentialsParams params);
}

class LoginUsecase implements ILoginUsecase {
  final IAuthRepository repository;
  LoginUsecase(this.repository);

  @override
  Future<Either<AuthException, LoggedUser>> call(CredentialsParams params) async {
    if (!isEmail(params.email)) {
      return Left(AuthException('Email inválido'));
    }
    if (params.password.isEmpty) {
      return Left(AuthException('A senha é obrigatória'));
    }

    return await repository.login(params);    
  }
}

class CredentialsParams {
  final String email;
  final String password;

  CredentialsParams({
    required this.email,
    required this.password,
  });
}

// Exemplo de como chama
// main(List<String> args) async {
//   final usecase = LoginUsecase();

//   final result = await usecase();

//   result.fold((l) {
//     print('error');
//   }, (r) {
//     print('setState');
//   });
// }