import 'package:equatable/equatable.dart';
import '../../../../core/models/order.dart'; // استوردنا الموديل

class CheckoutState extends Equatable {
  final String name;
  final String phone;
  final String address;
  // final String city;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String cardholderName;
  final PaymentMethod? paymentMethod; // النوع من order.dart
  final bool isCheckoutValid;
  final bool isSubmitting;
  final Status status;

  const CheckoutState({
    this.name = '',
    this.phone = '',
    this.address = '',
    // this.city = '',
    this.cardNumber = '',
    this.expiryDate = '',
    this.cvv = '',
    this.cardholderName = '',
    this.paymentMethod,
    this.isCheckoutValid = false,
    this.isSubmitting = false,
    this.status=Status.pending,
  });

  CheckoutState copyWith({
    String? name,
    String? phone,
    String? address,
    // String? city,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? cardholderName,
    PaymentMethod? paymentMethod,
    bool? isCheckoutValid,
    bool? isSubmitting,
    Status? status,
  }) {
    return CheckoutState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      // city: city ?? this.city,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      cardholderName: cardholderName ?? this.cardholderName,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isCheckoutValid: isCheckoutValid ?? this.isCheckoutValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
        status: status?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    name,
    phone,
    address,
    // city,
    cardNumber,
    expiryDate,
    cvv,
    cardholderName,
    paymentMethod,
    isCheckoutValid,
    isSubmitting,
    status,
  ];
}
