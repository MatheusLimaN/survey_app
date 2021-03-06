import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:survey_app/domain/entities/entities.dart';
import 'package:survey_app/domain/usecases/usecases.dart';
import 'package:survey_app/presentation/presenters/presenters.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  GetxSplashPresenter sut;
  LoadCurrentAccount loadCurrentAccount;
  String token;

  PostExpectation mockLoadCurrentAccountCall() =>
      when(loadCurrentAccount.load());

  mockLoadCurrentAccount({AccountEntity account}) {
    mockLoadCurrentAccountCall().thenAnswer((_) async => account);
  }

  mockLoadCurrentError() {
    mockLoadCurrentAccountCall().thenThrow(Exception());
  }

  setUp(() {
    token = faker.guid.guid();
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentAccount(account: AccountEntity(token));
  });

  test('Should call loadCurrentAccount', () async {
    await sut.checkAccount(duration: 0);

    verify(loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.checkAccount(duration: 0);
  });

  test('Should go to login page on null result', () async {
    mockLoadCurrentAccount(account: null);

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.checkAccount(duration: 0);
  });

  test('Should go to login page on error', () async {
    mockLoadCurrentError();

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.checkAccount(duration: 0);
  });
}
