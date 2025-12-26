import 'package:depi_app/features/checkout/presentation/data/decreaseStockService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/cart_cubit.dart';
import 'package:depi_app/core/widgets/custom_button.dart';
import 'package:depi_app/core/utils/app_router.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CartCubit>();
    final cart = cubit.state.products;
    late final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart, color: Theme.of(context).primaryColor),
            SizedBox(width: screenWidth * 0.02),
            Text(
              'Shopping Cart (${cubit.state.products.length})',
              style: theme.textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      body:
          cubit.state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : cubit.state.products.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("🛒", style: TextStyle(fontSize: screenWidth * 0.3)),
                    const SizedBox(height: 8),
                    Text(
                      "Your cart is empty",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Looks like you haven't added anything to your cart yet",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      color: theme.scaffoldBackgroundColor,
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      width: screenWidth * 0.5,
                      child: ElevatedButton(
                        onPressed: () {
                          AppRouter.router.go(AppRouter.kHome);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          "Start Shopping",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cart.length,
                            itemBuilder: (context, index) {
                              final item = cart[index];
                              final qty = item.productDetails['quantity'] ?? 1;
                              final size = item.productDetails['size'];
                              final color = item.productDetails['color'];

                              return Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.01,
                                ),
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: screenWidth * 0.18,
                                      height: screenHeight * 0.08,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child:
                                          item.photoURL.isNotEmpty
                                              ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  item.photoURL,
                                                  width: screenWidth * 0.18,
                                                  height: screenHeight * 0.08,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                              : Icon(
                                                Icons.image,
                                                color: Colors.white,
                                                size: screenWidth * 0.1,
                                              ),
                                    ),
                                    SizedBox(width: screenWidth * 0.04),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            item.brand,
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.labelSmall,
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              if (size != null)
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                  margin: const EdgeInsets.only(
                                                    right: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).cardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    'Size: $size',
                                                    style:
                                                        Theme.of(
                                                          context,
                                                        ).textTheme.labelMedium,
                                                  ),
                                                ),
                                              if (color != null)
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).cardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    'Color: $color',
                                                    style:
                                                        Theme.of(
                                                          context,
                                                        ).textTheme.labelMedium,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Text(
                                                '\$${item.price}',
                                                style: TextStyle(
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).primaryColor,
                                                  fontSize: screenWidth * 0.04,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const Spacer(),
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Theme.of(
                                                            context,
                                                          ).cardColor,
                                                      border: Border.all(
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade300,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.remove,
                                                          ),
                                                          onPressed: () {
                                                            if (qty > 1) {
                                                              cubit.decreaseQty(
                                                                index,
                                                              );
                                                            }
                                                          },
                                                          iconSize:
                                                              screenWidth *
                                                              0.04,
                                                        ),
                                                        Text(
                                                          qty.toString(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                        ),
                                                        IconButton(
                                                          icon: Icon(Icons.add),
                                                          onPressed:
                                                              () => cubit
                                                                  .increaseQty(
                                                                    index,
                                                                  ),
                                                          iconSize:
                                                              screenWidth *
                                                              0.04,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.02,
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed:
                                                        () => cubit.removeItem(
                                                          index,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),

                          Card(
                            color: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * 0.03),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.discount_outlined,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(width: screenWidth * 0.02),
                                      Text(
                                        "Discount Coupon",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: cubit.couponController,
                                          decoration: InputDecoration(
                                            hintText:
                                                'Enter coupon code (try SAVE1)',
                                            hintStyle:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                            filled: true,
                                            fillColor:
                                                Theme.of(context).cardColor,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.009),
                                      Flexible(
                                        flex: 0,
                                        child: CustomButton(
                                          onPressed:
                                              () => cubit.applyCoupon(context),
                                          text: "Apply",
                                          backgroundColor:
                                              Theme.of(context).cardColor,
                                          textColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Card(
                            color: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Order Summary",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Subtotal",
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                      ),
                                      Text(
                                        "\$${cubit.withoutTax.toStringAsFixed(2)}",
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Shipping",
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                      ),
                                      (cubit.withoutTax > 1000)
                                          ? Text(
                                            "Free",
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.labelLarge,
                                          )
                                          : Text(
                                            "\$${cubit.shipping}",
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                          ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Tax",
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                      ),
                                      Text(
                                        "\$${cubit.tax.toStringAsFixed(2)}",
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "\$${cubit.total.toStringAsFixed(2)}",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 70),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      onPressed: () async {
                        final stockService = StockService();
                        List<Map<String, dynamic>> insufficientItems =
                            await stockService.checkInsufficientStockForCart(
                              cart,
                            );
                        if (insufficientItems.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  backgroundColor: Theme.of(context).cardColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 8,
                                  titlePadding: EdgeInsets.all(
                                    screenWidth * 0.05,
                                  ),
                                  contentPadding: EdgeInsets.all(
                                    screenWidth * 0.03,
                                  ),
                                  actionsPadding: EdgeInsets.all(
                                    screenWidth * 0.04,
                                  ),

                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: screenWidth * 0.08,
                                      ),
                                      SizedBox(width: screenWidth * 0.02),
                                      Text(
                                        "Insufficient Stock",
                                        style: theme.textTheme.displayMedium
                                            ?.copyWith(
                                              fontSize: screenWidth * 0.05,
                                            ),
                                      ),
                                    ],
                                  ),

                                  content: SizedBox(
                                    width: double.maxFinite,
                                    child: ListView(
                                      shrinkWrap: true,
                                      children:
                                          insufficientItems.map((item) {
                                            return Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 6,
                                                  ),
                                              padding: EdgeInsets.all(
                                                screenWidth * 0.03,
                                              ),
                                              decoration: BoxDecoration(
                                                color: theme.cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),

                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item['name'],
                                                    style: theme
                                                        .textTheme
                                                        .headlineMedium
                                                        ?.copyWith(
                                                          fontSize:
                                                              screenWidth *
                                                              0.045,
                                                        ),
                                                  ),
                                                  SizedBox(height: 4),

                                                  if (item['color'] != null &&
                                                      item['size'] != null)
                                                    Text(
                                                      "(${item['color']} • ${item['size']})",
                                                      style: TextStyle(
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade700,
                                                      ),
                                                    ),

                                                  if (item['color'] != null &&
                                                      item['size'] == null)
                                                    Text(
                                                      "Color: ${item['color']}",
                                                      style: TextStyle(
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade700,
                                                      ),
                                                    ),

                                                  if (item['size'] != null &&
                                                      item['color'] == null)
                                                    Text(
                                                      "Size: ${item['size']}",
                                                      style: TextStyle(
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade700,
                                                      ),
                                                    ),

                                                  SizedBox(height: 10),

                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal:
                                                                  screenWidth *
                                                                  0.03,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.red
                                                              .withOpacity(.1),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          "Requested: ${item['requested']}",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            screenWidth * 0.02,
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal:
                                                                  screenWidth *
                                                                  0.03,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.green
                                                              .withOpacity(.1),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          "Available: ${item['available']}",
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  ),

                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.black87,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.05,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "OK",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        } else {
                          await stockService.decreaseStockForcart(cart);
                          AppRouter.router.go(AppRouter.kCheckout);
                        }
                      },
                      text: 'Checkout • \$${cubit.total.toStringAsFixed(2)}',
                      backgroundColor: Theme.of(context).primaryColor,
                      size: screenWidth * 0.045,
                      textColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
    );
  }
}
