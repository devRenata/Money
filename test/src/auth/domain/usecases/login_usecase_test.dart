import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:money/src/auth/domain/entities/logged_user.dart';
import 'package:money/src/auth/domain/errors/errors.dart';
import 'package:money/src/auth/domain/repositories/auth_repository.dart';
import 'package:money/src/auth/domain/usecases/login_usecase.dart';

class AuthRepositoryMock implements IAuthRepository {
  @override
  Future<Either<AuthException, LoggedUser>> login(CredentialsParams params) async {
    if (params.password == '1234') {
      return Left(AuthException('Repository error'));
    }

    return Right(LoggedUser(
      email: params.email,
      name: 'Jacob',
    ));
  }
}

void main() {
  final repository = AuthRepositoryMock();
  final usecase = LoginUsecase(repository);

  test('Deve efeturar o login', () async {
    final result = await usecase(CredentialsParams(
      email: 'jacob@flutterando.com.br',
      password: '123',
    ));

    expect(result.isRight(), true);

    result.fold(
      (l) => fail('Error: $l'),
      (r) => expect(r.name, 'Jacob'),
    ); 
  });

  test('Deve dar erro quando o email for inválido', () async {
    final result = await usecase(CredentialsParams(
      email: 'jacob@',
      password: '123',
    ));

    final error = result.fold((l) => l, (r) => null);

    expect(result.isLeft(), true);
    expect(error, isA<AuthException>());
    expect((error as AuthException).message, 'Email inválido');
  });

  test('Deve dar erro quando a senha for inválida', () async {
    final result = await usecase(CredentialsParams(
      email: 'jacob@flutterando.com.br',
      password: '',
    ));

    expect(result.isLeft(), true);
  });

  test('Deve dar erro quando o repository falhar', () async {
    final result = await usecase(CredentialsParams(
      email: 'jacob@flutterando.com.br',
      password: '1234',
    ));

    expect(result.isLeft(), true);
  });
}
