import 'package:flutter_test/flutter_test.dart';
import 'package:password_vault/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('InputStringDialogDialogModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
