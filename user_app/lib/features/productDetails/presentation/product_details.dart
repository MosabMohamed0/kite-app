import 'package:depi_app/core/models/product.dart';
import 'package:depi_app/core/models/selectedProduct.dart';
import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/features/productDetails/data/ReviewService.dart';
import 'package:depi_app/features/productDetails/data/UserService.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/DetailsExpandable.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/FavoriteButton.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/ProductOptionsSelector.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/ProductReviewsExpandable.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/QuantitySelector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cart/presentation/manager/cart_cubit.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  final cartService = CartService();

  ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String? sizeColorBoth;
  String? selectedColor;
  String? selectedSize;
  int get reviewCount => widget.product.comments.length;
  int quantity = 1;
  bool canAddToCart = false;

  @override
  void initState() {
    super.initState();
    sizeColorBoth = widget.product.productAttributeType.name;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    late final theme = Theme.of(context);
    if (widget.product.productAttributeType == ProductAttributeType.none) {
      canAddToCart = true;
    } else if ((widget.product.productAttributeType ==
                ProductAttributeType.color &&
            selectedColor != null) ||
        (widget.product.productAttributeType == ProductAttributeType.size &&
            selectedSize != null)) {
      canAddToCart = true;
    } else if (widget.product.productAttributeType ==
            ProductAttributeType.both &&
        selectedColor != null &&
        selectedSize != null) {
      canAddToCart = true;
    }
    return Scaffold(
      backgroundColor: theme.cardColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            AppRouter.router.go(AppRouter.kHome);
          },
        ),
        elevation: 0,
        actions: [
          FavoriteButton(
            productId: widget.product.id,
            activeColor: Colors.pink,
            inactiveColor: Colors.grey[400],
          ),
          SizedBox(width: 8),
          Icon(Icons.share),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: screenHeight / screenWidth * 0.5,
                child: Image.network(widget.product.photoUrl, fit: BoxFit.fill),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.brand,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.product.name,
                      style: theme.textTheme.displayMedium,
                    ),
                    const SizedBox(height: 8),

                    StreamBuilder<Product>(
                      stream: ProductReviewService().getProductStream(
                        widget.product.id,
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        final product = snapshot.data!;
                        final comments = product.comments;

                        double avgRate = 0;
                        if (comments.isNotEmpty) {
                          avgRate =
                              comments
                                  .map((r) => r.rate)
                                  .reduce((a, b) => a + b) /
                              comments.length;
                        }

                        final reviewCount = comments.length;

                        return Row(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < avgRate.round()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 25,
                                );
                              }),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              avgRate.toStringAsFixed(1),
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '($reviewCount reviews)',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '\$${widget.product.price}',
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    ProductOptionsSelector(
                      sizeColorBoth: sizeColorBoth!,

                      stock: widget.product.stock,
                      onColorSelected: (color) {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      onSizeSelected: (size) {
                        setState(() {
                          selectedSize = size;
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text("Quantity", style: theme.textTheme.headlineSmall),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: QuantitySelector(
                        initialQuantity: 1,
                        min: 1,
                        onChanged: (qty) {
                          quantity = qty;
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    ProductDetailsExpandable(
                      description: widget.product.description,
                      instruction: widget.product.instruction,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProductReviewsExpandableFull(
                  productId: widget.product.id,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: canAddToCart ? theme.primaryColor : Colors.grey,
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed:
              canAddToCart
                  ? () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      print("User not logged in");
                      return;
                    }

                    Map<String, dynamic> productDetails = {
                      "quantity": quantity,
                    };

                    if (widget.product.productAttributeType ==
                            ProductAttributeType.color ||
                        widget.product.productAttributeType ==
                            ProductAttributeType.both) {
                      if (selectedColor != null) {
                        productDetails["color"] = selectedColor;
                      }
                    }

                    if (widget.product.productAttributeType ==
                            ProductAttributeType.size ||
                        widget.product.productAttributeType ==
                            ProductAttributeType.both) {
                      if (selectedSize != null) {
                        productDetails["size"] = selectedSize;
                      }
                    }

                    final productToAdd = ProductSelected(
                      id: user.uid,
                      productId: widget.product.id,
                      name: widget.product.name,
                      price: widget.product.price,
                      photoURL: widget.product.photoUrl,
                      brand: widget.product.brand,
                      category: widget.product.category,
                      productDetails: productDetails,
                    );

                    await CartService().addToCart(user.uid, productToAdd);
                    context.read<CartCubit>().loadCart();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        elevation: 8,
                        backgroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        content: Row(
                          children: const [
                            Icon(
                              Icons.check_circle,
                              color: Colors.greenAccent,
                              size: 28,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Added to cart",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        duration: Duration(milliseconds: 1500),
                      ),
                    );
                  }
                  : null,

          child: Text(
            'Add to Cart',
            style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
