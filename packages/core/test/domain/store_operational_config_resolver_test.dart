import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-162-01 sin overrides conserva plantilla Atria', () {
    final store = Store.create(
      id: 'store_01',
      rutRaw: '76123456-0',
      legalName: 'Demo',
      businessLine: 'Retail',
    );
    final tpl = StoreOperationalConfigResolver.effectiveTemplate(store);
    expect(
      tpl.hasFeature(PosFeature.invoiceCheckout),
      isTrue,
    );
    expect(
      tpl.hasFeature(PosFeature.sellerCodeCheckout),
      isFalse,
    );
    expect(tpl.hasFeature(PosFeature.cardPaymentCheckout), isTrue);
  });

  test('SC-162-02 sellerCodeRequired activa feature', () {
    var store = Store.create(
      id: 'store_01',
      rutRaw: '76123456-0',
      legalName: 'Demo',
      businessLine: 'Retail',
    );
    store = store.withOperationalOverrides(
      const StoreOperationalOverrides(sellerCodeRequired: true),
    );
    final tpl = StoreOperationalConfigResolver.effectiveTemplate(store);
    expect(tpl.hasFeature(PosFeature.sellerCodeCheckout), isTrue);
  });
}