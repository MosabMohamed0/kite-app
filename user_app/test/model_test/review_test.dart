import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/review.dart';

void main() {
  group('Review Model Tests', () {
    
    // Helper function to create a sample Review
    Review createSampleReview() {
      return Review(
        reviewId: 'r1',
        productId: 'p123',
        date: Timestamp.now(),
        senderId: 'user1',
        message: 'Great product!',
        reactNum: 5,
        rate: 4,
        name: 'John Doe',
      );
    }

    test('should create Review object correctly', () {
      final review = createSampleReview();

      expect(review.reviewId, 'r1');
      expect(review.productId, 'p123');
      expect(review.senderId, 'user1');
      expect(review.message, 'Great product!');
      expect(review.reactNum, 5);
      expect(review.rate, 4);
      expect(review.name, 'John Doe');
      expect(review.date, isA<Timestamp>());
    });

    test('should convert Review to Map correctly', () {
      final review = createSampleReview();
      final map = review.toMap();

      expect(map['reviewId'], 'r1');
      expect(map['productId'], 'p123');
      expect(map['senderId'], 'user1');
      expect(map['message'], 'Great product!');
      expect(map['reactNum'], 5);
      expect(map['rate'], 4);
      expect(map['name'], 'John Doe');
      expect(map['date'], isA<Timestamp>());
    });

    test('should create Review from Map correctly', () {
      final timestamp = Timestamp.now();
      final map = {
        'reviewId': 'r1',
        'productId': 'p123',
        'date': timestamp,
        'senderId': 'user1',
        'message': 'Great product!',
        'reactNum': 5,
        'rate': 4,
        'name': 'John Doe',
      };

      final review = Review.fromMap(map);

      expect(review.reviewId, 'r1');
      expect(review.productId, 'p123');
      expect(review.senderId, 'user1');
      expect(review.message, 'Great product!');
      expect(review.reactNum, 5);
      expect(review.rate, 4);
      expect(review.name, 'John Doe');
      expect(review.date, timestamp);
    });

    test('toMap and fromMap should be consistent', () {
      final review = createSampleReview();
      final map = review.toMap();
      final newReview = Review.fromMap(map);

      expect(newReview.reviewId, review.reviewId);
      expect(newReview.productId, review.productId);
      expect(newReview.senderId, review.senderId);
      expect(newReview.message, review.message);
      expect(newReview.reactNum, review.reactNum);
      expect(newReview.rate, review.rate);
      expect(newReview.name, review.name);
      expect(newReview.date, review.date);
    });

    test('should handle missing values in map', () {
      final map = <String, dynamic>{};
      final review = Review.fromMap(map);

      expect(review.reviewId, '');
      expect(review.productId, '');
      expect(review.senderId, '');
      expect(review.message, '');
      expect(review.reactNum, 0);
      expect(review.rate, 0);
      expect(review.name, '');
      expect(review.date, isA<Timestamp>());
    });
  });
}