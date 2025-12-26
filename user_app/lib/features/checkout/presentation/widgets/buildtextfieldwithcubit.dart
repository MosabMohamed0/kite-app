import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/checkout_cubit.dart';
import 'buildtextfield.dart';

Widget buildTextFieldWithCubit({
  required BuildContext context,
  required String label,
  required String hint,
  required String field, // name, phone, address...
}) {
  final cubit = context.read<CheckoutCubit>();
  final state = context.watch<CheckoutCubit>().state;

  TextEditingController controller;

  switch (field) {
    case 'name':
      controller = TextEditingController(text: state.name);
      break;
    case 'phone':
      controller = TextEditingController(text: state.phone);
      break;
    case 'address':
      controller = TextEditingController(text: state.address);
      break;
    // case 'city':
    //   controller = TextEditingController(text: state.city);
    //   break;
    case 'cardNumber':
      controller = TextEditingController(text: state.cardNumber);
      break;
    case 'expiryDate':
      controller = TextEditingController(text: state.expiryDate);
      break;
    case 'cvv':
      controller = TextEditingController(text: state.cvv);
      break;
    case 'cardholderName':
      controller = TextEditingController(text: state.cardholderName);
      break;
    default:
      controller = TextEditingController();
  }

  return buildTextField(label, hint, controller, context,
      onChanged: (value) {
        switch (field) {
          case 'name':
            cubit.updateName(value);
            break;
          case 'phone':
            cubit.updatePhone(value);
            break;
          case 'address':
            cubit.updateAddress(value);
            break;
          // case 'city':
          //   cubit.updateCity(value);
          //   break;
          case 'cardNumber':
            cubit.updateCardNumber(value);
            break;
          case 'expiryDate':
            cubit.updateExpiryDate(value);
            break;
          case 'cvv':
            cubit.updateCvv(value);
            break;
          case 'cardholderName':
            cubit.updateCardholderName(value);
            break;
        }
      });
}