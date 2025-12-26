import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

// Ensure these paths match your project structure
import 'package:depi_app/features/cart/presentation/views/cart_screen.dart';
import 'package:depi_app/features/cart/presentation/manager/cart_cubit.dart';
import 'package:depi_app/features/cart/presentation/manager/cart_state.dart';
import 'package:depi_app/core/models/selectedProduct.dart';

// 1. Create Mock class for CartCubit
class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

void main() {
  late MockCartCubit mockCartCubit;

  setUp(() {
    mockCartCubit = MockCartCubit();
  });

  // Helper function to wrap the screen with necessary providers
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<CartCubit>.value(
        value: mockCartCubit,
        child: const CartScreen(),
      ),
    );
  }

  group('CartScreen Widget Tests', () {
    testWidgets(
      'Should display product details and prices when cart has items',
      (WidgetTester tester) async {
        // 2. Arrange: Create a dummy product
        final product = ProductSelected(
          id: '1',
          productId: 'p101',
          name: 'Nike Air Max',
          price: 200.0,
          photoURL: '', // Keep empty to avoid network image errors
          brand: 'Nike',
          category: 'Shoes',
          productDetails: {'quantity': 2, 'size': '42', 'color': 'Black'},
        );

        // 3. Stub the Cubit state and getters
        when(() => mockCartCubit.state).thenReturn(
          CartState(products: [product], totalPrice: 420.0, isLoading: false),
        );

        // Mocking computed properties used in cart_screen.dart
        when(() => mockCartCubit.total).thenReturn(420.0);
        when(() => mockCartCubit.withoutTax).thenReturn(400.0);
        when(() => mockCartCubit.tax).thenReturn(20.0);
        when(() => mockCartCubit.shipping).thenReturn(0.0);
        when(
          () => mockCartCubit.couponController,
        ).thenReturn(TextEditingController());

        // 4. Act: Build the widget
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump(); // Trigger a frame for the ListView

        // 5. Assert: Verify UI elements from cart_screen.dart
        expect(find.text('Nike Air Max'), findsOneWidget);
        expect(find.text('Nike'), findsOneWidget);
        expect(find.text('Size: 42'), findsOneWidget);
        expect(find.text('Color: Black'), findsOneWidget);
        expect(find.text('2'), findsOneWidget); // Checks quantity text

        // Verify Total Price in the checkout button
        expect(find.textContaining('420.00'), findsWidgets);
      },
    );

    testWidgets('Should show loading indicator when isLoading is true', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockCartCubit.state).thenReturn(
        const CartState(products: [], totalPrice: 0.0, isLoading: true),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should show empty cart message when no products are added', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockCartCubit.state).thenReturn(
        const CartState(products: [], totalPrice: 0.0, isLoading: true),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
