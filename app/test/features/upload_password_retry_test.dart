import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:miser_api/miser_api.dart';
import 'package:miser_app/core/api/api_error.dart';
import 'package:miser_app/features/statements/statement_password_dialog.dart';
import 'package:miser_app/features/statements/statement_uploader.dart';

import '../helpers/fakes.dart';

const _ok = {
  'id': 7,
  'statementType': 'PDF',
  'status': 'PARSED',
  'accountId': 3,
  'issuer': 'HDFC',
  'parserLayout': 'hdfc-savings-v2',
  'transactionCount': 42,
};

Map<String, Object> _pwError(String code) =>
    {'status': 422, 'message': 'Statement is password protected', 'code': code};

/// Simulates the backend: correct password is "s3cret".
Object? _backend(RecordedRequest r) {
  final body = r.body;
  if (!body.contains('name="password"')) return FakeResponse(422, _pwError('PASSWORD_REQUIRED'));
  if (!body.contains('s3cret')) return FakeResponse(422, _pwError('PASSWORD_INCORRECT'));
  return const FakeResponse(201, _ok);
}

void main() {
  late FakeAdapter adapter;
  late StatementUploader uploader;

  setUp(() {
    adapter = FakeAdapter(_backend);
    uploader = StatementUploader(MiserApi(dio: fakeDio(adapter), interceptors: const []).getStatementControllerApi());
  });

  test('prompts on PASSWORD_REQUIRED, re-prompts on PASSWORD_INCORRECT, then succeeds', () async {
    final prompts = <bool>[];
    final answers = ['wrong', 's3cret'];
    final result = await uploadWithPasswordRetry(
      uploader: uploader,
      bytes: [1, 2, 3],
      filename: 'statement.pdf',
      accountId: 3,
      promptPassword: ({required incorrect}) async {
        prompts.add(incorrect);
        return answers.removeAt(0);
      },
    );

    expect(result?.id, 7);
    expect(result?.transactionCount, 42);
    expect(prompts, [false, true], reason: 'first "required", then "incorrect"');
    expect(adapter.requests, hasLength(3));
  });

  test('password goes in the multipart body, never in the URL', () async {
    await uploadWithPasswordRetry(
      uploader: uploader,
      bytes: [1, 2, 3],
      filename: 'statement.pdf',
      creditCardId: 9,
      promptPassword: ({required incorrect}) async => 's3cret',
    );
    for (final r in adapter.requests) {
      expect(r.uri.path, '/api/statements/upload');
      expect(r.uri.query, isEmpty, reason: 'no query string at all');
      expect(r.uri.toString(), isNot(contains('s3cret')));
      expect('${r.options.contentType}', startsWith('multipart/form-data'));
      expect(r.body, contains('name="file"; filename="statement.pdf"'));
      expect(r.body, contains('name="creditCardId"'));
      expect(r.body, isNot(contains('name="accountId"')));
    }
    final last = adapter.requests.last.body;
    expect(last, matches(RegExp(r'name="password"\r\n\r\ns3cret\r\n')));
    // The first attempt must not send an (empty) password field.
    expect(adapter.requests.first.body, isNot(contains('name="password"')));
  });

  test('cancelling the prompt stops without another request', () async {
    final result = await uploadWithPasswordRetry(
      uploader: uploader,
      bytes: [1],
      filename: 'locked.pdf',
      accountId: 3,
      promptPassword: ({required incorrect}) async => null,
    );
    expect(result, isNull);
    expect(adapter.requests, hasLength(1));
  });

  test('other errors surface as ApiException with the server message', () async {
    adapter = FakeAdapter((_) =>
        const FakeResponse(422, {'status': 422, 'message': 'Unrecognised statement layout'}));
    uploader = StatementUploader(MiserApi(dio: fakeDio(adapter), interceptors: const []).getStatementControllerApi());
    await expectLater(
      uploadWithPasswordRetry(
        uploader: uploader,
        bytes: [1],
        filename: 'x.csv',
        accountId: 3,
        promptPassword: ({required incorrect}) async => fail('should not prompt'),
      ),
      throwsA(isA<ApiException>()
          .having((e) => e.message, 'message', 'Unrecognised statement layout')
          .having((e) => e.status, 'status', 422)),
    );
  });

  testWidgets('password dialog uses an obscured field and returns the value', (tester) async {
    String? result = 'unset';
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async {
              result = await showStatementPasswordDialog(context, incorrect: true, filename: 'a.pdf');
            },
            child: const Text('open'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Incorrect password'), findsOneWidget);
    final field = tester.widget<TextField>(find.byKey(const Key('statement-password-field')));
    expect(field.obscureText, isTrue);
    expect(field.enableSuggestions, isFalse);
    expect(field.autocorrect, isFalse);

    await tester.enterText(find.byKey(const Key('statement-password-field')), 's3cret');
    await tester.tap(find.byKey(const Key('statement-password-submit')));
    await tester.pumpAndSettle();
    expect(result, 's3cret');
  });

  testWidgets('cancelling the password dialog returns null', (tester) async {
    String? result = 'unset';
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async {
              result = await showStatementPasswordDialog(context, incorrect: false);
            },
            child: const Text('open'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Password required'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(result, isNull);
  });
}
