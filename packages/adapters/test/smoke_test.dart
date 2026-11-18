import 'package:adapters/adapters.dart';
import 'package:core/pos_barrio_core.dart';
import 'package:test/test.dart';

void main() {
  test('adapters enlaza con core', () {
    expect(adaptersBuildLabel(), '${kAppName}-adapters');
  });
}