// auth_repository_impl_test.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/utils/auth_service.dart';
import 'package:depi_app/features/auth/data/repos/auth_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([
  AuthService,
  User, 
])
void main() {
  
  late AuthRepositoryImpl authRepository;
  late MockAuthService mockAuthService;
  late MockUser mockUser; 
  late User tUser; 
  
  late FakeFirebaseFirestore fakeFirestore; 

  setUp(() {
    mockAuthService = MockAuthService();
    mockUser = MockUser();
    tUser = mockUser; 
    

    fakeFirestore = FakeFirebaseFirestore();
    
    authRepository = AuthRepositoryImpl(mockAuthService, firestore: fakeFirestore); 
  });

  group('AuthRepositoryImpl Tests', () {
    const String tEmail = 'test@example.com';
    const String tPassword = 'password123';
    const String tFullName = 'Test User';
    const String tUid = 'uid-123';
    const String tPhone = '1234567890';
    const List<String> tAddresses = ['Address 1', 'Address 2'];
    const String tContext = 'mock_context';


    test('signUp calls AuthService.signUp with correct params', () async {
      when(mockAuthService.signUp(tEmail, tPassword, tFullName))
          .thenAnswer((_) async => tUser); 

      await authRepository.signUp(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      );

      verify(mockAuthService.signUp(tEmail, tPassword, tFullName)).called(1);
    });

    test('updateUserData updates user data in FakeFirestore and calls Firebase Auth methods',
        () async {
      // Arrange
      const String newFullName = 'New Full Name';
      const String newEmail = 'new@example.com';
      
      await fakeFirestore.collection('users').doc(tUid).set({
        'fullName': 'Old Name',
        'email': 'old@example.com',
        'phone': '999',
        'address': ['Old Address'],

      });

      when(mockAuthService.currentUser).thenReturn(mockUser);
      when(mockUser.email).thenReturn('old@example.com'); 
      when(mockUser.verifyBeforeUpdateEmail(newEmail))
          .thenAnswer((_) async => Future.value());
      when(mockUser.updateDisplayName(newFullName))
          .thenAnswer((_) async => Future.value());
      
      // Act
      await authRepository.updateUserData(
        uid: tUid,
        fullName: newFullName,
        email: newEmail, 
        phone: tPhone,
        addresses: tAddresses,
      );

      // Assert
      verify(mockUser.verifyBeforeUpdateEmail(newEmail)).called(1); 
      verify(mockUser.updateDisplayName(newFullName)).called(1); 
      
      final doc = await fakeFirestore.collection('users').doc(tUid).get();
      expect(doc.exists, isTrue);
      expect(doc.data()?['fullName'], newFullName);
      expect(doc.data()?['email'], newEmail);
      expect(doc.data()?['phone'], tPhone);
      expect(doc.data()?['address'], tAddresses);
    });
    

    test('signIn calls AuthService.signIn with correct params', () async {
      when(mockAuthService.signIn(tEmail, tPassword)).thenAnswer((_) async => tUser);
      await authRepository.signIn(email: tEmail, password: tPassword);
      verify(mockAuthService.signIn(tEmail, tPassword)).called(1);
    });

    test('signOut calls AuthService.signOut', () async {
      when(mockAuthService.signOut()).thenAnswer((_) async => Future.value());
      await authRepository.signOut();
      verify(mockAuthService.signOut()).called(1);
    });
    
    test('resetPassword calls AuthService.resetPassword with correct email',
        () async {
      when(mockAuthService.resetPassword(tEmail))
          .thenAnswer((_) async => Future.value());
      await authRepository.resetPassword(email: tEmail);
      verify(mockAuthService.resetPassword(tEmail)).called(1);
    });
  });
}