import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/features/checkout/presentation/widgets/mybutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cart/presentation/manager/cart_cubit.dart';
import '../manager/checkout_cubit.dart';
import '../manager/checkout_state.dart';
import '../widgets/buildtextfield.dart';
import '../../../../core/models/order.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _fontFamily = 'Montserrat';
    bool showFields = false;
    int? selectedIndex;

    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        final cubit = context.read<CheckoutCubit>();
        final cartCubit = context.read<CartCubit>();
        final size = MediaQuery.of(context).size;
        final screenWidth = size.width;
        final screenHeight = size.height;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text("Checkout", style: TextStyle(fontFamily: _fontFamily)),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                AppRouter.router.go(AppRouter.kCart);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                              Text(
                                " Shipping Address",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),

                          StreamBuilder(
                            stream: cubit.getUserPreviousAddresses(
                              FirebaseAuth.instance.currentUser!.uid,
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              final addresses = snapshot.data!;
                              final hasNoAddresses = addresses.isEmpty;

                              if (hasNoAddresses && showFields == false) {
                                showFields = true;
                              }

                              return StatefulBuilder(
                                builder: (context, setStateSB) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (!hasNoAddresses)
                                        Padding(
                                          padding: EdgeInsets.all(
                                            screenWidth * 0.02,
                                          ),
                                          child: GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: addresses.length + 1,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing:
                                                      screenWidth * 0.04,
                                                  mainAxisSpacing:
                                                      screenWidth * 0.04,
                                                  childAspectRatio: 0.75,
                                                ),
                                            itemBuilder: (context, i) {
                                              if (i == addresses.length) {
                                                return InkWell(
                                                  onTap: () {
                                                    setStateSB(() {
                                                      showFields = !showFields;
                                                      selectedIndex = i;
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            14,
                                                          ),
                                                      border: Border.all(
                                                        color:
                                                            selectedIndex == i
                                                                ? Theme.of(
                                                                  context,
                                                                ).primaryColor
                                                                : Colors
                                                                    .grey
                                                                    .shade300,
                                                        width:
                                                            selectedIndex == i
                                                                ? 2
                                                                : 1,
                                                      ),
                                                      color:
                                                          Theme.of(
                                                            context,
                                                          ).cardColor,
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.add,
                                                        size: 35,
                                                        color:
                                                            Theme.of(
                                                              context,
                                                            ).primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }

                                              final item = addresses[i];

                                              return InkWell(
                                                onTap: () {
                                                  setStateSB(() {
                                                    showFields = false;
                                                    selectedIndex = i;
                                                  });
                                                  cubit.updateName(
                                                    item["name"],
                                                  );
                                                  cubit.updatePhone(
                                                    item["phone"],
                                                  );
                                                  cubit.updateAddress(
                                                    item["address"],
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                    screenWidth * 0.03,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).cardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          14,
                                                        ),
                                                    border: Border.all(
                                                      color:
                                                          selectedIndex == i
                                                              ? Theme.of(
                                                                context,
                                                              ).primaryColor
                                                              : Colors
                                                                  .grey
                                                                  .shade300,
                                                      width:
                                                          selectedIndex == i
                                                              ? 2
                                                              : 1,
                                                    ),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Colors.black12,
                                                        blurRadius: 4,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Full Name:',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  _fontFamily,
                                                              color:
                                                                  Colors
                                                                      .grey[600],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 2,
                                                          ),
                                                          Text(
                                                            item["name"],
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  _fontFamily,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            screenHeight * 0.01,
                                                      ),

                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Phone Number:',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  _fontFamily,
                                                              color:
                                                                  Colors
                                                                      .grey[600],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 2,
                                                          ),
                                                          Text(
                                                            item["phone"],
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontFamily:
                                                                  _fontFamily,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            screenHeight * 0.01,
                                                      ),

                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Address:',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    _fontFamily,
                                                                color:
                                                                    Colors
                                                                        .grey[600],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 2,
                                                            ),
                                                            Text(
                                                              item["address"],
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis, // ✅
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontFamily:
                                                                    _fontFamily,
                                                                height: 1.2,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      if (showFields) ...[
                                        const SizedBox(height: 15),
                                        buildTextField(
                                          'Full Name',
                                          'Full Name',
                                          null,
                                          context,
                                          onChanged: cubit.updateName,
                                        ),
                                        const SizedBox(height: 12),
                                        buildTextField(
                                          'Phone Number',
                                          '+20 1234567890',
                                          null,
                                          context,
                                          onChanged: cubit.updatePhone,
                                        ),
                                        const SizedBox(height: 12),
                                        buildTextField(
                                          'Address',
                                          'Floor, Apartment, Building, Street, City.',
                                          null,
                                          context,
                                          onChanged: cubit.updateAddress,
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              );
                            },
                          ),

                          // const SizedBox(height: 15),
                          // buildTextField('Full Name', 'Full Name', null, context, onChanged: cubit.updateName),
                          // const SizedBox(height: 12),
                          // buildTextField('Phone Number', '+20 1234567890', null, context, onChanged: cubit.updatePhone),
                          // const SizedBox(height: 12),
                          // buildTextField('Address', 'Floor, Apartment, Building, Street, City.', null, context, onChanged: cubit.updateAddress),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.credit_card,
                                color: Theme.of(context).primaryColor,
                              ),
                              Text(
                                ' Payment Method',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap:
                                () => cubit.updatePaymentMethod(
                                  PaymentMethod.cash,
                                ),
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.03),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      state.paymentMethod == PaymentMethod.cash
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey[300]!,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  if (state.paymentMethod == PaymentMethod.cash)
                                    Icon(
                                      Icons.circle,
                                      color: Theme.of(context).primaryColor,
                                      size: 10,
                                    ),
                                  Text(
                                    '  💵',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.05,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Cash on Delivery',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                        ),
                                        Text(
                                          'Pay when your order is delivered',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                  Expanded(
                                    child: Text(
                                      '• Delivery in 3-5 business days',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.labelLarge,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap:
                                () => cubit.updatePaymentMethod(
                                  PaymentMethod.visa,
                                ),
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.03),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      state.paymentMethod == PaymentMethod.visa
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey[300]!,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  if (state.paymentMethod == PaymentMethod.visa)
                                    Icon(
                                      Icons.circle,
                                      color: Theme.of(context).primaryColor,
                                      size: 10,
                                    ),
                                  Text(
                                    '  💳',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.05,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Credit/Debit Card',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                        ),
                                        Text(
                                          'Visa, MasterCard, American Express',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                  Expanded(
                                    child: Text(
                                      '• Fast delivery in 1-2 business days',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: _fontFamily,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (state.paymentMethod == PaymentMethod.visa) ...[
                            const SizedBox(height: 20),
                            buildTextField(
                              'Card Number',
                              '1234 5678 9012 3456',
                              null,
                              context,
                              onChanged: cubit.updateCardNumber,
                            ),
                            const SizedBox(height: 12),
                            buildTextField(
                              'Expiry Date',
                              'MM/YY',
                              null,
                              context,
                              onChanged: cubit.updateExpiryDate,
                            ),
                            const SizedBox(width: 10),
                            buildTextField(
                              'CVV',
                              '123',
                              null,
                              context,
                              onChanged: cubit.updateCvv,
                            ),
                            const SizedBox(height: 12),
                            buildTextField(
                              'Cardholder Name',
                              'Name as on card',
                              null,
                              context,
                              onChanged: cubit.updateCardholderName,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Card(
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order Summary",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cartCubit.state.products.length,
                            itemBuilder: (context, index) {
                              final item = cartCubit.state.products[index];
                              final qty =
                                  (item.productDetails['quantity'] ?? 1);
                              final size = item.productDetails['size'];
                              final color = item.productDetails['color'];
                              return ListTile(
                                title: Text(
                                  item.name,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      "Qty: $qty ",
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.labelMedium,
                                    ),
                                    color != null
                                        ? Text(
                                          ' • Color: $color ',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.labelMedium,
                                        )
                                        : const Text(''),
                                    size != null
                                        ? Text(
                                          ' Size: $size',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.labelMedium,
                                        )
                                        : const Text(''),
                                  ],
                                ),
                                trailing: Text(
                                  '\$ ${item.price}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              );
                            },
                          ),
                          Divider(),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subtotal",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                "\$${cartCubit.withoutTax.toStringAsFixed(2)}",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Shipping",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              (cartCubit.withoutTax > 1000)
                                  ? Text(
                                    "Free",
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  )
                                  : Text(
                                    "\$${cartCubit.shipping}",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tax",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                "\$${cartCubit.tax.toStringAsFixed(2)}",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          Divider(), //color: Colors.grey[300],
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                "\$${cartCubit.total.toStringAsFixed(2)}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: SafeArea(
              child: MyButton(
                text:
                    'Confirm Payment • \$${cartCubit.total.toStringAsFixed(2)}',
                onPressed:
                    (state.isCheckoutValid &&
                            (!showFields || cubit.areAddressFieldsValid(cubit)))
                        ? () async {
                          final order = await cubit.confirmOrder();
                          if (order != null) {
                            AppRouter.router.go(
                              AppRouter.kOrderSummary,
                              extra: order,
                            );
                          }
                        }
                        : null,
                backgroundColor:
                    (state.isCheckoutValid &&
                            (!showFields || cubit.areAddressFieldsValid(cubit)))
                        ? Theme.of(context).primaryColor
                        : const Color(0xFFBFD7C0),
                size: 18,
                textColor: Colors.white,
                isLoading: state.isSubmitting,
              ),
            ),
          ),
        );
      },
    );
  }
}
