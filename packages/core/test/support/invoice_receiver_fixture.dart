import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';

ConfirmCheckoutInvoiceReceiverInput invoiceReceiverInput({
  String rut = '12.345.678-5',
  String businessName = 'Cliente SpA',
  String giro = 'Abarrotes',
  String email = 'cliente@correo.cl',
  String address = 'Av. 1 100',
  String city = 'Santiago',
  String commune = 'Nunoa',
  String phone = '912345678',
}) {
  return ConfirmCheckoutInvoiceReceiverInput(
    rut: rut,
    businessName: businessName,
    giro: giro,
    email: email,
    address: address,
    city: city,
    commune: commune,
    phone: phone,
  );
}

CheckoutInvoiceReceiverDto invoiceReceiverDto({
  String rut = '12.345.678-5',
  String businessName = 'Cliente SpA',
}) {
  final input = invoiceReceiverInput(rut: rut, businessName: businessName);
  return CheckoutInvoiceReceiverDto(
    rut: input.rut,
    businessName: input.businessName,
    giro: input.giro,
    email: input.email,
    address: input.address,
    city: input.city,
    commune: input.commune,
    phone: input.phone,
  );
}

SaleInvoiceReceiver sampleSaleInvoiceReceiver() {
  return SaleInvoiceReceiver.validate(
    rutRaw: '12.345.678-5',
    businessNameRaw: 'Cliente SpA',
    giroRaw: 'Abarrotes',
    emailRaw: 'cliente@correo.cl',
    addressRaw: 'Av. 1 100',
    cityRaw: 'Santiago',
    communeRaw: 'Nunoa',
    phoneRaw: '912345678',
  );
}
