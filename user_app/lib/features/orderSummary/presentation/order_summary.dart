import 'package:depi_app/core/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

import '../../../core/models/order.dart';
import '../widgets/tracking_steps.dart';

class OrderSummary extends StatelessWidget {
  final MyOrder order;

  const OrderSummary({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('d MMM yyyy').format(now);
    String _fontFamily= 'Montserrat';
    return Scaffold(
      backgroundColor:Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).cardColor, // check in dark ********
                ),
                child: ClipOval(
                  child: Lottie.asset(
                    'assets/animation/SuccessCheck.json',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                )

              ),
              const SizedBox(height: 20),

              const Text(
                "Order Confirmed!",
                style: TextStyle(
                  fontSize:30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00A63E),
                  fontFamily: 'Montserrat'
                ),
              ),

              const SizedBox(height: 8),

               Text(
                "Thank you! Your order will be delivered soon",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 25),

              // Order info card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:  [
                    Text("Order Number", style:Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: 4),
                    Text(
                      order.id,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontFamily: _fontFamily,
                      ),
                    ),
                    Divider(thickness: 0.5,),
                    SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Amount",style: Theme.of(context).textTheme.titleMedium,),
                        Text(
                            "\$${order.totalPrice.toStringAsFixed(2)}",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Payment Method",style: Theme.of(context).textTheme.titleMedium,),
                        Text(
                          order.paymentMethodFriendly,
                            style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Estimated Delivery",style: Theme.of(context).textTheme.titleMedium,),
                        Text(
                            DateFormat('dd MMM yyyy').format(order.date.toDate().add(Duration(days: 3))),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children:  [
                        Icon(Icons.local_shipping, color:Theme.of(context).primaryColor),
                        SizedBox(width: 8),
                        Text(
                          "Order Tracking",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    buildTrackingStep(
                      context:context,
                      title: "Order Confirmed",
                      date: DateFormat('dd MMM yyyy').format(order.date.toDate()),
                      isActive: formattedDate ==
                          DateFormat('dd MMM yyyy').format(order.date.toDate()),
                    ),
                    buildTrackingStep(
                      context: context,
                      title: "Being Prepared",
                      date: formattedDate ==
                          DateFormat('dd MMM yyyy').format(order.date.toDate().add(Duration(days:1)))
                          ? formattedDate
                          :"Pending",
                      isActive:  formattedDate ==
                          DateFormat('dd MMM yyyy').format(order.date.toDate().add(Duration(days:1))),
                    ),
                    buildTrackingStep(
                      context:context,
                      title: "Out for Delivery",
                      date:formattedDate ==
                          DateFormat('dd MMM yyyy').format(order.date.toDate().add(Duration(days:3)))
                          ? formattedDate
                          :"Pending",
                      isActive: formattedDate ==
                          DateFormat('dd MMM yyyy').format(order.date.toDate().add(Duration(days:3))),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    AppRouter.router.go(AppRouter.kHome);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home_outlined),
                      const SizedBox(width: 8,),
                      const Text("Back to Home"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    AppRouter.router.go(AppRouter.kViewAllOrders);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFF80AF81)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_2_outlined,size: 20,),
                      const SizedBox(width: 8,),
                      Text("View My Orders",),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



