import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/features/productDetails/data/ReviewService.dart';
import 'package:depi_app/features/productDetails/presentation/data/repos/UserService.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/LikeButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:depi_app/core/models/review.dart';
import 'package:depi_app/core/models/product.dart';

class ProductReviewsExpandableFull extends StatefulWidget {
  final String productId;
  const ProductReviewsExpandableFull({super.key, required this.productId});

  @override
  State<ProductReviewsExpandableFull> createState() =>
      _ProductReviewsExpandableFullState();
}

class _ProductReviewsExpandableFullState
    extends State<ProductReviewsExpandableFull> {
  final TextEditingController _commentController = TextEditingController();
  double _selectedRate = 5;
  final user = FirebaseAuth.instance.currentUser;
  String? userName;
  bool isLoading = true;

  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await UserService().getCurrentUserName();
    setState(() {
      userName = name;
      isLoading = false;
    });
  }

  Future<void> _showAddReviewDialog(List<Review> currentComments) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        late final theme = Theme.of(context);
        final size = MediaQuery.of(context).size;
        final screenWidth = size.width;
        final screenHeight = size.height;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    maxHeight: MediaQuery.of(context).size.height * 0.75,
                  ),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    // gradient: LinearGradient(
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    //   colors: [theme.cardColor, Colors.grey.shade50], //******
                    // ),
                    borderRadius: BorderRadius.circular(20),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: theme.cardColor,
                    //     blurRadius: 20,
                    //     offset: const Offset(0, 10),
                    //   ),
                    // ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header with icon
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.primaryColor.withOpacity(0.1),
                              theme.primaryColor.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.03,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.rate_review_rounded,
                                color: Colors.white,
                                size: screenWidth * 0.03,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Share Your Experience',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Help others make better decisions',
                                    style: theme.textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: screenWidth * 0.03,
                          horizontal: screenHeight * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'How would you rate this product?',
                              style: theme.textTheme.labelMedium,
                            ),
                            const SizedBox(height: 10),

                            // Animated Stars
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (i) {
                                final isSelected = i < _selectedRate;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedRate = (i + 1).toDouble();
                                    });
                                    setDialogState(() {});
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      isSelected
                                          ? Icons.star_rounded
                                          : Icons.star_outline_rounded,
                                      color:
                                          isSelected
                                              ? Colors.amber
                                              : Colors.grey.shade300,
                                      size: 32,
                                    ),
                                  ),
                                );
                              }),
                            ),

                            // Rating Text
                            const SizedBox(height: 6),
                            AnimatedOpacity(
                              opacity: _selectedRate > 0 ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                _getRatingText(_selectedRate.toInt()),
                                style: theme.textTheme.labelLarge,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            labelText: 'Share your thoughts...',
                            labelStyle: theme.textTheme.labelSmall,
                            hintText: 'What did you like or dislike?',
                            hintStyle: theme.textTheme.labelSmall,
                            prefixIcon: Icon(
                              Icons.edit_note_rounded,
                              color: theme.primaryColor.withOpacity(0.6),
                              size: 22,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: theme.cardColor,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                          ),
                          maxLines: 3,
                          maxLength: 500,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _commentController.clear();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenWidth * 0.03,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () async {
                                final commentText =
                                    _commentController.text.trim();
                                if (commentText.isEmpty || _selectedRate == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      elevation: 8,
                                      backgroundColor: Colors.orange,
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
                                            Icons.warning_amber_rounded,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              "Please add rating and comment",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      duration: Duration(milliseconds: 1600),
                                    ),
                                  );

                                  return;
                                }

                                final newReview = Review(
                                  name: userName ?? "",
                                  reviewId:
                                      'temp_${DateTime.now().millisecondsSinceEpoch}',
                                  productId: widget.productId,
                                  senderId: user!.uid,
                                  message: commentText,
                                  rate: _selectedRate.toInt(),
                                  date: Timestamp.now(),
                                  reactNum: 0,
                                );

                                await ProductReviewService().addReviewToProduct(
                                  widget.productId,
                                  newReview,
                                );

                                if (mounted) {
                                  Navigator.pop(context);
                                  _commentController.clear();
                                  setState(() {
                                    _selectedRate = 0;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      elevation: 8,
                                      backgroundColor: Colors.green,
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
                                            Icons.check_circle_outline,
                                            color: Colors.white,
                                            size: 26,
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              "Review submitted successfully!",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      duration: Duration(milliseconds: 1600),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenWidth * 0.03,
                                ),
                                backgroundColor: theme.primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send_rounded, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    'Submit Review',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    late final theme = Theme.of(context);
    return StreamBuilder<Product>(
      stream: ProductReviewService().getProductStream(widget.productId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final product = snapshot.data!;
        final comments = product.comments;

        double total = 0;
        for (var r in comments) total += r.rate;
        final avg = comments.isEmpty ? 0.0 : total / comments.length;

        Map<int, int> distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
        for (var review in comments) {
          int rating = review.rate;
          if (rating >= 1 && rating <= 5) {
            distribution[rating] = (distribution[rating] ?? 0) + 1;
          }
        }

        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: Icon(Icons.reviews, color: theme.primaryColor),
            title: Text('Customer Reviews', style: theme.textTheme.bodyLarge),
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            avg.toStringAsFixed(1),
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: 48,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              5,
                              (i) => Icon(
                                Icons.star,
                                color:
                                    i < avg.round()
                                        ? Colors.amber
                                        : Colors.grey[300],
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${comments.length} reviews',
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children:
                            [5, 4, 3, 2, 1].map((star) {
                              int count = distribution[star] ?? 0;
                              double percentage =
                                  comments.isEmpty
                                      ? 0.0
                                      : (count / comments.length);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '$star',
                                      style: theme.textTheme.labelMedium,
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.star,
                                      size: 14,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: percentage,
                                          backgroundColor: Colors.grey[300],
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                Color
                                              >(Colors.amber),
                                          minHeight: 8,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 20,
                                      child: Text(
                                        '$count',
                                        style: theme.textTheme.labelSmall,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ElevatedButton.icon(
                  onPressed: () => _showAddReviewDialog(comments),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.add_comment, color: Colors.white),
                  label: const Text(
                    'Add a Review',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              ...comments.map<Widget>((r) {
                return Card(
                  color: theme.cardColor,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(r.name, style: theme.textTheme.bodyLarge),
                            Text(
                              formatDate(r.date),
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(r.message, style: theme.textTheme.bodySmall),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: List.generate(
                                r.rate,
                                (i) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                              ),
                            ),
                            LikeButton(
                              likeCount: r.reactNum,
                              reviewId: r.reviewId,
                              onLikePressed: (reviewId) {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
