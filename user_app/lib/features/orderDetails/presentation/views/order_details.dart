import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/order.dart';

class OrderDetailsScreen extends StatelessWidget {
  final MyOrder order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final products = order.products;
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Order Details",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        children: [
          ...products.map((p) => _productCard(context, p)),
          const SizedBox(height: 20),
          _summaryCard(context),
        ],
      ),
    );
  }

  Widget _productCard(BuildContext context, product) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(screenWidth * 0.04),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            color: Colors.white70,
            child: Image.network(
              product.photoURL,
              width: 65,
              height: 65,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          product.name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            "Quantity: ${product.productDetails['quantity']}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        trailing: Text(
          "\$${product.price.toStringAsFixed(2)}",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(BuildContext context) {
    final formattedDate = DateFormat('d MMM yyyy').format(order.date.toDate());
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenHeight * 0.02,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _summaryRow(
            context,
            "Total",
            "\$${order.totalPrice.toStringAsFixed(2)}",
          ),
          Divider(height: 28),
          _summaryRow(context, "Payment", order.paymentMethodFriendly),
          Divider(height: 28),
          _summaryRow(context, "Date", formattedDate),
          Divider(height: 28),
          _summaryRow(context, "Full Name", order.customerName),
          Divider(height: 28),
          _summaryRow(context, "Phone", order.customerPhone),
          Divider(height: 28),
          _summaryRow(context, "Address", order.customerAddress),
          Divider(height: 28),
          _summaryRow(context, "Status", order.status.name),
        ],
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
