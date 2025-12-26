import 'package:depi_app/features/favorite_screen/FavoriteScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:depi_app/core/models/product.dart';
import 'package:depi_app/core/cubit/FavoritesCubit/favorites_cubit.dart';
import 'package:depi_app/core/cubit/FavoritesCubit/favorites_state.dart';


// 1. Create Mock Cubit
class MockFavoritesCubit extends MockCubit<FavoritesState> implements FavoritesCubit {}

void main() {
  // 2. Setup dummy product
  final tProduct = Product(
    id: 'p1', name: 'Cool Shirt', price: 55.50, photoUrl: 'url',
    comments: [], reviews: 25, brand: 'Zara', category: 'Clothing',
    description: '', instruction: [], stock: 10, rate: 4.2,
    productAttributeType: ProductAttributeType.none,
    date: Timestamp.now(),
  );
  
  // 3. Test the Card (FavoriteProductCard)
  testWidgets('FavoriteProductCard should display product name, price, and brand', (WidgetTester tester) async {
    
    final mockCubit = MockFavoritesCubit();
    
    // Correct solution for the 'state' Getter: return the value directly
    when(() => mockCubit.state).thenReturn(
        const FavoritesState(favorites: {'p1'}, loading: false)
    );
    
    // We need to mock any function that might be called during the build process
    when(() => mockCubit.toggleFavorite(any())).thenAnswer((_) async {});
    when(() => mockCubit.removeFavorite(any())).thenAnswer((_) async {});

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<FavoritesCubit>.value(
          value: mockCubit,
          // The card needs a userId to determine the path
          child: FavoriteProductCard(
            product: tProduct,
            userId: 'test_user_id', 
          ),
        ),
      ),
    );

    await tester.pump();

    // 4. Assert: Verify the basic elements are present (your simple requests)
    expect(find.text('Cool Shirt'), findsOneWidget); // Find the name
    expect(find.text('Zara'), findsOneWidget); // Find the Brand
    expect(find.text('\$56'), findsOneWidget); // Find the price
    expect(find.byIcon(Icons.favorite), findsOneWidget); // Find the heart icon
  });
}